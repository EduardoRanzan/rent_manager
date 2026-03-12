import 'package:flutter/cupertino.dart';
import 'package:rent_manager/views/home/home_page.dart';

class AppRoutes {
  static Map<String, Widget Function(BuildContext)> initRoutes() {
    return {
      '/home': (context) => HomePage(),
    };
  }
}