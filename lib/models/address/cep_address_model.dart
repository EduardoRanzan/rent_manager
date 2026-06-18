import 'package:json_annotation/json_annotation.dart';

part 'cep_address_model.g.dart';

@JsonSerializable()
class CepAddressModel {
  final String? cep;
  final String? logradouro;
  final String? complemento;
  final String? bairro;
  final String? localidade;
  final String? uf;
  final bool? erro;

  const CepAddressModel({
    this.cep,
    this.logradouro,
    this.complemento,
    this.bairro,
    this.localidade,
    this.uf,
    this.erro,
  });

  factory CepAddressModel.fromJson(Map<String, dynamic> json) =>
      _$CepAddressModelFromJson(json);

  Map<String, dynamic> toJson() => _$CepAddressModelToJson(this);
}
