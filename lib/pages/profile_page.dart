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
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      builder: (context, child) {
        final provider =
            Provider.of<GoogleSignInProvider>(context, listen: false);
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: const Text('Profile Page'),
            leading: BackButton(
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
    for (UserInfo user in FirebaseAuth.instance.currentUser!.providerData) {
      if (user.providerId.toString() == "google.com") {
        User user = FirebaseAuth.instance.currentUser!;
        return SingleChildScrollView(
            child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisSize: MainAxisSize.max,
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
                        alignment: AlignmentDirectional.bottomEnd,
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
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Signed in as",
                    style: TextStyle(
                      fontSize: 15,
                      color: myThemes.getFontAllWhite(context),
                    ),
                  ),
                  Text(
                    "${user.displayName}",
                    style: TextStyle(
                        fontSize: 30,
                        color: myThemes.getFontAllWhite(context),
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${user.email}",
                    style: TextStyle(
                        fontSize: 20,
                        color: myThemes.getFontAllWhite(context),
                        fontWeight: FontWeight.bold),
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
                    logout(provider);
                  },
                  icon: const Icon(
                    EvaIcons.skipBack,
                  ),
                  label: const Text('Sign out'))
            ],
          ),
        ));
      }

      if (user.providerId.toString() == "password") {
        return FutureBuilder<UserModel?>(
          future: readUser(
              email: FirebaseAuth.instance.currentUser!.email.toString()),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final User = snapshot.data!;

              return Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      user.email!,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      User.firstName,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      User.lastName,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      User.userName,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton.icon(
                        onPressed: () {
                          final provider = Provider.of<GoogleSignInProvider>(
                              context,
                              listen: false);
                          logout(provider);
                        },
                        icon: Icon(EvaIcons.skipBack),
                        label: Text('Log out'))
                  ],
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Center(child: Text(snapshot.error.toString()));
            }
          },
        );
      }
    }
    return const Center(child: Text("No Data"));
  }
}
