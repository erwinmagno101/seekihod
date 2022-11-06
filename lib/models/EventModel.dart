class EventModel {
  String title;
  String description;
  String dateStart;
  String dateEnd;
  String imgUrl;
  String location;
  String link;

  var highlights = [];

  EventModel({
    required this.title,
    required this.description,
    required this.dateStart,
    required this.dateEnd,
    required this.imgUrl,
    required this.highlights,
    required this.location,
    required this.link,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'dateStart': dateStart,
        'dateEnd': dateEnd,
        'imgUrl': imgUrl,
        'highlights': highlights,
        'location': location,
        'link': link,
      };

  static EventModel fromJson(Map<String, dynamic> json) => EventModel(
        title: json['title'],
        description: json['description'],
        dateStart: json['dateStart'],
        dateEnd: json['dateEnd'],
        imgUrl: json['imgUrl'],
        highlights: json['highlights'],
        location: json['location'],
        link: json['link'],
      );
}
