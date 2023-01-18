import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:seekihod/models/UserModel.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  Future googleLogin() async {
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) return;
    _user = googleUser;

    final googleAuth = await googleUser.authentication;

    final docUser =
        FirebaseFirestore.instance.collection('User').doc(googleUser.email);

    final snapshot = await docUser.get();

    if (!snapshot.exists) {
      createUser(
          email: googleUser.email,
          displayName: googleUser.displayName.toString(),
          userName: "",
          type: "user",
          imgUrl: googleUser.photoUrl.toString());
    }

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);

    Fluttertoast.showToast(
      msg: "Log In Success!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    notifyListeners();
  }

  Future logout() async {
    await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
  }

  Future createUser({
    required String email,
    required String displayName,
    required String userName,
    required String imgUrl,
    required String type,
  }) async {
    final docUser = FirebaseFirestore.instance.collection('User').doc(email);

    final json = {
      'email': email,
      'displayName': displayName,
      'userName': userName,
      'imgUrl': imgUrl,
      'type': type,
    };

    await docUser.set(json);
  }
}
