// ignore: file_names
import 'package:firebase_auth/firebase_auth.dart';
import 'package:seekihod/views/main_view.dart';

class UserModel {
  String displayName;
  String userName;
  String imgUrl;
  String type;

  UserModel({
    required this.displayName,
    required this.userName,
    required this.imgUrl,
    required this.type,
  });

  Map<String, dynamic> toJson() =>
      {'displayName': displayName, 'userName': userName, 'imgUrl': imgUrl};

  static UserModel fromJson(Map<String, dynamic> json) => UserModel(
        displayName: json['displayName'],
        userName: json['userName'],
        imgUrl: json['imgUrl'],
        type: json['type'],
      );
}
