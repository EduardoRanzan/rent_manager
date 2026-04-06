import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rent_manager/models/properties/properties_model.dart';
import 'package:rent_manager/models/properties/properties_type_model.dart';
import 'package:rent_manager/views/properties/properties_item_page.dart';

class PropertiesPage extends StatefulWidget {
  const PropertiesPage({super.key});

  static String routeName = '/properties';

  @override
  State<StatefulWidget> createState() => _PropertiesPageState();
}

class _PropertiesPageState extends State<PropertiesPage> {
  final List<PropertiesModel> properties = [];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: properties.length,
        itemBuilder: (context, index) {
          final property = properties[index];

          return PropertiesItemPage(property: property);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}