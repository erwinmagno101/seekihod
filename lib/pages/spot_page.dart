import 'package:carousel_slider/carousel_slider.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import 'package:seekihod/models/SpotModel.dart';
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
  @override
  Widget build(BuildContext context) {
    if (urlImages.isEmpty) {
      urlImages = widget.spotModel.images.cast<String>();
    }

    return Scaffold(
      extendBody: false,
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        leading: BackButton(color: myThemes.getIconColor(context)),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 15,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Flexible(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        height: 100,
                        width: 120,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              widget.spotModel.imgUrl,
                              fit: BoxFit.cover,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(.5)
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 25,
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.spotModel.name,
                            maxLines: 2,
                            style: const TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            widget.spotModel.address,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 15),
                          ),
                          Text(
                            widget.spotModel.type.toUpperCase(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12),
                          ),
                          Row(
                            children: [
                              const Text(
                                '4.8',
                                style: TextStyle(fontSize: 12),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Icon(
                                EvaIcons.star,
                                size: 15,
                                color: myThemes.getIconColor(context),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              const Text(
                                '1k Reviews',
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
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
                    onPressed: () {},
                    icon: const Icon(
                      EvaIcons.arrowCircleRightOutline,
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
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Text(
                  widget.spotModel.descriptionHeader,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                    color: myThemes.getFontwithOpacity(context, .6),
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
                itemCount: widget.spotModel.images.length,
                itemBuilder: (context, index, realIndex) {
                  final images = widget.spotModel.images[index];
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
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  color: myThemes.getIconColor(context),
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      'Navigate',
                      style: TextStyle(
                          color: myThemes.getPrimaryColor(context),
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
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
                      itemPadding: const EdgeInsets.symmetric(horizontal: 10),
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
                            color: myThemes.getIconColor(context)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Center(
              child: Text(
                'Comment Section Here below',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
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

class GalleryWidget extends StatefulWidget {
  final List<String> urlImages;

  GalleryWidget({
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
