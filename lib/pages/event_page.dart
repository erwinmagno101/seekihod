import 'package:carousel_slider/carousel_slider.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:seekihod/models/EventModel.dart';

import 'package:seekihod/models/SpotModel.dart';
import 'package:seekihod/pages/navigation_page.dart';
import 'package:seekihod/views/main_view.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

class EventPage extends StatefulWidget {
  final EventModel eventModel;
  const EventPage({Key? key, required this.eventModel}) : super(key: key);

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  @override
  Widget build(BuildContext context) {
    return makeDismissable(
      context: context,
      child: DraggableScrollableSheet(
        initialChildSize: .7,
        maxChildSize: .9,
        minChildSize: .6,
        builder: (_, controller) => Scaffold(
          backgroundColor: Colors.transparent,
          floatingActionButton: buildNavigateButton(context, widget.eventModel),
          body: Container(
            decoration: BoxDecoration(
              color: myThemes.getPrimaryColor(context),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: SingleChildScrollView(
              controller: controller,
              child: Column(
                children: <Widget>[
                  const Icon(
                    Icons.drag_handle,
                    size: 30,
                  ),
                  Container(
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
                    height: 250,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          widget.eventModel.imgUrl,
                          fit: BoxFit.cover,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(1),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          child: Align(
                            alignment: AlignmentDirectional.bottomStart,
                            child: Container(
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          widget.eventModel.title,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: myThemes
                                                  .getFontAllWhite(context),
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.pin_drop,
                                              size: 15,
                                              color: myThemes
                                                  .getIconColor(context),
                                            ),
                                            Text(
                                              widget.eventModel.location,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: myThemes
                                                    .getFontAllWhite(context),
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      "${widget.eventModel.dateStart} - ${widget.eventModel.dateEnd}",
                                      style: TextStyle(
                                        color:
                                            myThemes.getFontAllWhite(context),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: const Text(
                        'About this Event',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Text(
                        widget.eventModel.description,
                        style: TextStyle(
                          color: myThemes.getFontwithOpacity(context, .6),
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Event Highlights",
                        style: TextStyle(
                          color: myThemes.getFontNormal(context),
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: widget.eventModel.highlights.length,
                      itemBuilder: (context, index) {
                        return Text(
                          "* ${widget.eventModel.highlights[index]}",
                          style: TextStyle(
                              fontSize: 15,
                              color: myThemes.getFontwithOpacity(context, .6)),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 250,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget makeDismissable(
        {required Widget child, required BuildContext context}) =>
    GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).pop(),
      child: GestureDetector(onTap: () {}, child: child),
    );

Widget buildNavigateButton(
        BuildContext context, EventModel currentEventModel) =>
    FloatingActionButton.extended(
      backgroundColor: myThemes.getIconColorDarkSecondary(context),
      icon: Icon(
        EvaIcons.navigation2,
        color: myThemes.getFontAllWhite(context),
      ),
      label: Text(
        "Learn More",
        style: TextStyle(color: myThemes.getFontAllWhite(context)),
      ),
      onPressed: () async {
        final url = Uri.parse(currentEventModel.link);
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
    );
