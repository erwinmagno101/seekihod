import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:seekihod/copyrights_page.dart';
import 'package:http/http.dart' as http;
import "dart:convert" as convert;

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  final String apiKey = "BMs6oew1GM8aJTAwfJOgAsTtZTgqqOLT";
  var currentLocation;
  final destinationLocation = LatLng(9.2176346, 123.6679914);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Position>(
        future: _determinePosition(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data!.latitude);
            currentLocation =
                LatLng(snapshot.data!.latitude, snapshot.data!.longitude);
            String curLocLat = snapshot.data!.latitude.toString();
            String curLocLon = snapshot.data!.longitude.toString();
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
                    List<dynamic> legs = summary1['legs'];
                    Map<String, dynamic> summary2 = legs[0];
                    List<dynamic> points = summary2['points'];
                    List<LatLng> point = List.empty(growable: true);

                    for (int i = 0; i < points.length; i++) {
                      point.add(LatLng(
                          points[i]['latitude'], points[i]['longitude']));
                    }

                    return Scaffold(
                      body: Center(
                        child: Stack(
                          children: [
                            FlutterMap(
                              options: MapOptions(
                                center: currentLocation,
                                zoom: 13.0,
                              ),
                              children: [
                                TileLayer(
                                  urlTemplate:
                                      "https://api.tomtom.com/map/1/tile/basic/main/"
                                      "{z}/{x}/{y}.png?key={apiKey}",
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
                            Container(
                              padding: EdgeInsets.all(20),
                              alignment: Alignment.bottomLeft,
                              child: Image.asset(
                                'lib/assets/images/tomtomLogo.png',
                                width: 100,
                              ),
                            ),
                          ],
                        ),
                      ),
                      floatingActionButton: FloatingActionButton(
                        child: Icon(Icons.copyright),
                        onPressed: () async {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => CopyrightsPage(
                          //             copyrightsText: parseCopyrightsResponse(response))));
                        },
                      ),
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
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
}
