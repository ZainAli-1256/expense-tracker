import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/transaction.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';
import '../widgets/animated_background.dart';
import '../widgets/animated_button.dart';

/// Modern form screen to add new transactions
class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({Key? key}) : super(key: key);

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  TransactionType _selectedType = TransactionType.expense;
  String _selectedCategory = 'Groceries';
  DateTime _selectedDate = DateTime.now();
  bool _isSubmitting = false;

  final List<String> _expenseCategories = [
    'Groceries',
    'Food',
    'Utilities',
    'Entertainment',
    'Transport',
    'Shopping',
    'Health',
    'Education',
    'Rent',
  ];

  final List<String> _incomeCategories = [
    'Salary',
    'Freelance',
    'Investment',
    'Bonus',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      appBar: AppBar(
        title: const Text('Add Transaction'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.cardDark,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF374151), width: 1),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              size: 20,
              color: AppTheme.textLight,
            ),
          ),
        ),
      ),
      body: GradientBackground(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SlideTransition(
                position:
                    Tween<Offset>(
                      begin: const Offset(0, 0.3),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(
                        parent: _controller,
                        curve: Curves.easeOut,
                      ),
                    ),
                child: FadeTransition(
                  opacity: Tween<double>(begin: 0, end: 1).animate(
                    CurvedAnimation(parent: _controller, curve: Curves.easeOut),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Type Toggle
                      _buildTypeToggle(),
                      const SizedBox(height: 28),

                      // Amount Input
                      _buildAmountInput(),
                      const SizedBox(height: 24),

                      // Category Dropdown
                      _buildCategoryDropdown(),
                      const SizedBox(height: 24),

                      // Date Picker
                      _buildDatePicker(),
                      const SizedBox(height: 24),

                      // Note Input
                      _buildNoteInput(),
                      const SizedBox(height: 32),

                      // Submit Button
                      _buildSubmitButton(),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypeToggle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Transaction Type',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: AppTheme.textLight,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppTheme.cardDark,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF374151), width: 1),
          ),
          child: Row(
            children: [
              _buildTypeButton(
                label: 'Income',
                type: TransactionType.income,
                isSelected: _selectedType == TransactionType.income,
                color: AppTheme.greenSuccess,
              ),
              const SizedBox(width: 8),
              _buildTypeButton(
                label: 'Expense',
                type: TransactionType.expense,
                isSelected: _selectedType == TransactionType.expense,
                color: AppTheme.redError,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTypeButton({
    required String label,
    required TransactionType type,
    required bool isSelected,
    required Color color,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedType = type;
            _selectedCategory = type == TransactionType.income
                ? 'Salary'
                : 'Groceries';
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.2) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? color : Colors.transparent,
              width: 2,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: isSelected ? color : AppTheme.textMuted,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAmountInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Amount',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: AppTheme.textLight,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _amountController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: Theme.of(context).textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: '0.00',
            prefixText: '\$ ',
            prefixStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppTheme.accentPurple,
              fontWeight: FontWeight.w600,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter an amount';
            }
            if (double.tryParse(value) == null) {
              return 'Please enter a valid amount';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildCategoryDropdown() {
    final categories = _selectedType == TransactionType.income
        ? _incomeCategories
        : _expenseCategories;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: AppTheme.textLight,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppTheme.cardDark,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF374151), width: 1),
          ),
          child: DropdownButton<String>(
            value: _selectedCategory,
            isExpanded: true,
            underline: const SizedBox(),
            icon: const Icon(Icons.expand_more, color: AppTheme.accentPurple),
            items: categories.map((category) {
              return DropdownMenuItem(
                value: category,
                child: Text(
                  category,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => _selectedCategory = value);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: AppTheme.textLight,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () async {
            final pickedDate = await showDatePicker(
              context: context,
              initialDate: _selectedDate,
              firstDate: DateTime(2020),
              lastDate: DateTime.now(),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: const ColorScheme.dark(
                      primary: AppTheme.accentPurple,
                      onPrimary: Colors.white,
                      surface: AppTheme.cardDark,
                      onSurface: AppTheme.textLight,
                    ),
                  ),
                  child: child!,
                );
              },
            );

            if (pickedDate != null) {
              setState(() => _selectedDate = pickedDate);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppTheme.cardDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF374151), width: 1),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: AppTheme.accentPurple,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  DateFormat('MMM dd, yyyy').format(_selectedDate),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNoteInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Note (Optional)',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: AppTheme.textLight,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _noteController,
          maxLines: 3,
          maxLength: 100,
          style: Theme.of(context).textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: 'Add a note...',
            counterStyle: const TextStyle(
              color: AppTheme.textMuted,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: AnimatedPressButton(
        onPressed: _isSubmitting ? () {} : _submitForm,
        label: 'Add Transaction',
        icon: Icons.check_circle_outline,
        isLoading: _isSubmitting,
      ),
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSubmitting = true);

    // Simulate form processing
    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;

    final amount = double.parse(_amountController.text);
    final transaction = Transaction(
      category: _selectedCategory,
      amount: amount,
      type: _selectedType,
      date: _selectedDate,
      note: _noteController.text.isEmpty ? null : _noteController.text,
    );

    context.read<StorageService>().addTransaction(transaction);

    setState(() => _isSubmitting = false);

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${_selectedType == TransactionType.income ? 'Income' : 'Expense'} added successfully!',
        ),
        backgroundColor: _selectedType == TransactionType.income
            ? AppTheme.greenSuccess
            : AppTheme.redError,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
