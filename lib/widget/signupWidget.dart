import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_password_strength/flutter_password_strength.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:seekihod/models/GlobalVar.dart';
import 'package:seekihod/views/main_view.dart';

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
  final displayNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final userNameController = TextEditingController();

  String photoUrlDownload = "";
  String _password = "";
  String _message = "";
  bool hidePass = true;
  bool weakPass = false;
  Color _messageColor = Colors.red;

  PlatformFile? pickedFile;
  UploadTask? uploadTask;

  bool isCreate = false;

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result == null) return;

    setState(() {
      pickedFile = result.files.first;
    });
  }

  Future uploadFile() async {
    final path = 'User_images/${emailController.text}.jpg';
    final file = File(pickedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);
    final snapshot = await uploadTask!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    photoUrlDownload = urlDownload;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      const MainView();
    });
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
              if (pickedFile != null)
                CircleAvatar(
                  radius: 75,
                  backgroundImage: FileImage(
                    File(pickedFile!.path!),
                  ),
                ),
              if (pickedFile == null)
                const CircleAvatar(
                  radius: 75,
                  backgroundImage:
                      AssetImage('lib/assets/images/emptyProfile.jpg'),
                ),
              const SizedBox(
                height: 5,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Container(
                  height: 30,
                  color: myThemes.getIconColor(context),
                  child: TextButton(
                    onPressed: selectFile,
                    child: Text(
                      'Select an image',
                      style: TextStyle(
                        color: myThemes.getPrimaryColor(context),
                        fontSize: 10,
                      ),
                    ),
                  ),
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
                      onChanged: (value) {
                        setState(() {
                          _password = value;
                        });
                      },
                      onSaved: (value) {
                        setState(() {
                          _password = value!;
                        });
                      },
                      obscureText: hidePass,
                      cursorColor: myThemes.getIconColor(context),
                      style: const TextStyle(fontSize: 20),
                      controller: passwordController,
                      textInputAction: TextInputAction.next,
                      decoration: textFieldDecoration('Password'),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) => value != null && value.length < 8
                          ? 'Enter a minimuim of 8 characters'
                          : null,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
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
                    )
                  ],
                ),
              ),
              if (_password.isNotEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                  child: FlutterPasswordStrength(
                    password: _password,
                    height: 20,
                    radius: 10,
                    strengthCallback: (strength) {
                      if (strength <= 1) {
                        _message = "Strong";
                        _messageColor = Colors.green;
                        weakPass = false;
                      }
                      if (strength < .8) {
                        _message = "Moderate";
                        _messageColor = Colors.blue;
                        weakPass = false;
                      }
                      if (strength < .5) {
                        _message = "Weak";
                        _messageColor = Colors.yellow;
                        weakPass = true;
                      }
                      if (strength < .3) {
                        _message = "Super Weak";
                        _messageColor = Colors.orange;
                        weakPass = true;
                      }
                      debugPrint(strength.toString());
                    },
                  ),
                ),
              if (_password.isNotEmpty)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Password Strength: "),
                    Text(
                      _message,
                      style: TextStyle(color: _messageColor),
                    ),
                  ],
                ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Stack(
                  children: [
                    TextFormField(
                      obscureText: hidePass,
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
                    Align(
                      alignment: Alignment.centerRight,
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
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: TextFormField(
                  cursorColor: myThemes.getIconColor(context),
                  style: const TextStyle(fontSize: 20),
                  controller: displayNameController,
                  textInputAction: TextInputAction.next,
                  decoration: textFieldDecoration('Display Name'),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => displayNameController.text.isEmpty
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
    if (!isValid) {
      Fluttertoast.showToast(
        msg: "All Fields Required",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }
    if (weakPass) {
      Fluttertoast.showToast(
        msg: "Password Too Weak",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));

    try {
      final email = emailController.text;
      final displayName = displayNameController.text;
      final userName = userNameController.text;
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      )
          .then((value) async {
        var asd = value;
        await value.user!.updateDisplayName(displayName);
        uploadFile().then((value) async {
          await asd.user!.updatePhotoURL(photoUrlDownload);
        });
      });

      createUser(
        email: email,
        displayName: displayName,
        userName: userName,
        imgUrl: "",
      ).then((value) {
        navigatorKey.currentState!.pop();
        navigatorKey.currentState!.popUntil((route) => route.isCurrent);
      });
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(
        msg: e.message.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      navigatorKey.currentState!.pop();
    }
  }

  Future createUser({
    required String email,
    required String displayName,
    required String userName,
    required String imgUrl,
  }) async {
    final docUser = FirebaseFirestore.instance.collection('User').doc(email);

    final json = {
      'email': email,
      'displayName': displayName,
      'userName': userName,
      'imgUrl': imgUrl,
    };

    await docUser.set(json);
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
