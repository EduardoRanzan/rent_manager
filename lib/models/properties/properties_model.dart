import 'package:rent_manager/models/properties/properties_type_model.dart';

class PropertiesModel {
  final String id;
  final String name;
  final double rentPrice;
  final double latitude;
  final double longitude;
  final bool isRented;
  final String? description;
  final List<String>? images;
  final PropertiesTypeModel type;

  PropertiesModel({
    required this.id,
    required this.name,
    required this.rentPrice,
    required this.latitude,
    required this.longitude,
    required this.isRented,
    this.description,
    this.images,
    required this.type,
  });
}