import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rent_manager/models/profile/profile_model.dart';
import 'package:rent_manager/models/properties/properties_model.dart';
import 'package:rent_manager/models/properties/properties_type_model.dart';
import 'package:rent_manager/models/expenses/expenses_model.dart';
import 'package:rent_manager/models/expenses/expenses_type_model.dart';

class IsarService {
  static late Isar isar;

  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();

    isar = await Isar.open(
      [
        ExpensesModelSchema,
        ExpensesTypeModelSchema,
        PropertiesModelSchema,
        PropertiesTypeModelSchema,
        ProfileModelSchema,
      ],
      directory: dir.path,
    );
  }
}