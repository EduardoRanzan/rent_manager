import 'package:isar/isar.dart';

part 'properties_model.g.dart';

@collection
class PropertiesModel {
  Id id = Isar.autoIncrement;

  late String name;

  late double rentPrice;

  late double? latitude;

  late double? longitude;

  late bool isRented;

  String? description;

  String? cep;

  String? street;

  String? number;

  String? complement;

  String? neighborhood;

  String? city;

  String? state;

  List<String>? images;

  int? propertiesTypeId;
}
