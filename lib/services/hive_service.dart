import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static const String transactionsBox = 'transactions';
  static const String categoriesBox = 'categories';

  static Future<void> initHive() async {
    await Hive.initFlutter();

    // Register adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(TransactionAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(CategoryAdapter());
    }

    // Open boxes
    await Hive.openBox<Transaction>(transactionsBox);
    await Hive.openBox<Category>(categoriesBox);

    // Initialize with predefined categories if empty
    final categoryBox = Hive.box<Category>(categoriesBox);
    if (categoryBox.isEmpty) {
      await categoryBox.addAll(predefinedExpenseCategories);
      await categoryBox.addAll(predefinedIncomeCategories);
    }
  }

  // Transaction operations
  static Future<void> addTransaction(Transaction transaction) async {
    final box = Hive.box<Transaction>(transactionsBox);
    await box.add(transaction);
  }

  static Future<void> updateTransaction(
    int index,
    Transaction transaction,
  ) async {
    final box = Hive.box<Transaction>(transactionsBox);
    await box.putAt(index, transaction);
  }

  static Future<void> deleteTransaction(int index) async {
    final box = Hive.box<Transaction>(transactionsBox);
    await box.deleteAt(index);
  }

  static List<Transaction> getAllTransactions() {
    final box = Hive.box<Transaction>(transactionsBox);
    return box.values.toList().cast<Transaction>();
  }

  static List<Transaction> getTransactionsByDate(DateTime date) {
    final box = Hive.box<Transaction>(transactionsBox);
    return box.values
        .where(
          (t) =>
              t.date.year == date.year &&
              t.date.month == date.month &&
              t.date.day == date.day,
        )
        .toList()
        .cast<Transaction>();
  }

  static List<Transaction> getMonthlyTransactions(int year, int month) {
    final box = Hive.box<Transaction>(transactionsBox);
    return box.values
        .where((t) => t.date.year == year && t.date.month == month)
        .toList()
        .cast<Transaction>();
  }

  // Category operations
  static List<Category> getAllCategories() {
    final box = Hive.box<Category>(categoriesBox);
    return box.values.toList().cast<Category>();
  }

  static List<Category> getExpenseCategories() {
    final box = Hive.box<Category>(categoriesBox);
    return box.values
        .where((c) => c.type == 'expense')
        .toList()
        .cast<Category>();
  }

  static List<Category> getIncomeCategories() {
    final box = Hive.box<Category>(categoriesBox);
    return box.values
        .where((c) => c.type == 'income')
        .toList()
        .cast<Category>();
  }

  static Future<void> addCategory(Category category) async {
    final box = Hive.box<Category>(categoriesBox);
    await box.add(category);
  }

  // Summary calculations
  static double getTotalIncome(int year, int month) {
    final box = Hive.box<Transaction>(transactionsBox);
    return box.values
        .where(
          (t) =>
              t.type == 'income' &&
              t.date.year == year &&
              t.date.month == month,
        )
        .fold(0, (sum, t) => sum + t.amount);
  }

  static double getTotalExpense(int year, int month) {
    final box = Hive.box<Transaction>(transactionsBox);
    return box.values
        .where(
          (t) =>
              t.type == 'expense' &&
              t.date.year == year &&
              t.date.month == month,
        )
        .fold(0, (sum, t) => sum + t.amount);
  }

  static double getBalance(int year, int month) {
    return getTotalIncome(year, month) - getTotalExpense(year, month);
  }

  // Category spending
  static Map<String, double> getCategorySpending(int year, int month) {
    final box = Hive.box<Transaction>(transactionsBox);
    final spending = <String, double>{};

    for (var transaction in box.values) {
      if (transaction.type == 'expense' &&
          transaction.date.year == year &&
          transaction.date.month == month) {
        spending[transaction.category] =
            (spending[transaction.category] ?? 0) + transaction.amount;
      }
    }

    return spending;
  }
}
