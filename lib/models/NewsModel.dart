// ignore: file_names
class ContentModel {
  String title;
  String description;
  String imgUrl;
  String link;
  String type;

  ContentModel({
    required this.title,
    required this.description,
    required this.imgUrl,
    required this.link,
    required this.type,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'imgUrl': imgUrl,
        'link': link,
        'type': type,
      };

  static ContentModel fromJson(Map<String, dynamic> json) => ContentModel(
        title: json['title'],
        description: json['description'],
        imgUrl: json['imgUrl'],
        link: json['link'],
        type: json['type'],
      );
}
