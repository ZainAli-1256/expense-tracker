import 'package:flutter/foundation.dart';
import '../models/transaction.dart';

/// Storage service for managing transactions (Phase 1: In-memory)
/// Future phases will integrate Hive for persistent storage
class StorageService extends ChangeNotifier {
  final List<Transaction> _transactions = [];

  /// Get all transactions
  List<Transaction> get transactions => List.unmodifiable(_transactions);

  /// Get total balance (income - expense)
  double get totalBalance {
    double income = 0;
    double expense = 0;

    for (var transaction in _transactions) {
      if (transaction.type == TransactionType.income) {
        income += transaction.amount;
      } else {
        expense += transaction.amount;
      }
    }

    return income - expense;
  }

  /// Get total income
  double get totalIncome {
    return _transactions
        .where((t) => t.type == TransactionType.income)
        .fold(0, (sum, t) => sum + t.amount);
  }

  /// Get total expense
  double get totalExpense {
    return _transactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0, (sum, t) => sum + t.amount);
  }

  /// Add a new transaction
  void addTransaction(Transaction transaction) {
    _transactions.insert(0, transaction); // Most recent first
    notifyListeners();
  }

  /// Delete a transaction
  void deleteTransaction(String id) {
    _transactions.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  /// Get transactions by date (grouped)
  Map<DateTime, List<Transaction>> getTransactionsByDate() {
    final Map<DateTime, List<Transaction>> grouped = {};

    for (var transaction in _transactions) {
      final date = DateTime(
        transaction.date.year,
        transaction.date.month,
        transaction.date.day,
      );

      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(transaction);
    }

    return grouped;
  }

  /// Clear all transactions (for testing/resetting)
  void clearAllTransactions() {
    _transactions.clear();
    notifyListeners();
  }

  /// Add sample data for demonstration
  void addSampleData() {
    final now = DateTime.now();

    _transactions.addAll([
      Transaction(
        category: 'Salary',
        amount: 5000,
        type: TransactionType.income,
        date: now.subtract(Duration(days: 5)),
        note: 'Monthly salary',
      ),
      Transaction(
        category: 'Groceries',
        amount: 150,
        type: TransactionType.expense,
        date: now.subtract(Duration(days: 4)),
        note: 'Weekly shopping',
      ),
      Transaction(
        category: 'Freelance',
        amount: 800,
        type: TransactionType.income,
        date: now.subtract(Duration(days: 3)),
        note: 'Project payment',
      ),
      Transaction(
        category: 'Entertainment',
        amount: 50,
        type: TransactionType.expense,
        date: now.subtract(Duration(days: 2)),
        note: 'Movie tickets',
      ),
      Transaction(
        category: 'Utilities',
        amount: 200,
        type: TransactionType.expense,
        date: now.subtract(Duration(days: 1)),
        note: 'Electricity bill',
      ),
    ]);

    notifyListeners();
  }
}
