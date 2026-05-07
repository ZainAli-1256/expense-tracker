import 'package:uuid/uuid.dart';

/// Enum for transaction type
enum TransactionType { income, expense }

/// Transaction model for managing income and expense data
class Transaction {
  final String id;
  final String category;
  final double amount;
  final TransactionType type;
  final DateTime date;
  final String? note;

  Transaction({
    String? id,
    required this.category,
    required this.amount,
    required this.type,
    required this.date,
    this.note,
  }) : id = id ?? const Uuid().v4();

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'amount': amount,
      'type': type == TransactionType.income ? 'income' : 'expense',
      'date': date.toIso8601String(),
      'note': note,
    };
  }

  /// Create from JSON
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as String,
      category: json['category'] as String,
      amount: (json['amount'] as num).toDouble(),
      type: json['type'] == 'income'
          ? TransactionType.income
          : TransactionType.expense,
      date: DateTime.parse(json['date'] as String),
      note: json['note'] as String?,
    );
  }

  /// Create a copy with modified fields
  Transaction copyWith({
    String? id,
    String? category,
    double? amount,
    TransactionType? type,
    DateTime? date,
    String? note,
  }) {
    return Transaction(
      id: id ?? this.id,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      date: date ?? this.date,
      note: note ?? this.note,
    );
  }
}
