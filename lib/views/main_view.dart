import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:seekihod/UI/theme_provider.dart';
import 'package:seekihod/models/GlobalVar.dart';
import 'package:seekihod/pages/Auth_page.dart';
import 'package:seekihod/views/archive_view.dart';
import 'package:seekihod/views/events_view.dart';
import 'package:seekihod/views/feature_view.dart';
import 'package:seekihod/views/home_view.dart';

import '../models/UserModel.dart';
import '../widget/change_theme_button_widget.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

final MyThemes myThemes = MyThemes();
final user = FirebaseAuth.instance.currentUser!;

var img;
var userName;

class _MainViewState extends State<MainView> {
  int index = 0;

  final screens = [
    const HomewView(),
    const FeatureView(),
    const EventsView(),
    const DirectoryView(),
  ];

  final title = [
    const Text('Home'),
    const Text('Featured'),
    const Text('Events'),
    const Text('Archive'),
  ];

  getImage() async {
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

  readUser() async {
    try {
      final docUser = FirebaseFirestore.instance
          .collection('User')
          .doc(FirebaseAuth.instance.currentUser!.email.toString());

      final snapshot = await docUser.get();

      if (snapshot.exists) {
        userName = snapshot.data()!;
      }
      return null;
    } catch (e) {
      print(e);
    }
  }

  Widget avatar(double rad) {
    try {
      return CircleAvatar(
        radius: rad,
        backgroundImage: NetworkImage(img),
      );
    } catch (e) {
      print(e);
      return CircleAvatar(
        radius: rad,
        backgroundImage: const AssetImage('lib/assets/images/emptyProfile.jpg'),
      );
    }
  }

  Widget avatarName() {
    try {
      return Text(
        '${userName["firstName"]} ${userName["lastName"]}',
        style:
            TextStyle(fontSize: 28, color: myThemes.getFontAllWhite(context)),
      );
    } catch (e) {
      return Text(
        '',
        style:
            TextStyle(fontSize: 28, color: myThemes.getFontAllWhite(context)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    readUser();
    getImage();
    return Scaffold(
      drawer: NavigationDrawer(
        avatar: avatar(80),
        avatarName: avatarName(),
      ),
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: InkWell(
              overlayColor: MaterialStateProperty.all(const Color(0x00000000)),
              onTap: () {
                setState(() {
                  readUser();
                  getImage();
                });
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const AuthPage()));
              },
              child: StreamBuilder<User?>(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    getImage();
                    readUser();

                    return avatar(15);
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const CircleAvatar(
                      radius: 15,
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return const CircleAvatar(
                      radius: 15,
                      backgroundImage:
                          AssetImage('lib/assets/images/emptyProfile.jpg'),
                    );
                  }
                },
              ),
            ),
          )
        ],
        iconTheme: IconThemeData(color: myThemes.getIconColor(context)),
        centerTitle: true,
        elevation: 0,
        title: title[index],
      ),
      body: screens[index],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (index) => setState(() => this.index = index),
        selectedIndex: index,
        height: 50,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        destinations: [
          NavigationDestination(
            icon: const Icon(
              EvaIcons.homeOutline,
            ),
            selectedIcon: Icon(
              EvaIcons.home,
              color: myThemes.getIconColor(context),
            ),
            label: 'Home',
          ),
          NavigationDestination(
            icon: const Icon(
              EvaIcons.starOutline,
            ),
            selectedIcon: Icon(
              EvaIcons.star,
              color: myThemes.getIconColor(context),
            ),
            label: 'Featured',
          ),
          NavigationDestination(
            icon: const Icon(
              EvaIcons.calendarOutline,
            ),
            selectedIcon: Icon(
              EvaIcons.calendar,
              color: myThemes.getIconColor(context),
            ),
            label: 'Events',
          ),
          NavigationDestination(
            icon: const Icon(
              EvaIcons.bookOpenOutline,
            ),
            selectedIcon: Icon(
              EvaIcons.bookOpen,
              color: myThemes.getIconColor(context),
            ),
            label: 'Archive',
          ),
        ],
      ),
    );
  }
}

class NavigationDrawer extends StatefulWidget {
  final Widget avatar;
  final Widget avatarName;

  const NavigationDrawer(
      {Key? key, required this.avatar, required this.avatarName})
      : super(key: key);

  @override
  State<NavigationDrawer> createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            buildHeader(context),
            buildMenuItems(context),
          ],
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Material(
            color: myThemes.getIconColorDark(context),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const AuthPage()));
              },
              child: Container(
                color: myThemes.getIconColorDark(context),
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top, bottom: 30),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 25,
                    ),
                    widget.avatar,
                    const SizedBox(
                      height: 12,
                    ),
                    widget.avatarName,
                    Text(
                      FirebaseAuth.instance.currentUser!.email.toString(),
                      style: TextStyle(
                          fontSize: 16,
                          color: myThemes.getFontAllWhite(context)),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Material(
            color: myThemes.getPrimaryColor(context),
            child: Container(
              color: myThemes.getPrimaryColor(context),
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top, bottom: 5),
              child: Column(
                children: [
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
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const AuthPage()));
                          },
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
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget buildMenuItems(BuildContext context) => Container(
        padding: const EdgeInsets.all(10),
        child: Wrap(
          runSpacing: 5,
          children: [
            const ListTile(
              title: Text('Settings'),
            ),
            const ListTile(
              leading: Icon(EvaIcons.moon),
              title: Text('Dark mode'),
              trailing: ChangeThemeButtonWidget(),
            ),
            if (FirebaseAuth.instance.currentUser != null)
              ListTile(
                leading: const Icon(EvaIcons.logOut),
                title: const Text('Sign out'),
                onTap: () => FirebaseAuth.instance.signOut(),
              ),
            Divider(
              color: myThemes.getIconColor(context),
              thickness: 1,
            ),
            const ListTile(
              title: Text('DOT Siquijor'),
            ),
            const ListTile(
              leading: Icon(EvaIcons.heart),
              title: Text('Health Protocols'),
            ),
            const ListTile(
              leading: Icon(EvaIcons.questionMarkCircle),
              title: Text('FAQs'),
            ),
            const ListTile(
              leading: Icon(EvaIcons.phoneCall),
              title: Text('Hotline'),
            ),
            const ListTile(
              leading: Icon(EvaIcons.facebook),
              title: Text('Facebook'),
            ),
            Divider(
              color: myThemes.getIconColor(context),
              thickness: 1,
            ),
            const ListTile(
              title: Text('About Us'),
            ),
            const ListTile(
              leading: Icon(EvaIcons.phone),
              title: Text('Contact Us'),
            ),
            const ListTile(
              leading: Icon(EvaIcons.facebook),
              title: Text('Facebook'),
            ),
            const ListTile(
              leading: Icon(EvaIcons.syncOutline),
              title: Text('Instagram'),
            ),
            const ListTile(
              leading: Icon(EvaIcons.code),
              title: Text('Developers'),
            ),
          ],
        ),
      );

  Future<UserModel?> readUser() async {
    final docUser = FirebaseFirestore.instance
        .collection('User')
        .doc(FirebaseAuth.instance.currentUser!.email.toString());

    final snapshot = await docUser.get();

    if (snapshot.exists) {
      return UserModel.fromJson(snapshot.data()!);
    }
    return null;
  }
}
