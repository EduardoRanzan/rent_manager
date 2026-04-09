import 'package:isar/isar.dart';
import 'package:rent_manager/database/isar_service.dart';
import 'package:rent_manager/models/properties/properties_model.dart';
import 'package:rent_manager/models/properties/properties_type_model.dart';

class PropertiesRepository {
  final Isar isar = IsarService.isar;

  Future<int> save(PropertiesTypeModel type) async {
    return await isar.writeTxn(() async {
      return await isar.propertiesTypeModels.put(type);
    });
  }

  Future<void> delete(int id) async {
    await isar.writeTxn(() async {
      await isar.propertiesTypeModels.delete(id);
    });
  }

  Future<List<PropertiesTypeModel>> getAll() {
    return isar.propertiesTypeModels.where().findAll();
  }

  Future<PropertiesTypeModel?> getById(int id) {
    return isar.propertiesTypeModels.get(id);
  }
}