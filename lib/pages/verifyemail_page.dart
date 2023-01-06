import 'dart:async';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:seekihod/UI/theme_provider.dart';
import 'package:seekihod/models/utils.dart';
import 'package:seekihod/pages/profile_page.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  bool done = true;
  Timer? timer;
  User user = FirebaseAuth.instance.currentUser!;
  bool canResendEmail = false;
  MyThemes myThemes = MyThemes();
  Timer? _timer;
  int _start = 30;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();

    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      sendVerificationEmail();

      Timer.periodic(
        Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      setState(() {
        canResendEmail = false;
        _start = 30;
      });

      startTimer();
      await Future.delayed(const Duration(seconds: 30));

      setState(() => canResendEmail = true);
    } catch (e) {
      Utils.showSnackBar(e.toString(), true);
    }
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified && done) {
      Fluttertoast.showToast(
        msg: "Sign Up Success",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      setState(() {
        done = false;
      });
      timer?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? ProfilePage()
      : Scaffold(
          appBar: AppBar(
            centerTitle: true,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: const Text(
              "Verify Email",
            ),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "A Verification Email Has been sent to your email: ${user.email.toString()}",
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton.icon(
                  onPressed: canResendEmail ? sendVerificationEmail : null,
                  icon: const Icon(EvaIcons.email),
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Resend Email Verification",
                        style: TextStyle(
                            color: myThemes.getPrimaryColor(context),
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      if (_start != 0)
                        Text(
                          ":  $_start",
                          style: TextStyle(
                              color: myThemes.getPrimaryColor(context),
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        )
                    ],
                  )),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 100),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width,
                    color: myThemes.getIconColor(context),
                    child: TextButton(
                      onPressed: () => FirebaseAuth.instance.signOut(),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                            color: myThemes.getPrimaryColor(context),
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
}
