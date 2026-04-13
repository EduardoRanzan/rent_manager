import 'package:flutter/material.dart';
import 'package:rent_manager/database/repositories/expenses/expenses_type_repository.dart';
import 'package:rent_manager/models/expenses/expenses_type_model.dart';

class ExpensesTypeForm extends StatefulWidget {
  final ExpensesTypeModel? expenseType;

  const ExpensesTypeForm({super.key, this.expenseType});

  @override
  State<ExpensesTypeForm> createState() => _ExpensesTypeFormState();
}

class _ExpensesTypeFormState extends State<ExpensesTypeForm> {
  late ColorScheme theme = Theme.of(context).colorScheme;
  final _repo = ExpensesTypeRepository();

  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  int? _iconCode;
  int? _colorValue;

  final List<Color> _colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.pink,
    Colors.yellow,
    Colors.brown,
    Colors.grey,
  ];

  final List<IconData> _icons = [
    Icons.home,
    Icons.attach_money,
    Icons.shopping_cart,
    Icons.directions_car,
    Icons.fastfood,
    Icons.work,
    Icons.water_drop,
    Icons.flash_on,
    Icons.car_crash,
    Icons.gavel,
    Icons.corporate_fare,
    Icons.calculate,
    Icons.book,
    Icons.carpenter,
    Icons.person
  ];

  @override
  void initState() {
    super.initState();

    if (widget.expenseType != null) {
      _nameController.text = widget.expenseType!.name;
      _iconCode = widget.expenseType!.iconCode;
      _colorValue = widget.expenseType!.colorValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.expenseType != null
            ? 'Editar Tipo de Despesa'
            : 'Novo Tipo de Despesa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return Form(
      key: _formKey,
      child: _buildForm(),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Nome...'),
          ),
          _selectIcon(),
          _selectColor(),
          const SizedBox(height: 50),
          _buildButtons()
        ],
      ),
    );
  }

  Widget _selectIcon() {
    return Column(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Selecione um ícone:', style: Theme.of(context).textTheme.bodyLarge),
        Wrap(
          children: _icons.map((icon) {
            final selected = _iconCode == _icons.indexOf(icon);
            return Card(
              color: selected ? theme.primaryContainer : theme.onSurface,
              child: IconButton(
                onPressed: () {
                  setState(() {
                    _iconCode = _icons.indexOf(icon);
                  });
                },
                icon: Icon(
                  icon,
                  color: selected ? theme.onPrimaryContainer : theme.surface,
                ),
              )
            );
          }).toList(),
        )
      ],
    );
  }

  Widget _selectColor() {
    return Column(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Selecione uma cor:', style: Theme.of(context).textTheme.bodyLarge),
        Wrap(
          children: _colors.map((color) {
            final selected = _colorValue == _colors.indexOf(color);
            return Card(
              color: color,
              child: Padding(
                padding: EdgeInsetsGeometry.all(5),
                child: IconButton(
                  icon: Icon(selected ? Icons.check_circle : null, color: theme.onSurface,),
                  onPressed: () {
                    setState(() {
                      _colorValue = _colors.indexOf(color);
                    });
                  },
                )
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildButtons() {
    return SizedBox(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(onPressed: _goBack, child: const Text('Cancelar')),
            widget.expenseType != null ? IconButton(
                onPressed: () {
                  _delete(widget.expenseType!.id);
                },
                icon: Icon(Icons.delete, color: Theme.of(context).colorScheme.error)
            ) : Container(),
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
    try {
      final expenseType = widget.expenseType ?? ExpensesTypeModel();

      expenseType.name = _nameController.text;
      expenseType.iconCode = _iconCode ?? 0;
      expenseType.colorValue = _colorValue ?? 0;

      await _repo.save(expenseType);

      if (mounted) {
        _goBack();
      }
    } catch (e) {
      rethrow;
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