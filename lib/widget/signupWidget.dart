import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../UI/theme_provider.dart';
import '../main.dart';
import '../models/Utils.dart';

class SignUpWidget extends StatefulWidget {
  final Function() onClickedSignIn;
  const SignUpWidget({Key? key, required this.onClickedSignIn})
      : super(key: key);

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  final formKey = GlobalKey<FormState>();
  final MyThemes myThemes = MyThemes();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final userNameController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: BackButton(
          color: myThemes.getIconColor(context),
          onPressed: widget.onClickedSignIn,
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
                radius: 75,
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
                child: TextFormField(
                  cursorColor: myThemes.getIconColor(context),
                  style: const TextStyle(fontSize: 20),
                  controller: passwordController,
                  textInputAction: TextInputAction.next,
                  decoration: textFieldDecoration('Password'),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => value != null && value.length < 6
                      ? 'Enter a minimuim of 6 characters'
                      : null,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: TextFormField(
                  cursorColor: myThemes.getIconColor(context),
                  style: const TextStyle(fontSize: 20),
                  controller: confirmPasswordController,
                  textInputAction: TextInputAction.next,
                  decoration: textFieldDecoration('Confirm Password'),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => value != passwordController.text
                      ? 'Password does not match'
                      : null,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: TextFormField(
                  cursorColor: myThemes.getIconColor(context),
                  style: const TextStyle(fontSize: 20),
                  controller: firstNameController,
                  textInputAction: TextInputAction.next,
                  decoration: textFieldDecoration('First Name'),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => firstNameController.text.isEmpty
                      ? 'This Field is required'
                      : null,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: TextFormField(
                  cursorColor: myThemes.getIconColor(context),
                  style: const TextStyle(fontSize: 20),
                  controller: lastNameController,
                  textInputAction: TextInputAction.next,
                  decoration: textFieldDecoration('Last Name'),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => lastNameController.text.isEmpty
                      ? 'This Field is required'
                      : null,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: TextFormField(
                  cursorColor: myThemes.getIconColor(context),
                  style: const TextStyle(fontSize: 20),
                  controller: userNameController,
                  textInputAction: TextInputAction.next,
                  decoration: textFieldDecoration('Username'),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => userNameController.text.isEmpty
                      ? 'This Fields is required'
                      : null,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 80),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    color: myThemes.getIconColor(context),
                    child: TextButton(
                      onPressed: signUp,
                      child: Text(
                        'Sign Up',
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
                height: 20,
              ),
              RichText(
                text: TextSpan(
                  text: 'Already hava an account? ',
                  style: TextStyle(
                      color: myThemes.getFontNormal(context), fontSize: 12),
                  children: [
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = widget.onClickedSignIn,
                      text: 'Sign In',
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
  }

  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      Utils.showSnackBar('Sign Up Success. User Logged in', true);

      navigatorKey.currentState!.popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      print(e);

      Utils.showSnackBar(e.message, false);
      navigatorKey.currentState!.pop();
    }
  }

  InputDecoration textFieldDecoration(String label) {
    return InputDecoration(
      filled: true,
      fillColor: myThemes.getSecondaryColor(context),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      isDense: true,
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
              width: 1, color: myThemes.getIconColorSecondary(context))),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
              width: 1, color: myThemes.getIconColorSecondary(context))),
      focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(width: 1, color: myThemes.getIconColor(context))),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none, borderRadius: BorderRadius.circular(20)),
      labelText: label,
      labelStyle: const TextStyle(
        fontSize: 20,
      ),
      floatingLabelStyle: TextStyle(
        color: myThemes.getIconColor(context),
      ),
    );
  }
}
