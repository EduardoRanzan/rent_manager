import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:rent_manager/database/repositories/properties/properties_repository.dart';
import 'package:rent_manager/models/properties/properties_model.dart';
import 'package:rent_manager/services/cep_service.dart';
import 'package:rent_manager/services/location_service.dart';

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
  final _cepController = TextEditingController();
  final _streetController = TextEditingController();
  final _numberController = TextEditingController();
  final _complementController = TextEditingController();
  final _neighborhoodController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();

  bool? _isRented;
  bool _isSearchingCep = false;
  bool _isGettingLocation = false;
  String? _lastSearchedCep;
  double? _latitude;
  double? _longitude;

  final _repo = PropertiesRepository();
  final _cepService = CepService();
  final _locationService = LocationService();

  @override
  void initState() {
    super.initState();

    if (widget.property != null) {
      final e = widget.property!;

      _nameController.text = e.name;
      _rentPriceController.text = e.rentPrice.toString();
      _descriptionController.text = e.description ?? '';
      _cepController.text = e.cep ?? '';
      _streetController.text = e.street ?? '';
      _numberController.text = e.number ?? '';
      _complementController.text = e.complement ?? '';
      _neighborhoodController.text = e.neighborhood ?? '';
      _cityController.text = e.city ?? '';
      _stateController.text = e.state ?? '';
      _isRented = e.isRented;
      _latitude = e.latitude;
      _longitude = e.longitude;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _rentPriceController.dispose();
    _descriptionController.dispose();
    _cepController.dispose();
    _streetController.dispose();
    _numberController.dispose();
    _complementController.dispose();
    _neighborhoodController.dispose();
    _cityController.dispose();
    _stateController.dispose();
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
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                spacing: 10,
                children: [
                  _buildName(),
                  _buildDescription(),
                  _buildIsRented(),
                  _buildRentPrice(),
                  const Divider(height: 28),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Endereço',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  _buildCep(),
                  _buildStreet(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildNumber()),
                      const SizedBox(width: 10),
                      Expanded(child: _buildComplement()),
                    ],
                  ),
                  _buildNeighborhood(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 3, child: _buildCity()),
                      const SizedBox(width: 10),
                      Expanded(child: _buildState()),
                    ],
                  ),
                  const SizedBox(height: 6),
                  _buildLocation(),
                  const SizedBox(height: 10),
                  _buildButtons(),
                ],
              ),
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
    return Row(children: [
      Text('Alugado: '),
      Switch(
        value: _isRented ?? true,
        onChanged: (value) {
          setState(() {
            _isRented = value;
          });
        },
      )
    ]);
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
            useSymbolPadding: true, leadingSymbol: 'R\$', mantissaLength: 2)
      ],
    );
  }

  Widget _buildCep() {
    return TextFormField(
      controller: _cepController,
      decoration: InputDecoration(
        labelText: 'CEP',
        hintText: '00000-000',
        suffixIcon: _isSearchingCep
            ? const Padding(
                padding: EdgeInsets.all(12),
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : IconButton(
                tooltip: 'Buscar CEP',
                onPressed: _searchCep,
                icon: const Icon(Icons.search),
              ),
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [MaskedInputFormatter('00000-000')],
      textInputAction: TextInputAction.search,
      onFieldSubmitted: (_) => _searchCep(),
      onChanged: (value) {
        final cep = value.replaceAll(RegExp(r'\D'), '');
        if (cep.length == 8 && cep != _lastSearchedCep) {
          _searchCep();
        }
      },
      validator: (value) {
        final cep = value?.replaceAll(RegExp(r'\D'), '') ?? '';
        return cep.length == 8 ? null : 'Informe um CEP válido';
      },
    );
  }

  Widget _buildStreet() => TextFormField(
        controller: _streetController,
        decoration: const InputDecoration(labelText: 'Logradouro'),
        validator: _requiredAddressField,
      );

  Widget _buildNumber() => TextFormField(
        controller: _numberController,
        decoration: const InputDecoration(labelText: 'Número'),
        keyboardType: TextInputType.streetAddress,
        validator: _requiredAddressField,
      );

  Widget _buildComplement() => TextFormField(
        controller: _complementController,
        decoration: const InputDecoration(labelText: 'Complemento'),
      );

  Widget _buildNeighborhood() => TextFormField(
        controller: _neighborhoodController,
        decoration: const InputDecoration(labelText: 'Bairro'),
        validator: _requiredAddressField,
      );

  Widget _buildCity() => TextFormField(
        controller: _cityController,
        decoration: const InputDecoration(labelText: 'Cidade'),
        validator: _requiredAddressField,
      );

  Widget _buildState() => TextFormField(
        controller: _stateController,
        decoration: const InputDecoration(labelText: 'UF'),
        textCapitalization: TextCapitalization.characters,
        validator: _requiredAddressField,
      );

  String? _requiredAddressField(String? value) =>
      value == null || value.trim().isEmpty ? 'Obrigatório' : null;

  Widget _buildLocation() {
    final hasLocation = _latitude != null &&
        _longitude != null &&
        !(_latitude == 0 && _longitude == 0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OutlinedButton.icon(
          onPressed: _isGettingLocation ? null : _getCurrentLocation,
          icon: _isGettingLocation
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.my_location),
          label: Text(
            _isGettingLocation
                ? 'Obtendo localização...'
                : hasLocation
                    ? 'Atualizar localização'
                    : 'Usar localização atual',
          ),
        ),
        if (hasLocation)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              'Coordenadas: ${_latitude!.toStringAsFixed(6)}, '
              '${_longitude!.toStringAsFixed(6)}',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
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
            widget.property != null
                ? IconButton(
                    onPressed: () {
                      _delete(widget.property!.id);
                    },
                    icon: Icon(Icons.delete,
                        color: Theme.of(context).colorScheme.error))
                : const SizedBox(),
            FilledButton(
              onPressed: _save,
              child: const Text('Salvar'),
            ),
          ],
        ));
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final property = widget.property ?? PropertiesModel();

    final value = _rentPriceController.text;
    final numeric = value.replaceAll(RegExp(r'[^0-9]'), '');
    final rentPrice = numeric.isEmpty ? 0.0 : double.parse(numeric) / 100;

    property
      ..name = _nameController.text
      ..description = _descriptionController.text
      ..cep = _cepController.text
      ..street = _streetController.text.trim()
      ..number = _numberController.text.trim()
      ..complement = _complementController.text.trim()
      ..neighborhood = _neighborhoodController.text.trim()
      ..city = _cityController.text.trim()
      ..state = _stateController.text.trim().toUpperCase()
      ..rentPrice = rentPrice
      ..latitude = _latitude
      ..longitude = _longitude
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
    } catch (e) {
      rethrow;
    }
  }

  void _goBack() {
    Navigator.pop(context, true);
  }

  Future<void> _searchCep() async {
    if (_isSearchingCep) return;

    final cep = _cepController.text.replaceAll(RegExp(r'\D'), '');
    if (cep.length != 8) {
      _showMessage('Informe um CEP com 8 números.');
      return;
    }

    setState(() => _isSearchingCep = true);

    try {
      final address = await _cepService.findByCep(cep);
      if (!mounted) return;

      _lastSearchedCep = cep;
      _streetController.text = address.logradouro ?? '';
      _complementController.text = address.complemento ?? '';
      _neighborhoodController.text = address.bairro ?? '';
      _cityController.text = address.localidade ?? '';
      _stateController.text = address.uf ?? '';
      FocusScope.of(context).unfocus();
    } on CepServiceException catch (error) {
      if (mounted) _showMessage(error.message);
    } catch (_) {
      if (mounted) {
        _showMessage(
            'Falha na conexão. Verifique sua internet e tente novamente.');
      }
    } finally {
      if (mounted) setState(() => _isSearchingCep = false);
    }
  }

  Future<void> _getCurrentLocation() async {
    if (_isGettingLocation) return;

    setState(() => _isGettingLocation = true);

    try {
      final location = await _locationService.getCurrentLocation();
      if (!mounted) return;

      setState(() {
        _latitude = location.position.latitude;
        _longitude = location.position.longitude;
        _fillAddressFromLocation(location);
      });
      _showMessage(
        location.placemark == null
            ? 'Coordenadas capturadas, mas o endereço não foi encontrado.'
            : 'Localização e endereço preenchidos com sucesso.',
      );
    } on LocationServiceException catch (error) {
      if (mounted) _showMessage(error.message);
    } catch (_) {
      if (mounted) {
        _showMessage('Não foi possível obter a localização agora.');
      }
    } finally {
      if (mounted) setState(() => _isGettingLocation = false);
    }
  }

  void _fillAddressFromLocation(CapturedLocation location) {
    final place = location.placemark;
    if (place == null) return;

    final cep = _formatCep(place.postalCode);
    _setControllerText(_cepController, cep);
    _setControllerText(
      _streetController,
      _firstNotEmpty([place.thoroughfare, place.street]),
    );
    _setControllerText(_numberController, place.subThoroughfare);
    _setControllerText(
      _neighborhoodController,
      _firstNotEmpty([place.subLocality, place.subAdministrativeArea]),
    );
    _setControllerText(
      _cityController,
      _firstNotEmpty([place.locality, place.subAdministrativeArea]),
    );
    _setControllerText(_stateController, _stateToUf(place.administrativeArea));

    final normalizedCep = cep.replaceAll(RegExp(r'\D'), '');
    if (normalizedCep.length == 8) _lastSearchedCep = normalizedCep;
  }

  void _setControllerText(TextEditingController controller, String? value) {
    if (value != null && value.trim().isNotEmpty) {
      controller.text = value.trim();
    }
  }

  String _firstNotEmpty(List<String?> values) {
    return values.firstWhere(
          (value) => value != null && value.trim().isNotEmpty,
          orElse: () => '',
        ) ??
        '';
  }

  String _formatCep(String? value) {
    final digits = value?.replaceAll(RegExp(r'\D'), '') ?? '';
    if (digits.length != 8) return value ?? '';
    return '${digits.substring(0, 5)}-${digits.substring(5)}';
  }

  String? _stateToUf(String? state) {
    if (state == null || state.trim().isEmpty) return null;

    final normalized = state.trim().toLowerCase();
    if (normalized.length == 2) return normalized.toUpperCase();

    const states = {
      'acre': 'AC',
      'alagoas': 'AL',
      'amapá': 'AP',
      'amazonas': 'AM',
      'bahia': 'BA',
      'ceará': 'CE',
      'distrito federal': 'DF',
      'espírito santo': 'ES',
      'goiás': 'GO',
      'maranhão': 'MA',
      'mato grosso': 'MT',
      'mato grosso do sul': 'MS',
      'minas gerais': 'MG',
      'pará': 'PA',
      'paraíba': 'PB',
      'paraná': 'PR',
      'pernambuco': 'PE',
      'piauí': 'PI',
      'rio de janeiro': 'RJ',
      'rio grande do norte': 'RN',
      'rio grande do sul': 'RS',
      'rondônia': 'RO',
      'roraima': 'RR',
      'santa catarina': 'SC',
      'são paulo': 'SP',
      'sergipe': 'SE',
      'tocantins': 'TO',
    };

    return states[normalized] ?? state;
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.primary,
        showCloseIcon: true,
        behavior: SnackBarBehavior.floating,
      ));
  }
}
