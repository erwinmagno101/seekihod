import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:seekihod/views/main_view.dart';
import 'SpotModel.dart';

class globalVar {
  static bool userLogged = false;
  static var gg;
  static var ref;
  static SpotModel? featureModel;

  static getImage() async {
    FirebaseStorage storage = FirebaseStorage.instance;

    try {
      Reference ref = storage
          .ref()
          .child('User_images/${FirebaseAuth.instance.currentUser!.email}.jpg');
      String imageUrl = await ref.getDownloadURL();
      img = imageUrl;
    } catch (e) {
      print(e);
    }
  }
}
