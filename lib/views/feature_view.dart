import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:seekihod/UI/theme_provider.dart';

import '../models/NewsModel.dart';
import '../models/SpotModel.dart';

class FeatureView extends StatefulWidget {
  const FeatureView({Key? key}) : super(key: key);

  @override
  State<FeatureView> createState() => _FeatureViewState();
}

class _FeatureViewState extends State<FeatureView> {
  List<NewsModel> result = [];
  List<NewsModel> newsList = [];
  List<NewsModel> articlesList = [];
  List<SpotModel> spotList = [];

  MyThemes myThemes = MyThemes();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Featuring',
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: myThemes.getFontwithOpacity(context, .6)),
              ),
              const Text(
                "Today's Spotlight",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                height: 250,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Card(),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                "See Also",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemBuilder: ((context, index) {
                    return Container(
                      child: Card(),
                      width: 150,
                    );
                  }),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                "News and Updates",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              getContentType(newsList, 'News'),
              const SizedBox(
                height: 15,
              ),
              const Text(
                "Articles",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              getContentType(articlesList, 'Article'),
            ],
          ),
        ),
      ),
    );
  }

  Stream<List<NewsModel>> readContent() => FirebaseFirestore.instance
      .collection('Content')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => NewsModel.fromJson(doc.data())).toList());

  Widget getContentType(List<NewsModel> contentType, String type) {
    return Container(
      height: 200,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: StreamBuilder<List<NewsModel>>(
        stream: readContent(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            result = snapshot.data!;
            if (type == 'News') {
              contentType = getModels(result, 'news');
            }
            if (type == 'Article') {
              contentType = getModels(result, 'article');
            }

            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: contentType.length,
              itemBuilder: ((context, index) {
                NewsModel currentFeatureModel = contentType[index];
                return Card(
                  child: Container(
                    width: MediaQuery.of(context).size.width - 30,
                    child: Text(currentFeatureModel.title),
                  ),
                );
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

  List<NewsModel> getModels(List<NewsModel> allSpot, String type) {
    List<NewsModel> thisModel = [];
    for (int index = 1; index <= allSpot.length; index++) {
      NewsModel currentModel = allSpot[index - 1];
      if (currentModel.type == type) {
        thisModel.add(currentModel);
      }
    }
    return thisModel;
  }

  Widget categoryHeader(String type, Icon icon) {
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
                    child: icon,
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
          ],
        ),
      ),
    );
  }

  Stream<List<SpotModel>> readSpots() => FirebaseFirestore.instance
      .collection('Spots')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => SpotModel.fromJson(doc.data())).toList());
}
