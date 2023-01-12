import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:seekihod/models/UserModel.dart';
import 'package:seekihod/views/main_view.dart';
import 'package:seekihod/widget/google_signin.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? userName;
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      builder: (context, child) {
        final provider =
            Provider.of<GoogleSignInProvider>(context, listen: false);

        final docUser = FirebaseFirestore.instance
            .collection('User')
            .doc(FirebaseAuth.instance.currentUser!.email.toString());

        docUser.update(
            {'imgUrl': FirebaseAuth.instance.currentUser!.photoURL.toString()});

        return FutureBuilder<UserModel?>(
            future: readUser(
                email: FirebaseAuth.instance.currentUser!.email.toString()),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final user = snapshot.data!;
                userName = user.userName;
                return Scaffold(
                  appBar: AppBar(
                    elevation: 0,
                    centerTitle: true,
                    title: const Text('Profile Page'),
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
                  body: profileDisplay(provider),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            });
      });

  Future<UserModel?> readUser({required String email}) async {
    final docUser = FirebaseFirestore.instance.collection('User').doc(email);

    final snapshot = await docUser.get();

    if (snapshot.exists) {
      return UserModel.fromJson(snapshot.data()!);
    }
    return null;
  }

  void logout(GoogleSignInProvider provider) {
    for (UserInfo user in FirebaseAuth.instance.currentUser!.providerData) {
      if (user.providerId.toString() == "google.com") {
        provider.logout();
      }

      if (user.providerId.toString() == "password") {
        FirebaseAuth.instance.signOut();
      }
    }
  }

  Widget profileDisplay(GoogleSignInProvider provider) {
    User user = FirebaseAuth.instance.currentUser!;
    return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 4,
                child: Stack(
                  fit: StackFit.loose,
                  children: [
                    Container(
                      color: HexColor('#43B3AE'),
                      height: MediaQuery.of(context).size.height / 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Align(
                        alignment: AlignmentDirectional.bottomCenter,
                        child: CircleAvatar(
                          radius: 90,
                          backgroundImage: NetworkImage(
                            user.photoURL.toString(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Signed in as",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        "Display Name",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  Card(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(
                            flex: 0,
                            child: Icon(
                              Icons.person,
                              size: 30,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 25),
                              child: Text(
                                "${user.displayName}",
                                style: const TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        "Email Address",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  Card(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(
                            flex: 0,
                            child: Icon(
                              Icons.email,
                              size: 30,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 25),
                              child: Text(
                                "${user.email}",
                                maxLines: 2,
                                style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        "Username",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  Card(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(
                            flex: 0,
                            child: Icon(
                              Icons.person_pin,
                              size: 30,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 25),
                              child: Text(
                                userName!,
                                maxLines: 2,
                                style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              ElevatedButton.icon(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(HexColor('#43B3AE'))),
                  onPressed: () {
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) {
                          return StatefulBuilder(builder: (contex, setState) {
                            return Dialog(
                                backgroundColor: Colors.transparent,
                                child: Card(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 30),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text(
                                          "Are you sure you want to sign out?",
                                          maxLines: 3,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 50,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              child: Container(
                                                color: myThemes
                                                    .getIconColor(context),
                                                width: 100,
                                                child: TextButton(
                                                  child: Text(
                                                    "Sign out",
                                                    style: TextStyle(
                                                        color: myThemes
                                                            .getPrimaryColor(
                                                                context),
                                                        fontSize: 25,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  onPressed: () {
                                                    logout(provider);
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ),
                                            ),
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              child: Container(
                                                color: myThemes
                                                    .getIconColor(context),
                                                width: 100,
                                                child: TextButton(
                                                  child: Text(
                                                    "Cancel",
                                                    style: TextStyle(
                                                        color: myThemes
                                                            .getPrimaryColor(
                                                                context),
                                                        fontSize: 25,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ));
                          });
                        });
                  },
                  icon: const Icon(
                    EvaIcons.skipBack,
                  ),
                  label: const Text('Sign out')),
            ],
          ),
        ));
  }
}
