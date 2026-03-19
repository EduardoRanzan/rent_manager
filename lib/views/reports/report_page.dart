import 'package:flutter/material.dart';

class ReportPage extends StatefulWidget{
  const ReportPage({super.key});

  static String routeName = '/report';

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    );
  }
}