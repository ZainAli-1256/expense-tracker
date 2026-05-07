import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/transaction.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';
import '../widgets/animated_background.dart';
import '../widgets/balance_card.dart';
import '../widgets/transaction_tile.dart';
import '../widgets/animated_button.dart';
import 'add_transaction_screen.dart';

/// Modern home screen displaying transactions and balance
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fabController;

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fabController.forward();

    // Add sample data on first load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final storage = context.read<StorageService>();
      if (storage.transactions.isEmpty) {
        storage.addSampleData();
      }
    });
  }

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      body: GradientBackground(
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              title: Text(
                'Expense Tracker',
                style: Theme.of(
                  context,
                ).textTheme.headlineSmall?.copyWith(color: AppTheme.textLight),
              ),
              floating: true,
            ),

            // Balance Card
            SliverToBoxAdapter(
              child: Consumer<StorageService>(
                builder: (context, storage, _) {
                  return BalanceCard(
                    balance: storage.totalBalance,
                    income: storage.totalIncome,
                    expense: storage.totalExpense,
                  );
                },
              ),
            ),

            // Transactions Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 16),
                child: Text(
                  'Recent Transactions',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppTheme.textLight,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),

            // Transactions List
            SliverPadding(
              padding: const EdgeInsets.only(bottom: 100),
              sliver: Consumer<StorageService>(
                builder: (context, storage, _) {
                  if (storage.transactions.isEmpty) {
                    return SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inbox_outlined,
                              size: 64,
                              color: AppTheme.textMuted,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No transactions yet',
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(color: AppTheme.textMuted),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Add your first transaction to get started',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: AppTheme.textMuted),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final transaction = storage.transactions[index];
                      return TransactionTile(
                        transaction: transaction,
                        onDelete: () {
                          _showDeleteDialog(context, storage, transaction);
                        },
                      );
                    }, childCount: storage.transactions.length),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // Floating Action Button
      floatingActionButton: ScaleTransition(
        scale: Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(parent: _fabController, curve: Curves.easeOutBack),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const AddTransactionScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                      return SlideTransition(
                        position:
                            Tween<Offset>(
                              begin: const Offset(0, 1),
                              end: Offset.zero,
                            ).animate(
                              CurvedAnimation(
                                parent: animation,
                                curve: Curves.easeOut,
                              ),
                            ),
                        child: child,
                      );
                    },
              ),
            );
          },
          child: AnimatedGradientFAB(
            onPressed: () {},
            icon: Icons.add,
            gradientColors: const [Color(0xFF7C3AED), Color(0xFF3B82F6)],
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    StorageService storage,
    Transaction transaction,
  ) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: AppTheme.cardDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.warning_outlined, size: 48, color: AppTheme.redError),
              const SizedBox(height: 16),
              Text(
                'Delete Transaction?',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'This action cannot be undone.',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppTheme.textMuted),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: AppTheme.cardDark,
                          border: Border.all(
                            color: const Color(0xFF374151),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Cancel',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                color: AppTheme.textLight,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        storage.deleteTransaction(transaction.id);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Transaction deleted'),
                            backgroundColor: AppTheme.redError,
                            duration: const Duration(seconds: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            margin: const EdgeInsets.all(16),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: AppTheme.redError,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Delete',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
