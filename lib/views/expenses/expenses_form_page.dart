import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rent_manager/database/repositories/expenses/expenses_repository.dart';
import 'package:rent_manager/models/expenses/expenses_model.dart';

class ExpensesFormPage extends StatefulWidget {
  final ExpensesModel? expense;

  const ExpensesFormPage({super.key, this.expense});

  @override
  State<ExpensesFormPage> createState() => _ExpensesFormPageState();
}

class _ExpensesFormPageState extends State<ExpensesFormPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _valueController = TextEditingController();
  final _propertyController = TextEditingController();

  DateTime? _date;
  DateTime? _deadline;
  int? _expensesTypeId;

  final _repo = ExpensesRepository();

  final _dateFormat = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();

    if (widget.expense != null) {
      final e = widget.expense!;

      _nameController.text = e.name;
      _valueController.text = e.value.toString();
      _propertyController.text = e.propertyId;

      _date = e.date;
      _deadline = e.deadline;
      _expensesTypeId = e.expensesTypeId;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _valueController.dispose();
    _propertyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.expense != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Despesa' : 'Nova Despesa'),
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
                _buildValue(),
                _buildProperty(),
                _buildDatePicker(),
                _buildDeadlinePicker(),
                const SizedBox(height: 20),
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
    return TextFormField(
      controller: _propertyController,
      decoration: const InputDecoration(labelText: 'Property ID'),
    );
  }

  Widget _buildDatePicker() {
    return ListTile(
      title: Text(
        _date == null
            ? 'Selecionar data'
            : 'Data: ${_dateFormat.format(_date!)}',
      ),
      trailing: const Icon(Icons.calendar_today),
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: _date ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2100),
        );

        if (picked != null) {
          setState(() => _date = picked);
        }
      },
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
          widget.expense == null ? IconButton(
            onPressed: _delete,
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

    final expense = widget.expense ?? ExpensesModel();

    expense
      ..name = _nameController.text
      ..value = double.tryParse(_valueController.text) ?? 0
      ..propertyId = _propertyController.text
      ..date = _date ?? DateTime.now()
      ..deadline = _deadline ?? DateTime.now()
      ..expensesTypeId = _expensesTypeId ?? 1;

    await _repo.save(expense);

    if (mounted) {
      Navigator.pop(context);
    }
  }

  Future<void> _delete() async {

  }

  void _goBack() {
    Navigator.of(context).pop();
  }
}