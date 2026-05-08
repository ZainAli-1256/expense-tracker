import 'package:hive/hive.dart';

part 'category.g.dart';

@HiveType(typeId: 1)
class Category extends HiveObject {
  @HiveField(0)
  late String name;

  @HiveField(1)
  late String icon;

  @HiveField(2)
  late String type; // 'income' or 'expense'

  @HiveField(3)
  late String color;

  Category({
    required this.name,
    required this.icon,
    required this.type,
    required this.color,
  });
}

// Predefined categories
final List<Category> predefinedExpenseCategories = [
  Category(name: 'Food', icon: '🍔', type: 'expense', color: '#FF6B6B'),
  Category(name: 'Travel', icon: '✈️', type: 'expense', color: '#4ECDC4'),
  Category(name: 'Bills', icon: '📄', type: 'expense', color: '#45B7D1'),
  Category(name: 'Shopping', icon: '🛍️', type: 'expense', color: '#FFA07A'),
  Category(
    name: 'Entertainment',
    icon: '🎬',
    type: 'expense',
    color: '#98D8C8',
  ),
  Category(name: 'Health', icon: '⚕️', type: 'expense', color: '#F7DC6F'),
  Category(name: 'Education', icon: '📚', type: 'expense', color: '#BB8FCE'),
  Category(name: 'Other', icon: '📌', type: 'expense', color: '#85C1E2'),
];

final List<Category> predefinedIncomeCategories = [
  Category(name: 'Salary', icon: '💼', type: 'income', color: '#00C896'),
  Category(name: 'Freelance', icon: '💻', type: 'income', color: '#06D6A0'),
  Category(name: 'Investment', icon: '📈', type: 'income', color: '#118AB2'),
  Category(name: 'Bonus', icon: '🎁', type: 'income', color: '#073B4C'),
  Category(name: 'Other', icon: '📌', type: 'income', color: '#06A77D'),
];
