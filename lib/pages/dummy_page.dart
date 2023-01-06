import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:seekihod/models/GlobalVar.dart';
import 'package:seekihod/models/UserModel.dart';
import 'package:seekihod/views/main_view.dart';
import 'package:seekihod/widget/google_signin.dart';

class DummyPage extends StatefulWidget {
  DummyPage({Key? key}) : super(key: key);

  @override
  State<DummyPage> createState() => _DummyPageState();
}

class _DummyPageState extends State<DummyPage> {
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Home'),
            leading: BackButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          MainView()), // this mymainpage is your page to refresh
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ),
          body: FutureBuilder<UserModel?>(
            future: readUser(
                email: FirebaseAuth.instance.currentUser!.email.toString()),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final User = snapshot.data!;

                return Padding(
                  padding: EdgeInsets.all(30),
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
                return Column(
                  children: [
                    ElevatedButton.icon(
                        onPressed: () {
                          final provider = Provider.of<GoogleSignInProvider>(
                              context,
                              listen: false);
                          logout(provider);
                        },
                        icon: const Icon(EvaIcons.skipBack),
                        label: const Text('Log out'))
                  ],
                );
              }
            },
          ),
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
      } else {
        FirebaseAuth.instance.signOut();
      }
    }
  }
}
