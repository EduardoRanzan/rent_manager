import 'package:isar/isar.dart';

part 'profile_model.g.dart';

@collection
class ProfileModel {
  Id id = Isar.autoIncrement;

  late String name;

  late String fone;

  late String address;

  late String email;

  late DateTime birthDate;

  late String password;

  late String? image;
}
