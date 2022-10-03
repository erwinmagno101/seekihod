import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:seekihod/pages/items_page.dart';

import '../widget/change_theme_button_widget.dart';

class Item {
  final String name;
  final Icon icon;

  const Item({
    required this.name,
    required this.icon,
  });
}

class MenuView extends StatefulWidget {
  const MenuView({Key? key}) : super(key: key);

  @override
  State<MenuView> createState() => _MenuViewState();
}

List<Item> items = [
  const Item(
    name: 'Profile',
    icon: Icon(Icons.person),
  ),
  const Item(
    name: 'Settings',
    icon: Icon(Icons.settings),
  ),
  const Item(
    name: 'Hotline',
    icon: Icon(Icons.call),
  ),
  const Item(
    name: 'FAQs',
    icon: Icon(Icons.question_mark),
  ),
  const Item(
    name: 'Protocols',
    icon: Icon(Icons.rule),
  ),
  const Item(
    name: 'Articles',
    icon: Icon(Icons.article),
  ),
  const Item(
    name: 'Contact Us',
    icon: Icon(Icons.phone_enabled),
  ),
  const Item(
    name: 'About Us',
    icon: Icon(Icons.developer_board),
  ),
  const Item(
    name: 'Facebook',
    icon: Icon(Icons.facebook),
  ),
  const Item(
    name: 'Twitter',
    icon: Icon(Icons.stop),
  ),
  const Item(
    name: 'Instagram',
    icon: Icon(Icons.stop),
  ),
  const Item(
    name: 'Privacy Policy',
    icon: Icon(
      Icons.privacy_tip,
    ),
  ),
];

class _MenuViewState extends State<MenuView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(),
    );
  }
}
