import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rent_manager/models/address/cep_address_model.dart';

class CepService {
  CepService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<CepAddressModel> findByCep(String cep) async {
    final normalizedCep = cep.replaceAll(RegExp(r'\D'), '');

    if (normalizedCep.length != 8) {
      throw const CepServiceException('Informe um CEP com 8 números.');
    }

    final response = await _client
        .get(Uri.https('viacep.com.br', '/ws/$normalizedCep/json/'))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw const CepServiceException(
        'Não foi possível consultar o CEP agora.',
      );
    }

    final json = jsonDecode(utf8.decode(response.bodyBytes));
    final address = CepAddressModel.fromJson(json as Map<String, dynamic>);

    if (address.erro == true) {
      throw const CepServiceException('CEP não encontrado.');
    }

    return address;
  }
}

class CepServiceException implements Exception {
  final String message;

  const CepServiceException(this.message);

  @override
  String toString() => message;
}
