import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:rent_manager/database/repositories/properties/properties_repository.dart';
import 'package:rent_manager/models/properties/properties_model.dart';

class PropertiesFormPage extends StatefulWidget {
  final PropertiesModel? property;

  const PropertiesFormPage({super.key, this.property});

  @override
  State<PropertiesFormPage> createState() => _PropertiesFormPageState();
}

class _PropertiesFormPageState extends State<PropertiesFormPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _rentPriceController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool? _isRented;

  final _repo = PropertiesRepository();

  @override
  void initState() {
    super.initState();

    if (widget.property != null) {
      final e = widget.property!;


      _nameController.text = e.name;
      _rentPriceController.text = e.rentPrice.toString();
      _descriptionController.text = e.description ?? '';
      _isRented = e.isRented;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _rentPriceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.property != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Imóvel' : 'Novo Imóvel'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              spacing: 10,
              children: [
                _buildName(),
                _buildDescription(),
                _buildIsRented(),
                _buildRentPrice(),
                _buildButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildName() {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(labelText: 'Nome...'),
      validator: (value) =>
      value == null || value.isEmpty ? 'Informe o nome' : null,
    );
  }

  Widget _buildDescription() {
    return TextFormField(
      controller: _descriptionController,
      decoration: const InputDecoration(labelText: 'Descrição...'),
    );
  }

  Widget _buildIsRented() {
    return Row(
      children: [
        Text('Alugado: '),
        Switch(
          value: _isRented ?? true,
          onChanged: (value) {
            setState(() {
              _isRented = value;
            });
          },
        )
      ]
    );
  }

  Widget _buildRentPrice() {
    return TextFormField(
      controller: _rentPriceController,
      decoration: const InputDecoration(labelText: 'Valor...'),
      validator: (value) =>
      value == null || value.isEmpty ? 'Informe o nome' : null,
      keyboardType: TextInputType.number,
      inputFormatters: [
        MoneyInputFormatter(
          useSymbolPadding: true,
          leadingSymbol: 'R\$',
          mantissaLength: 2
        )
      ],
    );
  }

  Widget _buildButtons() {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton(onPressed: _goBack, child: const Text('Cancelar')),
          widget.property != null ? IconButton(
            onPressed: () {
              _delete(widget.property!.id);
            },
            icon: Icon(Icons.delete, color: Theme.of(context).colorScheme.error)
          ) : const SizedBox(),
          FilledButton(
            onPressed: _save,
            child: const Text('Salvar'),
          ),
        ],
      )
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final property = widget.property ?? PropertiesModel();

    final value = _rentPriceController.text;
    final numeric = value.replaceAll(RegExp(r'[^0-9]'), '');
    final rentPrice =
    numeric.isEmpty ? 0.0 : double.parse(numeric) / 100;

    property
      ..name = _nameController.text
      ..description = _descriptionController.text
      ..rentPrice = rentPrice
      ..latitude = 0
      ..longitude = 0
      ..propertiesTypeId = 0
      ..isRented = _isRented ?? true;

    await _repo.save(property);

    if (mounted) {
      _goBack();
    }
  }

  Future<void> _delete(int id) async {
    try {
      await _repo.delete(id);

      _goBack();
    } catch(e) {
      rethrow;
    }
  }

  void _goBack() {
    Navigator.pop(context, true);
  }
}