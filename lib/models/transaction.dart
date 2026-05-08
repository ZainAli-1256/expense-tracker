import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'transaction.g.dart';

@HiveType(typeId: 0)
class Transaction extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String type; // 'income' or 'expense'

  @HiveField(2)
  late double amount;

  @HiveField(3)
  late String category;

  @HiveField(4)
  late DateTime date;

  @HiveField(5)
  late String note;

  Transaction({
    String? id,
    required this.type,
    required this.amount,
    required this.category,
    required this.date,
    required this.note,
  }) {
    this.id = id ?? const Uuid().v4();
  }

  Transaction.empty()
    : id = const Uuid().v4(),
      type = 'expense',
      amount = 0,
      category = '',
      date = DateTime.now(),
      note = '';
}
