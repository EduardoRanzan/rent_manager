import 'package:flutter/material.dart';
import 'package:rent_manager/models/bottom_navigation_bar_item_model.dart';
import 'package:rent_manager/views/dashboard/dashboard_page.dart';
import 'package:rent_manager/widgets/bottom_navigation_bar_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static String routeName = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<BottomNavigationBarItemModel> itemModel = [
    BottomNavigationBarItemModel(
      page: DashboardPage(),
      item: BottomNavigationBarItem(
        icon: Icon(Icons.home)
      ),
      index: 0
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: itemModel.map((item) => item.page).toList()
      ),
      bottomNavigationBar: BottomNavigationBarWidget(
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        currentIndex: _currentIndex,
        items: itemModel.map((item) => item.item).toList(),
      ),
    );
  }

  Widget _home() {
    return Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: EdgeInsetsGeometry.all(10),
      child: Text('Home'),
    );
  }


}
