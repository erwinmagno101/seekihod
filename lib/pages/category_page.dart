import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:seekihod/UI/theme_provider.dart';
import 'package:seekihod/models/SpotModel.dart';
import 'package:seekihod/pages/spot_page.dart';

class CategoryPage extends StatefulWidget {
  List<SpotModel> currentModel;
  String type;
  CategoryPage({super.key, required this.currentModel, required this.type});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

final MyThemes myThemes = MyThemes();

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(widget.type),
      ),
      body: ListView.builder(
        itemCount: widget.currentModel.length,
        itemBuilder: (context, index) {
          SpotModel currentModel = widget.currentModel[index];
          return tileDisplay(currentModel, context);
        },
      ),
    );
  }

  Widget tileDisplay(SpotModel currentModel, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 1),
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
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace? stackTrace) {
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

  Color spotColor(SpotModel currentModel) {
    if (currentModel.type == 'spot') {
      return myThemes.spotColor;
    } else if (currentModel.type == 'food') {
      return myThemes.foodColor;
    } else if (currentModel.type == 'accommodation') {
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
      case 'accommodation':
        return 'lib/assets/icons/icons8-condo-48.png';
      case 'activity':
        return 'lib/assets/icons/icons8-wakeboarding-48.png';
      default:
        return 'Icon spot type error';
    }
  }
}
