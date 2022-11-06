import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:seekihod/UI/theme_provider.dart';
import 'package:seekihod/models/GlobalVar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/NewsModel.dart';
import '../models/SpotModel.dart';
import '../pages/spot_page.dart';

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
  globalVar global = globalVar();
  Random rand = Random();

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
              StreamBuilder<List<SpotModel>>(
                stream: readSpots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<SpotModel> featureList = snapshot.data!;
                    globalVar.featureModel ??=
                        featureList[rand.nextInt(featureList.length)];
                    return Container(
                      height: 270,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Stack(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: 15, right: 15, bottom: 25, top: 15),
                            child: InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    context: context,
                                    builder: (context) => SpotPage(
                                          spotModel: globalVar.featureModel!,
                                        ));
                              },
                              child: Card(
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    if (globalVar.featureModel != null)
                                      Image.network(
                                        globalVar.featureModel!.imgUrl,
                                        fit: BoxFit.cover,
                                      ),
                                    Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.transparent,
                                            Colors.black.withOpacity(.3),
                                          ],
                                        ),
                                      ),
                                    ),
                                    if (globalVar.featureModel != null)
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Text(
                                          globalVar.featureModel!.name,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 25,
                                              color: myThemes
                                                  .getFontAllWhite(context),
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const Align(
                            alignment: Alignment.topRight,
                            child: Icon(
                              EvaIcons.star,
                              color: Colors.yellow,
                              size: 70,
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Center(child: Text("No data"));
                  }
                },
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
              StreamBuilder<List<SpotModel>>(
                stream: readSpots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    spotList = snapshot.data!;

                    return Container(
                      height: 150,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: ((context, index) {
                          SpotModel currentModel = spotList[index];
                          return seeMoreListTile(currentModel: currentModel);
                        }),
                      ),
                    );
                  } else {
                    return Center(
                      child: Text("No Date"),
                    );
                  }
                },
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

  Widget seeMoreListTile({required SpotModel currentModel}) {
    return InkWell(
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
        child: Container(
          width: 150,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
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
                      Colors.black.withOpacity(.8),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 15,
                  ),
                  child: Text(
                    currentModel.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: myThemes.getFontAllWhite(context),
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              )
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
                return InkWell(
                  onTap: () async {
                    final url = Uri.parse(currentFeatureModel.link);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(
                        url,
                        webViewConfiguration:
                            const WebViewConfiguration(enableJavaScript: true),
                        mode: LaunchMode.externalApplication,
                      );
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  child: Card(
                    child: Container(
                      width: MediaQuery.of(context).size.width / 1.3,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            currentFeatureModel.imgUrl,
                            fit: BoxFit.cover,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(.8),
                                ],
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    currentFeatureModel.title,
                                    style: TextStyle(
                                        color:
                                            myThemes.getFontAllWhite(context),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                  Text(
                                    currentFeatureModel.description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
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
