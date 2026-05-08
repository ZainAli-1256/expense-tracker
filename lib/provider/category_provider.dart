import 'package:flutter/material.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/services/hive_service.dart';

class CategoryProvider extends ChangeNotifier {
  List<Category> _expenseCategories = [];
  List<Category> _incomeCategories = [];

  List<Category> get expenseCategories => _expenseCategories;
  List<Category> get incomeCategories => _incomeCategories;

  CategoryProvider() {
    loadCategories();
  }

  void loadCategories() {
    _expenseCategories = HiveService.getExpenseCategories();
    _incomeCategories = HiveService.getIncomeCategories();
    notifyListeners();
  }

  Future<void> addCustomCategory(Category category) async {
    await HiveService.addCategory(category);
    loadCategories();
  }

  Category? getCategoryByName(String name) {
    try {
      return [
        ..._expenseCategories,
        ..._incomeCategories,
      ].firstWhere((c) => c.name == name);
    } catch (e) {
      return null;
    }
  }
}
