// ignore: file_names
import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  String firstName;
  String lastName;
  String userName;

  UserModel({
    required this.firstName,
    required this.lastName,
    required this.userName,
  });

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'userName': userName,
      };

  static UserModel fromJson(Map<String, dynamic> json) => UserModel(
        firstName: json['firstName'],
        lastName: json['lastName'],
        userName: json['userName'],
      );
}
