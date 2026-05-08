import 'package:flutter/material.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/services/hive_service.dart';

class TransactionProvider extends ChangeNotifier {
  List<Transaction> _transactions = [];
  DateTime _selectedMonth = DateTime.now();

  List<Transaction> get transactions => _transactions;
  DateTime get selectedMonth => _selectedMonth;

  double get monthlyIncome =>
      HiveService.getTotalIncome(_selectedMonth.year, _selectedMonth.month);

  double get monthlyExpense =>
      HiveService.getTotalExpense(_selectedMonth.year, _selectedMonth.month);

  double get balance =>
      HiveService.getBalance(_selectedMonth.year, _selectedMonth.month);

  TransactionProvider() {
    loadTransactions();
  }

  void loadTransactions() {
    _transactions = HiveService.getMonthlyTransactions(
      _selectedMonth.year,
      _selectedMonth.month,
    );
    notifyListeners();
  }

  Future<void> addTransaction(Transaction transaction) async {
    await HiveService.addTransaction(transaction);
    loadTransactions();
  }

  Future<void> deleteTransaction(int index) async {
    await HiveService.deleteTransaction(index);
    loadTransactions();
  }

  Future<void> updateTransaction(int index, Transaction transaction) async {
    await HiveService.updateTransaction(index, transaction);
    loadTransactions();
  }

  void setSelectedMonth(DateTime month) {
    _selectedMonth = month;
    loadTransactions();
    notifyListeners();
  }

  void previousMonth() {
    _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1);
    loadTransactions();
    notifyListeners();
  }

  void nextMonth() {
    _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1);
    loadTransactions();
    notifyListeners();
  }

  List<Transaction> getTransactionsByCategory(String category) {
    return _transactions.where((t) => t.category == category).toList();
  }

  Map<String, double> getCategorySpending() {
    return HiveService.getCategorySpending(
      _selectedMonth.year,
      _selectedMonth.month,
    );
  }
}
