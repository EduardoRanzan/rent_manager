import 'package:flutter/cupertino.dart';

class BottomNavigationBarItemModel {
  final Widget page;
  final BottomNavigationBarItem item;
  final int index;

  BottomNavigationBarItemModel({
    required this.page,
    required this.item,
    required this.index,
  });
}
