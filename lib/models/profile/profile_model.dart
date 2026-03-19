class ProfileModel {
  final String id;
  final String name;
  final String fone;
  final String address;
  final String email;
  final DateTime birthDate;
  final String password;
  final String? image;

  ProfileModel({
    required this.id,
    required this.name,
    required this.fone,
    required this.address,
    required this.email,
    required this.birthDate,
    required this.password,
    this.image
  });
}
