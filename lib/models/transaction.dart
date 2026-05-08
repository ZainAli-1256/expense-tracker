import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'transaction.g.dart';

@HiveType(typeId: 0)
class Transaction extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String type; // 'income' or 'expense'

  @HiveField(2)
  double amount;

  @HiveField(3)
  String category;

  @HiveField(4)
  DateTime date;

  @HiveField(5)
  String note;

  Transaction({
    String? id,
    required this.type,
    required this.amount,
    required this.category,
    required this.date,
    required this.note,
  }) : id = id ?? const Uuid().v4();
}
