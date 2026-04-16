import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rent_manager/database/repositories/expenses/expenses_repository.dart';
import 'package:rent_manager/database/repositories/expenses/expenses_type_repository.dart';
import 'package:rent_manager/database/repositories/properties/properties_repository.dart';
import 'package:rent_manager/models/expenses/expenses_model.dart';
import 'package:rent_manager/models/properties/properties_model.dart';
import 'package:rent_manager/views/expenses/type/expenses_type_form.dart';

class ExpensesFormPage extends StatefulWidget {
  final ExpensesModel? expense;

  const ExpensesFormPage({super.key, this.expense});

  @override
  State<ExpensesFormPage> createState() => _ExpensesFormPageState();
}

class _ExpensesFormPageState extends State<ExpensesFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final theme = Theme.of(context).colorScheme;

  final _nameController = TextEditingController();
  final _valueController = TextEditingController();

  List<PropertiesModel>? properties;

  DateTime? _date;
  DateTime? _deadline;
  late int _propertyId = 0;

  final _repo = ExpensesRepository();
  final _repoProperties = PropertiesRepository();

  final _dateFormat = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.expense != null;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(isEditing ? 'Editar Despesa' : 'Nova Despesa'),
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: theme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _dateFormat.format(_date!),
                style: TextStyle(
                  color: theme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 12
                ),
              ),
            ),
          ],
        )
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsetsGeometry.symmetric(vertical: 15, horizontal: 5),
          child: Container(
            padding: EdgeInsetsGeometry.all(15),
            decoration: BoxDecoration(
              color: theme.surfaceContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                spacing: 10,
                children: [
                  _buildName(),
                  _buildValue(),
                  _buildProperty(),
                  _buildDeadlinePicker(),
                  const SizedBox(height: 20),
                  _buildButtons(),
                ],
              ),
            ),
          )
        ),
      ),
    );
  }

  Widget _buildName() {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(labelText: 'Nome'),
      validator: (value) =>
      value == null || value.isEmpty ? 'Informe o nome' : null,
    );
  }

  Widget _buildValue() {
    return TextFormField(
      controller: _valueController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(labelText: 'Valor'),
      validator: (value) =>
      value == null || value.isEmpty ? 'Informe o valor' : null,
    );
  }

  Widget _buildProperty() {
    if (properties == null) {
      return const CircularProgressIndicator();
    }
    return DropdownMenu(
      width: double.infinity,
      initialSelection: widget.expense != null
          ? _propertyId
          : null,
      onSelected: (value) {
        _propertyId = value!;
      },
      menuStyle: MenuStyle(
        padding: WidgetStateProperty.all(const EdgeInsets.all(15)),
      ),
      dropdownMenuEntries: properties!.map((property) {
        return DropdownMenuEntry(
          value: property.id,
          label: property.name,
        );
      }).toList(),
    );
  }

  Widget _buildDeadlinePicker() {
    return ListTile(
      title: Text(
        _deadline == null
            ? 'Selecionar vencimento'
            : 'Vencimento: ${_dateFormat.format(_deadline!)}',
      ),
      trailing: const Icon(Icons.calendar_today),
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: _deadline ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2100),
        );

        if (picked != null) {
          setState(() => _deadline = picked);
        }
      },
    );
  }

  Widget _buildButtons() {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton(onPressed: _goBack, child: const Text('Cancelar')),
          widget.expense != null ? IconButton(
            onPressed: () {
              _delete(widget.expense!.id);
            },
            icon: Icon(Icons.delete, color: theme.error)
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

    final expense = widget.expense ?? ExpensesModel();


    expense
      ..name = _nameController.text
      ..value = double.tryParse(_valueController.text) ?? 0
      ..propertyId = _propertyId
      ..date = widget.expense != null ? widget.expense!.date : DateTime.now()
      ..deadline = _deadline ?? DateTime.now();

    await _repo.save(expense);

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

  Future<void> _init() async{
    _date = DateTime.now();
    final props = await _repoProperties.getAll();

    setState(() {
      properties = props;
    });

    if (widget.expense != null) {
      _nameController.text = widget.expense!.name;
      _valueController.text = widget.expense!.value.toString();
      _propertyId = widget.expense!.propertyId;

      _date = widget.expense!.date;
      _deadline = widget.expense!.deadline;
    }
  }
}