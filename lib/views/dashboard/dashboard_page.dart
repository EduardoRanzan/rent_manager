import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rent_manager/models/expenses/expenses_model.dart';
import 'package:rent_manager/models/expenses/expenses_type_model.dart';
import 'package:rent_manager/models/properties/properties_model.dart';
import 'package:rent_manager/models/properties/properties_type_model.dart';
import 'package:rent_manager/views/expenses/expenses_page.dart';
import 'package:rent_manager/views/properties/properties_item_page.dart';
import 'package:rent_manager/views/properties/properties_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  static String routeName = '/dashboard';

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 15,
          children: [
            _buildFinanceCard(theme),
            _buildPropertiesCard(theme),
            _buildExpensesCard(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildFinanceCard(ThemeData theme) {
    return Card(
      color: Colors.white70.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _financeItem(
              theme,
              'A receber',
              'R\$ 5.000',
              theme.colorScheme.tertiary,
            ),
            _financeItem(
              theme,
              'Recebido',
              'R\$ 12.000',
              theme.colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _financeItem(
      ThemeData theme,
      String title,
      String value,
      Color color,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildPropertiesCard(ThemeData theme) {

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
          icon: const Icon(Icons.home, color: Colors.blue),
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
          icon: const Icon(Icons.apartment_outlined, color: Colors.red),
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
          icon: const Icon(Icons.add_business, color: Colors.orange),
          color: Colors.orange,
        ),
      ),
    ];

    return Card(
      color: Colors.white70.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                child: Text(
                  'Imóveis',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pushNamed(PropertiesPage.routeName);
                },
              )
            ),

            const SizedBox(height: 12),

            ...properties.map((property) {
              return PropertiesItemPage(property: property);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildExpensesCard(ThemeData theme) {
    final currency = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

    final expenses = [
      ExpensesModel(
        id: '1',
        name: 'Luz',
        type: ExpensesTypeModel(
          id: '1',
          icon: Icon(Icons.flash_on, color: Colors.yellow),
          name: 'Energia',
          color: Colors.yellow,
        ),
        value: 100,
        date: DateTime.now(),
        deadline: DateTime.now(),
        propertieId: '',
      ),
      ExpensesModel(
        id: '2',
        name: 'Água',
        type: ExpensesTypeModel(
          id: '2',
          icon: Icon(Icons.water_drop, color: Colors.blue),
          name: 'Água',
          color: Colors.blue,
        ),
        value: 80,
        date: DateTime.now(),
        deadline: DateTime.now(),
        propertieId: '',
      ),
    ];

    return Card(
      color: Colors.white70.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(ExpensesPage.routeName);
                },
                child: Text(
                  'Despesas',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            ...expenses.map((expense) {
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                color: expense.type.color.withOpacity(0.2),
                elevation: 0,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),

                  leading: CircleAvatar(
                    backgroundColor: theme.colorScheme.surface,
                    child: expense.type.icon,
                  ),

                  title: Text(
                    expense.name,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  subtitle: Text(
                    DateFormat('dd/MM').format(expense.date),
                    style: theme.textTheme.bodySmall,
                  ),

                  trailing: Text(
                    currency.format(expense.value),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: expense.type.color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}