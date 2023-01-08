import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:seekihod/views/main_view.dart';
import 'SpotModel.dart';

class globalVar {
  static bool userLogged = false;
  static var gg;
  static var ref;
  static SpotModel? featureModel;
}
