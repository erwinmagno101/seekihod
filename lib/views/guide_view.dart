import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:seekihod/UI/theme_provider.dart';
import 'package:seekihod/models/SpotModel.dart';

import '../pages/spot_page.dart';

class GuideView extends StatefulWidget {
  const GuideView({super.key});

  @override
  State<GuideView> createState() => _GuideViewState();
}

MyThemes myThemes = MyThemes();

class _GuideViewState extends State<GuideView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 130,
            automaticallyImplyLeading: false,
            title: Column(
              children: const [
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Tourist Attraction Statistics",
                  style: TextStyle(fontWeight: FontWeight.normal),
                ),
                TabBar(
                  tabs: [
                    Tab(
                      text: "Engagement",
                      icon: Icon(Icons.check),
                    ),
                    Tab(
                      text: "Review",
                      icon: Icon(Icons.star),
                    ),
                    Tab(
                      text: "Comment",
                      icon: Icon(Icons.comment),
                    )
                  ],
                ),
              ],
            ),
          ),
          body: StreamBuilder<List<SpotModel>>(
            stream: readSpots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<SpotModel> models = snapshot.data!;
                return TabBarView(
                  children: [
                    engagementTab(models: models),
                    reviewTab(models: models),
                    commentTab(models: models),
                  ],
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget engagementTab({required List<SpotModel> models}) {
    List<SpotModel> sortedModels = models
      ..sort(
          (a, b) => int.parse(b.engagement).compareTo(int.parse(a.engagement)));

    SpotModel topModel = sortedModels[0];
    sortedModels.removeAt(0);
    SpotModel secondModel = sortedModels[0];
    sortedModels.removeAt(0);
    SpotModel thirdModel = sortedModels[0];
    sortedModels.removeAt(0);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(
              height: 20,
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Ranked by Engagement",
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Top Attractions"),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "1 .",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (context) => SpotPage(
                              spotModel: topModel,
                            ));
                  },
                  child: Card(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      height: 150,
                      width: MediaQuery.of(context).size.width / 1.2,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            HexColor("#FFD700"),
                            myThemes.getSecondaryColor(context),
                          ],
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: double.infinity,
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.network(
                                topModel.imgUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            width: MediaQuery.of(context).size.width / 2.7,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  topModel.name,
                                  maxLines: 2,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Engagement:  ${topModel.engagement}",
                                  maxLines: 2,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "2 .",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (context) => SpotPage(
                              spotModel: secondModel,
                            ));
                  },
                  child: Card(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      height: 150,
                      width: MediaQuery.of(context).size.width / 1.2,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            HexColor("#C0C0C0"),
                            myThemes.getSecondaryColor(context),
                          ],
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: double.infinity,
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.network(
                                secondModel.imgUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            width: MediaQuery.of(context).size.width / 2.7,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  secondModel.name,
                                  maxLines: 2,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Engagement:  ${secondModel.engagement}",
                                  maxLines: 2,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "3 .",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (context) => SpotPage(
                              spotModel: thirdModel,
                            ));
                  },
                  child: Card(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      height: 150,
                      width: MediaQuery.of(context).size.width / 1.2,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            HexColor("#CD7F32"),
                            myThemes.getSecondaryColor(context),
                          ],
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: double.infinity,
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.network(
                                thirdModel.imgUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            width: MediaQuery.of(context).size.width / 2.7,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  thirdModel.name,
                                  maxLines: 2,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Engagement:  ${thirdModel.engagement}",
                                  maxLines: 2,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("More Attractions"),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: MediaQuery.of(context).size.height / 2.2,
              child: ListView.builder(
                itemCount: sortedModels.length,
                itemBuilder: (context, index) {
                  SpotModel currentModel = sortedModels[index];
                  return Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${index + 4} .",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      InkWell(
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
                            padding: EdgeInsets.all(10),
                            height: 150,
                            width: MediaQuery.of(context).size.width / 1.2,
                            color: myThemes.getSecondaryColor(context),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: double.infinity,
                                  width:
                                      MediaQuery.of(context).size.width / 2.5,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.network(
                                      currentModel.imgUrl,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  width:
                                      MediaQuery.of(context).size.width / 2.7,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        currentModel.name,
                                        maxLines: 2,
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        "Engagement:  ${currentModel.engagement}",
                                        maxLines: 2,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget reviewTab({required List<SpotModel> models}) {
    return Container(
      child: const Center(
        child: Text("Review Here"),
      ),
    );
  }

  Widget commentTab({required List<SpotModel> models}) {
    return Container(
      child: const Center(
        child: Text("Comment Here"),
      ),
    );
  }

  Stream<List<SpotModel>> readSpots() => FirebaseFirestore.instance
      .collection('Spots')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => SpotModel.fromJson(doc.data())).toList());
}
