import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seekihod/UI/theme_provider.dart';
import 'package:seekihod/pages/Auth_page.dart';
import 'package:seekihod/views/archive_view.dart';
import 'package:seekihod/views/events_view.dart';
import 'package:seekihod/views/feature_view.dart';
import 'package:seekihod/views/guide_view.dart';
import 'package:seekihod/views/home_view.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/UserModel.dart';
import '../widget/change_theme_button_widget.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

final MyThemes myThemes = MyThemes();

class _MainViewState extends State<MainView> {
  int index = 0;

  final screens = [
    const HomewView(),
    const FeatureView(),
    const EventsView(),
    const DirectoryView(),
    const GuideView(),
  ];

  final title = [
    const Text('Home'),
    const Text('Featured'),
    const Text('Events'),
    const Text('Archive'),
    const Text('Tour Guide Panel'),
  ];

  Widget avatar(double rad, User user) {
    try {
      return CircleAvatar(
        radius: rad,
        backgroundImage: NetworkImage(user.photoURL.toString()),
      );
    } catch (e) {
      return CircleAvatar(
        radius: rad,
        backgroundImage: const AssetImage('lib/assets/images/emptyProfile.jpg'),
      );
    }
  }

  Widget avatarName(User user) {
    try {
      return Text(
        '${user.displayName}',
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

  Future<bool> _onWillPop() async {
    return (await showDialog(
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "You sure you want to exit?",
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Container(
                                    color: myThemes.getIconColor(context),
                                    width: 100,
                                    child: TextButton(
                                      child: Text(
                                        "Confirm",
                                        style: TextStyle(
                                            color: myThemes
                                                .getPrimaryColor(context),
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop(true);
                                      },
                                    ),
                                  ),
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Container(
                                    color: myThemes.getIconColor(context),
                                    width: 100,
                                    child: TextButton(
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(
                                            color: myThemes
                                                .getPrimaryColor(context),
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
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
            })) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: FutureBuilder<UserModel?>(
          future: readUser(),
          builder: (context, snapshot) {
            bool isTourGuide = false;
            if (snapshot.hasData) {
              if (snapshot.data!.type == "tour guide") {
                isTourGuide = true;
              } else {
                isTourGuide = false;
              }
            }
            return Scaffold(
              drawer: NavigationDrawer(),
              appBar: AppBar(
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: InkWell(
                      overlayColor:
                          MaterialStateProperty.all(const Color(0x00000000)),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const AuthPage()));
                      },
                      child: StreamBuilder<User?>(
                        stream: FirebaseAuth.instance.authStateChanges(),
                        builder: (context, snapshot) {
                          final user = FirebaseAuth.instance.currentUser;
                          if (snapshot.hasData) {
                            return CircleAvatar(
                              radius: 15,
                              backgroundImage:
                                  NetworkImage(user!.photoURL.toString()),
                            );
                          } else {
                            return const CircleAvatar(
                              radius: 15,
                              backgroundImage: AssetImage(
                                  'lib/assets/images/emptyProfile.jpg'),
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
                onDestinationSelected: (index) =>
                    setState(() => this.index = index),
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
                  if (FirebaseAuth.instance.currentUser != null && isTourGuide)
                    NavigationDestination(
                      icon: const Icon(
                        EvaIcons.optionsOutline,
                      ),
                      selectedIcon: Icon(
                        EvaIcons.options,
                        color: myThemes.getIconColor(context),
                      ),
                      label: 'Tourist Guide Panel',
                    ),
                ],
              ),
            );
          }),
    );
  }

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

class NavigationDrawer extends StatefulWidget {
  const NavigationDrawer({
    Key? key,
  }) : super(key: key);

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
          final user = FirebaseAuth.instance.currentUser!;
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
                    CircleAvatar(
                      radius: 80,
                      backgroundImage: NetworkImage(user.photoURL.toString()),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      '${user.displayName}',
                      style: TextStyle(
                          fontSize: 28,
                          color: myThemes.getFontAllWhite(context)),
                    ),
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
            Divider(
              color: myThemes.getIconColor(context),
              thickness: 1,
            ),
            const ListTile(
              title: Text('DOT Siquijor'),
            ),
            ListTile(
              leading: const Icon(EvaIcons.browser),
              title: const Text('DOT Siquijor Website'),
              onTap: () async {
                final url = Uri.parse("https://siquijorprovince.com/");
                if (await canLaunchUrl(url)) {
                  await launchUrl(
                    url,
                    webViewConfiguration:
                        const WebViewConfiguration(enableJavaScript: true),
                    mode: LaunchMode.externalApplication,
                  );
                } else {
                  throw 'Could not launch $url';
                }
              },
            ),
            ListTile(
              leading: const Icon(EvaIcons.heart),
              title: const Text('Health Protocols'),
              onTap: () async {
                final url = Uri.parse(
                    "https://dumaguete.com/traveling-to-siquijor-requirements-restrictions-202/");
                if (await canLaunchUrl(url)) {
                  await launchUrl(
                    url,
                    webViewConfiguration:
                        const WebViewConfiguration(enableJavaScript: true),
                    mode: LaunchMode.externalApplication,
                  );
                } else {
                  throw 'Could not launch $url';
                }
              },
            ),
            ListTile(
              leading: const Icon(EvaIcons.facebook),
              title: const Text('Facebook Page'),
              onTap: () async {
                final url = Uri.parse("https://web.facebook.com/Isla.de.Fuego");
                if (await canLaunchUrl(url)) {
                  await launchUrl(
                    url,
                    webViewConfiguration:
                        const WebViewConfiguration(enableJavaScript: true),
                    mode: LaunchMode.externalApplication,
                  );
                } else {
                  throw 'Could not launch $url';
                }
              },
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
