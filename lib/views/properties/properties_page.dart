import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rent_manager/database/repositories/expenses/expenses_repository.dart';
import 'package:rent_manager/database/repositories/properties/properties_repository.dart';
import 'package:rent_manager/models/expenses/expenses_model.dart';
import 'package:rent_manager/models/expenses/expenses_type_model.dart';
import 'package:rent_manager/models/properties/properties_model.dart';
import 'package:rent_manager/views/expenses/expenses_form_page.dart';
import 'package:rent_manager/views/expenses/expenses_item_page.dart';
import 'package:rent_manager/views/properties/properties_form_page.dart';
import 'package:rent_manager/views/properties/properties_item_page.dart';

class PropertiesPage extends StatefulWidget {
  const PropertiesPage({super.key});

  static String routeName = '/properties';

  @override
  State<StatefulWidget> createState() => _PropertiesPageState();
}

class _PropertiesPageState extends State<PropertiesPage> {
  late List<PropertiesModel> properties = [];

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currency = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

    return Scaffold(
      appBar: AppBar(title: Text('Propriedades'),),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: properties.length,
        itemBuilder: (context, index) {
          final property = properties[index];

          return PropertiesItemPage(
            property: property,
            theme: theme,
            currency: currency,
            onUpdate: _init,
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _new,
        backgroundColor: theme.colorScheme.primaryContainer,
        child: Icon(
          Icons.add,
          color: theme.colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }

  void _new({PropertiesModel? property}) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PropertiesFormPage(property: property),
      ),
    );
    if (result == true) {
      _init();
    }
  }

  Future<void> _init() async {
    final propertiesData = await PropertiesRepository().getAll();
    setState(() {
      properties = propertiesData;
    });
  }
}