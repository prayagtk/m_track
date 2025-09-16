import 'package:hive_flutter/hive_flutter.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  late String email;
  @HiveField(1)
  late String password;
  @HiveField(2)
  late String name;
  @HiveField(3)
  late String phone;
  @HiveField(4)
  late int status;

  UserModel({
    required this.email,
    required this.password,
    required this.name,
    required this.phone,
    this.status = 0,
  });
}
