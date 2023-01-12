import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import 'package:seekihod/models/SpotModel.dart';
import 'package:seekihod/pages/navigation_page.dart';
import 'package:seekihod/views/main_view.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SpotPage extends StatefulWidget {
  final SpotModel spotModel;
  const SpotPage({Key? key, required this.spotModel}) : super(key: key);

  @override
  State<SpotPage> createState() => _SpotPageState();
}

class _SpotPageState extends State<SpotPage> {
  List<String> urlImages = [];

  int activeIndex = 0;
  bool show = false;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SpotModel>(
        stream: readSpots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            SpotModel currentModel = snapshot.data!;
            if (urlImages.isEmpty) {
              urlImages = currentModel.images.cast<String>();
            }
            var reviews = currentModel.review.values.toList();
            double reviewAverage = 0;
            int reviewCount = reviews.length;

            if (reviews.isNotEmpty) {
              for (int i = 0; i < reviews.length; i++) {
                reviewAverage += double.parse(reviews[i]);
              }
              reviewAverage = reviewAverage / reviews.length;
            } else {
              reviewAverage = 0;
            }

            return makeDismissable(
              context: context,
              child: DraggableScrollableSheet(
                initialChildSize: .7,
                maxChildSize: .9,
                minChildSize: .6,
                builder: (_, controller) => Scaffold(
                  backgroundColor: Colors.transparent,
                  floatingActionButton:
                      buildNavigateButton(context, currentModel),
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
                                  currentModel.imgUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (BuildContext context,
                                      Object exception,
                                      StackTrace? stackTrace) {
                                    return Center(
                                        child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                                  currentModel.name,
                                                  maxLines: 3,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: myThemes
                                                          .getFontAllWhite(
                                                              context),
                                                      fontSize: 25,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.pin_drop,
                                                      size: 15,
                                                      color:
                                                          myThemes.getIconColor(
                                                              context),
                                                    ),
                                                    Text(
                                                      currentModel.address,
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: myThemes
                                                            .getFontAllWhite(
                                                                context),
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  currentModel.type
                                                      .toUpperCase(),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: myThemes
                                                        .getFontAllWhite(
                                                            context),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Spacer(
                                            flex: 1,
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      reviewAverage.toString(),
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: myThemes
                                                            .getFontAllWhite(
                                                                context),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Icon(
                                                      EvaIcons.star,
                                                      size: 15,
                                                      color:
                                                          myThemes.getIconColor(
                                                              context),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  "${reviewCount} reviews",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: myThemes
                                                        .getFontAllWhite(
                                                            context),
                                                  ),
                                                ),
                                              ],
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
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'About this Tourist Spot',
                                  style: TextStyle(fontSize: 20),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      if (show == false) {
                                        show = true;
                                        return;
                                      }
                                      show = false;
                                    });
                                  },
                                  icon: show
                                      ? const Icon(
                                          EvaIcons.arrowIosUpward,
                                          size: 25,
                                        )
                                      : const Icon(
                                          EvaIcons.arrowIosDownward,
                                          size: 25,
                                        ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Center(
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              child: Text(
                                currentModel.descriptionHeader,
                                overflow: !show ? TextOverflow.ellipsis : null,
                                maxLines: !show ? 2 : null,
                                style: TextStyle(
                                  color:
                                      myThemes.getFontwithOpacity(context, .6),
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          if (show)
                            Center(
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 25),
                                child: Text(
                                  currentModel.description,
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                    color: myThemes.getFontwithOpacity(
                                        context, .6),
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            height: 175,
                            width: MediaQuery.of(context).size.width,
                            child: CarouselSlider.builder(
                              itemCount: currentModel.images.length,
                              itemBuilder: (context, index, realIndex) {
                                final images = currentModel.images[index];
                                return buildImage(images, index);
                              },
                              options: CarouselOptions(
                                viewportFraction: 0.9,
                                enableInfiniteScroll: true,
                                autoPlay: true,
                                autoPlayInterval: const Duration(seconds: 5),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Rate this Attraction',
                                  style: TextStyle(fontSize: 20),
                                ),
                                const Text(
                                  'Tell others what you think',
                                  style: TextStyle(fontSize: 12),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Center(
                                  child: RatingBar.builder(
                                    itemSize: 35,
                                    itemPadding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    minRating: 1,
                                    itemBuilder: (context, _) => Icon(
                                      EvaIcons.star,
                                      color: myThemes.getIconColor(context),
                                    ),
                                    onRatingUpdate: (rating) {},
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Center(
                                  child: TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      'Write a comment',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              myThemes.getIconColor(context)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Center(
                            child: Text(
                              'Comment Section Here below',
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Stream<SpotModel> readSpots() {
    final docRef = FirebaseFirestore.instance
        .collection('Spots')
        .doc(widget.spotModel.name)
        .snapshots();

    return docRef.map((event) => SpotModel.fromJson(event.data()!));
  }

  Widget buildImage(String urlImage, int index) => InkWell(
        onTap: openGallery,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.2),
                spreadRadius: .1,
                blurRadius: .1,
              )
            ],
          ),
          width: MediaQuery.of(context).size.width - 55,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              child: Image.network(
                urlImage,
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
            ),
          ),
        ),
      );

  Widget buildIdicator() => AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: widget.spotModel.images.length,
        effect: JumpingDotEffect(
          dotWidth: 10,
          dotHeight: 10,
          activeDotColor: Colors.white,
          dotColor: HexColor('495057'),
        ),
      );

  void openGallery() => Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => GalleryWidget(
          urlImages: urlImages,
        ),
      ));
}

Widget makeDismissable(
        {required Widget child, required BuildContext context}) =>
    GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).pop(),
      child: GestureDetector(onTap: () {}, child: child),
    );

Widget buildNavigateButton(BuildContext context, SpotModel spotModel) =>
    FloatingActionButton.extended(
      backgroundColor: myThemes.getIconColorDarkSecondary(context),
      icon: Icon(
        EvaIcons.navigation2,
        color: myThemes.getFontAllWhite(context),
      ),
      label: Text(
        "Navigate",
        style: TextStyle(color: myThemes.getFontAllWhite(context)),
      ),
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => MapScreen(spotModel: spotModel)));
      },
    );

class GalleryWidget extends StatefulWidget {
  final List<String> urlImages;

  const GalleryWidget({
    super.key,
    required this.urlImages,
  });

  @override
  State<GalleryWidget> createState() => _GalleryWidgetState();
}

class _GalleryWidgetState extends State<GalleryWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: myThemes.getIconColor(context),
        ),
      ),
      body: PhotoViewGallery.builder(
        customSize: Size.fromWidth(MediaQuery.of(context).size.width),
        itemCount: widget.urlImages.length,
        builder: (context, index) {
          final urlImage = widget.urlImages[index];

          return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(urlImage),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.contained * 4,
          );
        },
      ),
    );
  }
}
