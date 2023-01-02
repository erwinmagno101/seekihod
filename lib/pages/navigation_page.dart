import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:line_icons/line_icon.dart';
import 'package:seekihod/UI/theme_provider.dart';
import 'package:seekihod/copyrights_page.dart';
import 'package:http/http.dart' as http;
import "dart:convert" as convert;
import 'dart:math';

import 'package:seekihod/models/SpotModel.dart';

class MapScreen extends StatefulWidget {
  final SpotModel spotModel;
  const MapScreen({Key? key, required this.spotModel}) : super(key: key);

  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  late final MapController mapController;

  final String apiKey = "BMs6oew1GM8aJTAwfJOgAsTtZTgqqOLT";
  var currentLocation;
  final MyThemes myThemes = MyThemes();

  @override
  void initState() {
    super.initState();
    mapController = MapController();
  }

  void _animatedMapMove(LatLng destLocation, double destZoom) {
    // Create some tweens. These serve to split up the transition from one location to another.
    // In our case, we want to split the transition be<tween> our current map center and the destination.
    final latTween = Tween<double>(
        begin: mapController.center.latitude, end: destLocation.latitude);
    final lngTween = Tween<double>(
        begin: mapController.center.longitude, end: destLocation.longitude);
    final zoomTween = Tween<double>(begin: mapController.zoom, end: destZoom);

    // Create a animation controller that has a duration and a TickerProvider.
    final controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    // The animation determines what path the animation will take. You can try different Curves values, although I found
    // fastOutSlowIn to be my favorite.
    final Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      mapController.move(
          LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
          zoomTween.evaluate(animation));
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final destinationLocation = LatLng(widget.spotModel.geoPoint.latitude,
        widget.spotModel.geoPoint.longitude);

    return FutureBuilder<Position>(
        future: _determinePosition(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            currentLocation =
                LatLng(snapshot.data!.latitude, snapshot.data!.longitude);
            String curLocLat = snapshot.data!.latitude.toString();
            String curLocLon = snapshot.data!.longitude.toString();
            var centerView = currentLocation;
            return FutureBuilder<http.Response>(
                future: getRoute(
                    curLocLat,
                    curLocLon,
                    destinationLocation.latitude.toString(),
                    destinationLocation.longitude.toString()),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    http.Response result = snapshot.data!;
                    Map<String, dynamic> decodedJson = json.decode(result.body);
                    List<dynamic> routes = decodedJson['routes'];
                    Map<String, dynamic> summary1 = routes[0];
                    Map<String, dynamic> travel = routes[0]['summary'];
                    List<dynamic> legs = summary1['legs'];
                    Map<String, dynamic> summary2 = legs[0];
                    List<dynamic> points = summary2['points'];
                    List<LatLng> point = List.empty(growable: true);
                    String lengthInMeters =
                        (roundDouble(travel['lengthInMeters'] / 1000, 1))
                            .toString();
                    String travelTimeInSeconds =
                        (roundDouble(travel['travelTimeInSeconds'] / 60, 1))
                            .toString();
                    for (int i = 0; i < points.length; i++) {
                      point.add(LatLng(
                          points[i]['latitude'], points[i]['longitude']));
                    }

                    return Scaffold(
                      body: Center(
                        child: Stack(
                          children: [
                            FlutterMap(
                              mapController: mapController,
                              options: MapOptions(
                                  center: centerView,
                                  zoom: 15.0,
                                  minZoom: 11,
                                  maxZoom: 15),
                              nonRotatedChildren: [
                                TileLayer(
                                  urlTemplate:
                                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                  additionalOptions: {"apiKey": apiKey},
                                ),
                                MarkerLayer(
                                  markers: [
                                    Marker(
                                      width: 80.0,
                                      height: 80.0,
                                      point: currentLocation,
                                      builder: (BuildContext context) =>
                                          const Icon(Icons.location_on,
                                              size: 30.0, color: Colors.blue),
                                    ),
                                    Marker(
                                      width: 80.0,
                                      height: 80.0,
                                      point: destinationLocation,
                                      builder: (BuildContext context) =>
                                          const Icon(Icons.location_on,
                                              size: 30.0, color: Colors.red),
                                    ),
                                  ],
                                ),
                                PolylineLayer(
                                  polylines: [
                                    Polyline(
                                        points: point,
                                        color: Colors.green,
                                        strokeWidth: 5)
                                  ],
                                )
                              ],
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                margin: const EdgeInsets.only(
                                    top: 50, left: 20, right: 20),
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      widget.spotModel.name,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "$lengthInMeters Kilometers",
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue),
                                        ),
                                        const Text(
                                          " In Distance",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          "Approximately ",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                        Text(
                                          " $travelTimeInSeconds Minutes",
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green),
                                        ),
                                        const Text(
                                          " Travel Time",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      floatingActionButton: SpeedDial(
                        backgroundColor: myThemes.getIconColor(context),
                        spacing: 5,
                        spaceBetweenChildren: 5,
                        overlayColor: Colors.black,
                        overlayOpacity: 0.3,
                        animatedIcon: AnimatedIcons.menu_close,
                        children: [
                          SpeedDialChild(
                            child: const Icon(Icons.person),
                            label: 'Origin',
                            onTap: () {
                              _animatedMapMove(currentLocation, 13);
                            },
                          ),
                          SpeedDialChild(
                            child: const Icon(Icons.gps_fixed),
                            label: 'Destination',
                            onTap: () {
                              _animatedMapMove(destinationLocation, 13);
                            },
                          ),
                        ],
                      ),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                });
          } else {
            print(snapshot.error);
            return Container();
          }
        });
  }

  Future<http.Response> getRoute(String curLocLat, String curLocLon,
      String desLocLat, String desLocLon) async {
    var url =
        "https://api.tomtom.com/routing/1/calculateRoute/$curLocLat,$curLocLon:$desLocLat,$desLocLon/json?key=$apiKey";
    var response = await http.get(Uri.parse(url));
    return response;
  }

  Future<http.Response> getCopyrightsJSONResponse() async {
    var url = "https://api.tomtom.com/map/1/copyrights.json?key=$apiKey";
    var response = await http.get(Uri.parse(url));
    return response;
  }

  String parseCopyrightsResponse(http.Response response) {
    if (response.statusCode == 200) {
      StringBuffer stringBuffer = StringBuffer();
      var jsonResponse = convert.jsonDecode(response.body);
      parseGeneralCopyrights(jsonResponse, stringBuffer);
      parseRegionsCopyrights(jsonResponse, stringBuffer);
      return stringBuffer.toString();
    }
    return "Can't get copyrights";
  }

  void parseRegionsCopyrights(jsonResponse, StringBuffer sb) {
    List<dynamic> copyrightsRegions = jsonResponse["regions"];
    copyrightsRegions.forEach((element) {
      sb.writeln(element["country"]["label"]);
      List<dynamic> cpy = element["copyrights"];
      cpy.forEach((e) {
        sb.writeln(e);
      });
      sb.writeln("");
    });
  }

  void parseGeneralCopyrights(jsonResponse, StringBuffer sb) {
    List<dynamic> generalCopyrights = jsonResponse["generalCopyrights"];
    generalCopyrights.forEach((element) {
      sb.writeln(element);
      sb.writeln("");
    });
    sb.writeln("");
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  double roundDouble(double value, int places) {
    double mod = pow(10.0, places) as double;
    return ((value * mod).round().toDouble() / mod);
  }
}
