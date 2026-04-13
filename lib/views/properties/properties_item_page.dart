import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rent_manager/models/properties/properties_model.dart';
import 'package:rent_manager/views/properties/properties_form_page.dart';

class PropertiesItemPage extends StatelessWidget {
  final PropertiesModel property;
  final ThemeData theme;
  final NumberFormat currency;
  final VoidCallback onUpdate;

  const PropertiesItemPage({
    super.key,
    required this.property,
    required this.theme,
    required this.currency,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currency = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),

        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.surface,
          child: Icon(
            property.isRented
                ? Icons.home
                : Icons.home_outlined,
            color: theme.colorScheme.primary,
          ),
        ),

        title: Text(
          property.name,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),

        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),

            Text(
              property.isRented ? 'Alugado' : 'Disponível',
              style: TextStyle(
                color: property.isRented
                    ? Colors.red
                    : Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),

            if (property.description != null)
              Text(
                property.description!,
                style: theme.textTheme.bodySmall,
              ),
          ],
        ),

        trailing: Text(
          currency.format(property.rentPrice),
          style: TextStyle(
            color: theme.colorScheme.primaryContainer,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: () => _edit(context, property),
      ),
    );
  }

  Future<void> _edit(BuildContext context, PropertiesModel property) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => PropertiesFormPage(property: property,))
    );

    if (result == true) {
      onUpdate;
    }
  }
}