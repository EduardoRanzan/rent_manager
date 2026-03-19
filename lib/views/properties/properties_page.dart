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
  final List<PropertiesModel> properties = [
    PropertiesModel(
      id: '1',
      name: 'Casa Centro',
      rentPrice: 2500,
      latitude: 0,
      longitude: 0,
      isRented: true,
      description: 'Casa com 3 quartos',
      images: [],
      type: PropertiesTypeModel(
        id: '1',
        name: 'Casa',
        icon: Icon(Icons.home, color: Colors.blue),
        color: Colors.blue,
      ),
    ),
    PropertiesModel(
      id: '2',
      name: 'Ap 202',
      rentPrice: 1800,
      latitude: 0,
      longitude: 0,
      isRented: false,
      description: 'Apartamento compacto',
      images: [],
      type: PropertiesTypeModel(
        id: '1',
        name: 'Apartamento',
        icon: Icon(Icons.apartment_outlined, color: Colors.red),
        color: Colors.red,
      ),
    ),
    PropertiesModel(
      id: '3',
      name: 'Sala Comercial',
      rentPrice: 5000,
      latitude: 0,
      longitude: 0,
      isRented: false,
      description: 'Suuuuper sala comercial',
      images: [],
      type: PropertiesTypeModel(
        id: '1',
        name: 'Sala comercial',
        icon: Icon(Icons.add_business, color: Colors.orange),
        color: Colors.orange,
      ),
    ),
  ];

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