import 'package:flutter/material.dart';

import '../views/menu_view.dart';

class ItemsPage extends StatelessWidget {
  final Item item;

  const ItemsPage({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          item.name,
          style: const TextStyle(fontSize: 72),
        ),
      ),
    );
  }
}
