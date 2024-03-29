import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:seekihod/pages/category_page.dart';
import '../UI/theme_provider.dart';
import '../models/SpotModel.dart';
import '../pages/spot_page.dart';

class HomewView extends StatefulWidget {
  const HomewView({Key? key}) : super(key: key);

  @override
  State<HomewView> createState() => _HomewViewState();
}

class _HomewViewState extends State<HomewView> {
  final MyThemes myThemes = MyThemes();
  List<SpotModel> results = [];
  List<SpotModel> touristSpot = [];
  List<SpotModel> accommodation = [];
  List<SpotModel> food = [];
  List<SpotModel> activities = [];

  List<SpotModel> model = [];
  double screenHeight = 0;
  double screenWidth = 0;

  var rand = Random();

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 15),
              child: Text(
                dayNightTime(),
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: myThemes.getFontwithOpacity(context, .6)),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 15),
              child: const Text(
                'Welcome to Siquijor',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                child: Image.asset('lib/assets/images/3.jpg'),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            categoryHeader('Tourist Spot', 'spot'),
            getListType(touristSpot, 'Tourist Spot'),
            const SizedBox(
              height: 15,
            ),
            categoryHeader('Accommodation', 'accommodation'),
            getListType(accommodation, 'Accommodation'),
            const SizedBox(
              height: 15,
            ),
            categoryHeader('Food', 'food'),
            getListType(food, 'Food'),
            const SizedBox(
              height: 15,
            ),
            categoryHeader('Activity', 'activity'),
            getListType(activities, 'Activity'),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }

  Widget listCard(SpotModel currentModel, BuildContext context) => SizedBox(
        width: screenWidth / 1.5,
        child: InkWell(
          onTap: () {
            showModalBottomSheet(
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                context: context,
                builder: (context) => SpotPage(
                      spotModel: currentModel,
                    ));
          },
          child: Card(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(10),
                          top: Radius.circular(20)),
                      child: Container(
                        height: (screenHeight / 4) / 2,
                        child: Container(
                          width: screenWidth / 1.5,
                          color: Colors.transparent,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.network(
                                currentModel.images[
                                    rand.nextInt(currentModel.images.length)],
                                fit: BoxFit.cover,
                                errorBuilder: (BuildContext context,
                                    Object exception, StackTrace? stackTrace) {
                                  return Center(
                                      child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(Icons.error_outline),
                                      Text("Failed to load Images"),
                                    ],
                                  ));
                                },
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withOpacity(.6),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            width: (screenWidth / 1.5) / 3.2,
                            height: (screenHeight / 4) / 2.8,
                            color: Colors.transparent,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.network(
                                  errorBuilder: (BuildContext context,
                                      Object exception,
                                      StackTrace? stackTrace) {
                                    return const Center(
                                        child: Center(
                                            child: Icon(Icons.error_outline)));
                                  },
                                  currentModel.imgUrl,
                                  fit: BoxFit.cover,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withOpacity(.6),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 25,
                      ),
                      Container(
                        width: (screenWidth / 1.5) / 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentModel.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              currentModel.address,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Text(
                              currentModel.type.toUpperCase(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            const Text(
                              'Ratings here',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );

  List<SpotModel> getModels(List<SpotModel> allSpot, String type) {
    List<SpotModel> thisModel = [];
    for (int index = 1; index <= allSpot.length; index++) {
      SpotModel currentModel = allSpot[index - 1];
      if (currentModel.type == type) {
        thisModel.add(currentModel);
      }
    }
    return thisModel;
  }

  Widget categoryHeader(
    String type,
    String icon,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
      ),
      child: SizedBox(
        height: 30,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.only(right: 10),
                  height: 20,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Container(
                      color: spotColor(icon),
                      child: Image.asset(
                        getSpotIcon(icon),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Text(
                  type,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            IconButton(
              onPressed: () {
                if (type == 'Tourist Spot') {
                  model = getModels(results, 'spot');
                }
                if (type == 'Accommodation') {
                  model = getModels(results, 'accommodation');
                }
                if (type == 'Food') {
                  model = getModels(results, 'food');
                }
                if (type == 'Activity') {
                  model = getModels(results, 'activity');
                }
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CategoryPage(
                          currentModel: model,
                          type: type,
                        )));
              },
              icon: const Icon(EvaIcons.arrowCircleRightOutline),
            )
          ],
        ),
      ),
    );
  }

  Widget getListType(List<SpotModel> listType, String type) {
    return Container(
      height: screenHeight / 4,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: StreamBuilder<List<SpotModel>>(
        stream: readSpots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            results = snapshot.data!;

            if (type == 'Tourist Spot') {
              listType = getModels(results, 'spot');
            }
            if (type == 'Accommodation') {
              listType = getModels(results, 'accommodation');
            }
            if (type == 'Food') {
              listType = getModels(results, 'food');
            }
            if (type == 'Activity') {
              listType = getModels(results, 'activity');
            }
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: listType.length,
              itemBuilder: ((context, index) {
                SpotModel currentModel = listType[index];
                return listCard(currentModel, context);
              }),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget buildImage(String images, int index) => Container(
        width: 260,
        color: Colors.grey,
        child: Image.network(
          images,
          fit: BoxFit.cover,
        ),
      );

  Color spotColor(String currentModel) {
    if (currentModel == 'spot') {
      return myThemes.spotColor;
    } else if (currentModel == 'food') {
      return myThemes.foodColor;
    } else if (currentModel == 'accommodation') {
      return myThemes.accomodationColor;
    } else if (currentModel == 'activity') {
      return myThemes.activityColor;
    } else {
      return Colors.orange;
    }
  }

  String getSpotIcon(String type) {
    switch (type) {
      case 'spot':
        return 'lib/assets/icons/icons8-beach-48.png';
      case 'food':
        return 'lib/assets/icons/icons8-food-and-wine-48.png';
      case 'accommodation':
        return 'lib/assets/icons/icons8-condo-48.png';
      case 'activity':
        return 'lib/assets/icons/icons8-wakeboarding-48.png';
      default:
        return 'Icon spot type error';
    }
  }

  String dayNightTime() {
    var current = DateTime.now().hour;

    if (current >= 18) {
      return 'Good Evening';
    } else if (current >= 13) {
      return 'Good Afternoon';
    } else if (current >= 10) {
      return 'Good Noon';
    } else {
      return 'Good Morning';
    }
  }

  Stream<List<SpotModel>> readSpots() => FirebaseFirestore.instance
      .collection('Spots')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => SpotModel.fromJson(doc.data())).toList());
}
