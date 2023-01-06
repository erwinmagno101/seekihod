import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:seekihod/main.dart';
import 'package:seekihod/models/GlobalVar.dart';
import 'package:seekihod/pages/AuthControl_page.dart';
import 'package:seekihod/pages/profile_page.dart';
import 'package:seekihod/pages/verifyemail_page.dart';
import 'package:seekihod/widget/loginWidget.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            globalVar.userLogged = true;
            return VerifyEmailPage();
          } else {
            globalVar.userLogged = false;
            return AuthControlPage();
          }
        },
      ),
    );
  }
}
