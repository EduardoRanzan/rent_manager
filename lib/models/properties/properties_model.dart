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

  List<String>? images;

  int? propertiesTypeId;
}