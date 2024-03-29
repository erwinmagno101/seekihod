import 'dart:ui';

import 'package:email_validator/email_validator.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:seekihod/UI/theme_provider.dart';
import 'package:seekihod/views/main_view.dart';
import 'package:seekihod/widget/google_signin.dart';

import '../main.dart';
import '../models/Utils.dart';

class LoginWidget extends StatefulWidget {
  final VoidCallback onClickedSignUp;

  const LoginWidget({Key? key, required this.onClickedSignUp})
      : super(key: key);

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  bool hidePass = true;

  final MyThemes myThemes = MyThemes();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final smsController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => GoogleSignInProvider(),
        builder: (context, child) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              leading: BackButton(
                color: myThemes.getIconColor(context),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const MainView()), // this mymainpage is your page to refresh
                    (Route<dynamic> route) => false,
                  );
                },
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const CircleAvatar(
                      radius: 100,
                      backgroundColor: Colors.transparent,
                      backgroundImage:
                          AssetImage('lib/assets/images/seekihod.png'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'SEEKihod',
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Tourist Guide Mobile Application',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: TextFormField(
                        cursorColor: myThemes.getIconColor(context),
                        style: const TextStyle(fontSize: 20),
                        controller: emailController,
                        textInputAction: TextInputAction.next,
                        decoration: textFieldDecoration('Email'),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (email) =>
                            email != null && !EmailValidator.validate(email)
                                ? 'Enter a valid email'
                                : null,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Stack(
                        children: [
                          TextFormField(
                            obscureText: hidePass,
                            cursorColor: myThemes.getStylePrimaryColor(context),
                            style: const TextStyle(fontSize: 20),
                            controller: passwordController,
                            textInputAction: TextInputAction.next,
                            decoration: textFieldDecoration('Password'),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) =>
                                passwordController.text.isEmpty
                                    ? 'This Fields is required'
                                    : null,
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (hidePass == true) {
                                      hidePass = false;
                                      return;
                                    }
                                    hidePass = true;
                                  });
                                },
                                icon: hidePass
                                    ? Icon(EvaIcons.eyeOff2)
                                    : Icon(EvaIcons.eye),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 80),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          color: myThemes.getIconColor(context),
                          child: TextButton(
                            onPressed: signIn,
                            child: Text(
                              'Sign In',
                              style: TextStyle(
                                  color: myThemes.getPrimaryColor(context),
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      'Or',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    const Text(
                      'Sign in Using',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                              color: myThemes.getIconColor(context), width: 2)),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          final provider = Provider.of<GoogleSignInProvider>(
                              context,
                              listen: false);

                          provider.googleLogin();
                        },
                        icon: const Icon(
                          EvaIcons.google,
                          color: Colors.green,
                          size: 30,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'No account? ',
                        style: TextStyle(
                            color: myThemes.getFontNormal(context),
                            fontSize: 12),
                        children: [
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = widget.onClickedSignUp,
                            text: 'Sign Up',
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: myThemes.getIconColor(context)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
  Future signIn() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      Fluttertoast.showToast(
        msg: "Log In Success!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      navigatorKey.currentState!.popUntil((route) => route.isCurrent);
    } on FirebaseAuthException catch (e) {
      print(e);
      Fluttertoast.showToast(
        msg: "${e.message}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }

    navigatorKey.currentState!.pop();
  }

  InputDecoration textFieldDecoration(String label) {
    return InputDecoration(
      filled: true,
      fillColor: myThemes.getSecondaryColor(context),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      isDense: true,
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(
              width: 1, color: myThemes.getIconColorSecondary(context))),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(
              width: 1, color: myThemes.getIconColorSecondary(context))),
      focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(width: 1, color: myThemes.getIconColor(context))),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none, borderRadius: BorderRadius.circular(25)),
      labelText: label,
      labelStyle: const TextStyle(
        fontSize: 20,
      ),
      floatingLabelStyle: TextStyle(
        fontSize: 25,
        color: myThemes.getIconColor(context),
      ),
    );
  }
}
