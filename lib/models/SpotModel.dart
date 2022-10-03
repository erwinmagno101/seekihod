// ignore: file_names
class SpotModel {
  String name;
  String description;
  String descriptionHeader;
  String imgUrl;
  String address;
  String type;
  var images = [];

  SpotModel({
    required this.name,
    required this.description,
    required this.descriptionHeader,
    required this.imgUrl,
    required this.images,
    required this.address,
    required this.type,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'descriptionHeader': descriptionHeader,
        'imgUrl': imgUrl,
        'images': images,
        'address': address,
        'type': type,
      };

  static SpotModel fromJson(Map<String, dynamic> json) => SpotModel(
        name: json['name'],
        description: json['description'],
        descriptionHeader: json['descriptionHeader'],
        imgUrl: json['imgUrl'],
        images: json['images'],
        address: json['address'],
        type: json['type'],
      );
}
