import 'package:flutter/material.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<BottomNavigationBarItem> items;

  const BottomNavigationBarWidget({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: items,
      type: BottomNavigationBarType.fixed,

      selectedItemColor: Theme.of(context).colorScheme.primary,
      showSelectedLabels: false,
      selectedIconTheme: IconThemeData(
        color: Theme.of(context).colorScheme.primary,
        size: 35
      ),

      unselectedItemColor: Colors.grey,
      showUnselectedLabels: false,
      unselectedIconTheme: IconThemeData(
        color: Colors.grey,
        size: 30
      ),
    );
  }
}