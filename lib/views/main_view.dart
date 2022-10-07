import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seekihod/UI/theme_provider.dart';
import 'package:seekihod/models/GlobalVar.dart';
import 'package:seekihod/pages/Auth_page.dart';
import 'package:seekihod/views/archive_view.dart';
import 'package:seekihod/views/events_view.dart';
import 'package:seekihod/views/feature_view.dart';
import 'package:seekihod/views/home_view.dart';

import '../widget/change_theme_button_widget.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

final MyThemes myThemes = MyThemes();

class _MainViewState extends State<MainView> {
  int index = 2;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavigationDrawer(),
      appBar: AppBar(
        actions: [
          InkWell(
            overlayColor: MaterialStateProperty.all(const Color(0x00000000)),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const AuthPage()));
            },
            child: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    padding: const EdgeInsets.only(right: 10),
                    child: const CircleAvatar(
                      radius: 15,
                    ),
                  );
                } else {
                  return Container(
                    padding: const EdgeInsets.only(right: 10),
                    child: const CircleAvatar(
                      radius: 15,
                    ),
                  );
                }
              },
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

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Drawer(
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

  Widget buildHeader(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Material(
            color: myThemes.getIconColorDark(context),
            child: InkWell(
              onTap: () {
                print('object');
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
                    const CircleAvatar(
                      radius: 52,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      'Name of the User',
                      style: TextStyle(
                          fontSize: 28,
                          color: myThemes.getFontAllWhite(context)),
                    ),
                    Text(
                      'user.email.com',
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
              leading: Icon(EvaIcons.moonOutline),
              title: Text('Dark mode'),
              trailing: ChangeThemeButtonWidget(),
            ),
            const ListTile(
              leading: Icon(EvaIcons.moonOutline),
              title: Text('Sign out'),
            ),
            Divider(
              color: myThemes.getIconColor(context),
              thickness: 1,
            ),
            const ListTile(
              title: Text('DOT Siquijor'),
            ),
            const ListTile(
              leading: Icon(EvaIcons.moonOutline),
              title: Text('Health Protocols'),
            ),
            const ListTile(
              leading: Icon(EvaIcons.moonOutline),
              title: Text('FAQs'),
            ),
            const ListTile(
              leading: Icon(EvaIcons.moonOutline),
              title: Text('Hotline'),
            ),
            const ListTile(
              leading: Icon(EvaIcons.moonOutline),
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
              leading: Icon(EvaIcons.moonOutline),
              title: Text('Contact Us'),
            ),
            const ListTile(
              leading: Icon(EvaIcons.moonOutline),
              title: Text('Facebook'),
            ),
            const ListTile(
              leading: Icon(EvaIcons.moonOutline),
              title: Text('Instagram'),
            ),
            const ListTile(
              leading: Icon(EvaIcons.moonOutline),
              title: Text('Developers'),
            ),
          ],
        ),
      );
}
