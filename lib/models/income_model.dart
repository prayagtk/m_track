import 'package:hive_flutter/adapters.dart';

part 'income_model.g.dart';

@HiveType(typeId: 2)
class IncomeModel extends HiveObject {
  @HiveField(0)
  late String id;
  @HiveField(1)
  late String userId;
  @HiveField(2)
  late double amount;
  @HiveField(3)
  late String description;
  @HiveField(4)
  late String category;
  @HiveField(5)
  late DateTime createdAt;

  IncomeModel({
    required this.id,
    required this.userId,
    required this.amount,
    required this.description,
    required this.category,
    required this.createdAt,
  });
}
