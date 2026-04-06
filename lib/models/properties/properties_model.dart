import 'package:isar/isar.dart';

part 'properties_model.g.dart';

@collection
class PropertiesModel {
  Id id = 0;

  late String name;

  late double rentPrice;

  late double latitude;

  late double longitude;

  late bool isRented;

  String? description;

  List<String>? images;

  late int propertiesTypeId;
}