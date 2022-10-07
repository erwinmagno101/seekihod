import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import '../UI/theme_provider.dart';
import '../models/SpotModel.dart';
import '../pages/spot_page.dart';

class DirectoryView extends StatefulWidget {
  const DirectoryView({Key? key}) : super(key: key);

  @override
  State<DirectoryView> createState() => _DirectoryViewState();
}

class _DirectoryViewState extends State<DirectoryView> {
  List<SpotModel> searchResults = [];
  List<SpotModel> suggestions = [];
  String gg = '';
  final MyThemes myThemes = MyThemes();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 15),
          child: Text(
            'Browse',
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
            'The Best of Siquijior',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: TextField(
            enableSuggestions: false,
            keyboardType: TextInputType.name,
            autocorrect: false,
            cursorColor: myThemes.getIconColor(context),
            style: const TextStyle(fontSize: 20),
            onChanged: searchSpot,
            decoration: InputDecoration(
              helperText: 'Find The Spot your looking for!',
              helperStyle:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              filled: true,
              fillColor: myThemes.getSecondaryColor(context),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              isDense: true,
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                      width: 1, color: myThemes.getIconColor(context))),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(20)),
              labelText: 'Search a Tourist Spot',
              labelStyle: TextStyle(
                  fontSize: 20, color: myThemes.getIconColor(context)),
              floatingLabelStyle: TextStyle(
                  color: myThemes.getIconColor(context), fontSize: 20),
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder<List<SpotModel>>(
            stream: readSpots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: Text(""));
              } else if (snapshot.hasError) {
                return const Center(child: Text("An Error Occured"));
              } else if (snapshot.hasData) {
                if (suggestions.isEmpty && gg == '') {
                  searchResults = snapshot.data!;
                  return ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: searchResults.length,
                      itemBuilder: (context, index) {
                        searchResults.sort((a, b) => a.name.compareTo(b.name));
                        SpotModel currentModel = searchResults[index];
                        return tileDisplay(currentModel, context);
                      });
                } else {
                  searchResults = snapshot.data!;
                  return ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: suggestions.length,
                      itemBuilder: (context, index) {
                        suggestions.sort((a, b) => a.name.compareTo(b.name));
                        SpotModel currentModel = suggestions[index];
                        return tileDisplay(currentModel, context);
                      });
                }
              } else {
                return const Center(child: Text("An Error occured"));
              }
            },
          ),
        ),
      ],
    ));
  }

  Widget tileDisplay(SpotModel currentModel, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 1),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => SpotPage(spotModel: currentModel)));
        },
        child: Card(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: myThemes.getPrimaryColor(context),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.2),
                  spreadRadius: .1,
                  blurRadius: .1,
                )
              ],
            ),
            height: 200,
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
                  alignment: AlignmentDirectional.topEnd,
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        width: 25,
                        color: spotColor(currentModel),
                        child: Image.asset(
                          getSpotIcon(currentModel.type),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Align(
                    alignment: AlignmentDirectional.bottomStart,
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  currentModel.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: myThemes.getFontAllWhite(context),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  currentModel.descriptionHeader,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: myThemes.getFontAllWhite(context),
                                      fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            'Ratings Here',
                            style: TextStyle(
                                color: myThemes.getFontAllWhite(context)),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Stream<List<SpotModel>> readSpots() => FirebaseFirestore.instance
      .collection('Spots')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => SpotModel.fromJson(doc.data())).toList());

  void searchSpot(String query) {
    suggestions = searchResults.where((searchResults) {
      final result = searchResults.name.toLowerCase();
      final input = query.toLowerCase();
      gg = input;
      return result.contains(input);
    }).toList();

    setState(() => searchResults = suggestions);
  }

  Color spotColor(SpotModel currentModel) {
    if (currentModel.type == 'spot') {
      return myThemes.spotColor;
    } else if (currentModel.type == 'food') {
      return myThemes.foodColor;
    } else if (currentModel.type == 'accomodation') {
      return myThemes.accomodationColor;
    } else if (currentModel.type == 'activity') {
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
      case 'accomodation':
        return 'lib/assets/icons/icons8-condo-48.png';
      case 'activity':
        return 'lib/assets/icons/icons8-wakeboarding-48.png';
      default:
        return 'Icon spot type error';
    }
  }
}
