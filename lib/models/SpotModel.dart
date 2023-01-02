// ignore: file_names
import 'package:cloud_firestore/cloud_firestore.dart';

class SpotModel {
  String name;
  String description;
  String descriptionHeader;
  String imgUrl;
  String address;
  String type;
  GeoPoint geoPoint;
  var images = [];

  SpotModel(
      {required this.name,
      required this.description,
      required this.descriptionHeader,
      required this.imgUrl,
      required this.images,
      required this.address,
      required this.type,
      required this.geoPoint});

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'descriptionHeader': descriptionHeader,
        'imgUrl': imgUrl,
        'images': images,
        'address': address,
        'type': type,
        'geopoint': geoPoint,
      };

  static SpotModel fromJson(Map<String, dynamic> json) => SpotModel(
      name: json['name'],
      description: json['description'],
      descriptionHeader: json['descriptionHeader'],
      imgUrl: json['imgUrl'],
      images: json['images'],
      address: json['address'],
      type: json['type'],
      geoPoint: json['geopoint']);
}
