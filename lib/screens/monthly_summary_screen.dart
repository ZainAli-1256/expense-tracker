import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_tracker/providers/transaction_provider.dart';
import 'package:expense_tracker/widgets/pie_chart_widget.dart';
import 'package:expense_tracker/widgets/transaction_card.dart';
import 'package:expense_tracker/screens/add_transaction_screen.dart';

class MonthlySummaryScreen extends StatelessWidget {
  const MonthlySummaryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monthly Summary'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Consumer<TransactionProvider>(
          builder: (context, provider, _) {
            final categorySpending = provider.getCategorySpending();

            return Column(
              children: [
                // Summary Cards
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildSummaryRow(
                        'Total Income',
                        provider.monthlyIncome,
                        Colors.green,
                      ),
                      const SizedBox(height: 12),
                      _buildSummaryRow(
                        'Total Expense',
                        provider.monthlyExpense,
                        Colors.red,
                      ),
                      const SizedBox(height: 12),
                      _buildSummaryRow(
                        'Balance',
                        provider.balance,
                        provider.balance >= 0 ? Colors.blue : Colors.orange,
                      ),
                    ],
                  ),
                ),

                // Pie Chart
                if (categorySpending.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Spending by Category',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        PieChartWidget(categorySpending: categorySpending),
                      ],
                    ),
                  ),

                // All Transactions
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'All Transactions',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                if (provider.transactions.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      children: [
                        Icon(Icons.inbox, size: 64, color: Colors.grey[300]),
                        const SizedBox(height: 16),
                        Text(
                          'No transactions',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: List.generate(
                        provider.transactions.length,
                        (index) => TransactionCard(
                          transaction: provider.transactions[index],
                          onDelete: () {
                            provider.deleteTransaction(index);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Transaction deleted'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          onEdit: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AddTransactionScreen(
                                  transaction: provider.transactions[index],
                                  transactionIndex: index,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: 24),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String title, double amount, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          Text(
            '₹${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
