import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

/// Animated transaction tile widget
class TransactionTile extends StatefulWidget {
  final Transaction transaction;
  final VoidCallback? onDelete;

  const TransactionTile({Key? key, required this.transaction, this.onDelete})
      : super(key: key);

  @override
  State<TransactionTile> createState() => _TransactionTileState();
}

class _TransactionTileState extends State<TransactionTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(100 / 400, 0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
      ),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: _buildTile(context),
        ),
      ),
    );
  }

  Widget _buildTile(BuildContext context) {
    final isIncome = widget.transaction.type == 'income';
    final categoryIcon = _getCategoryIcon(widget.transaction.category);
    final categoryColor =
        isIncome ? const Color(0xFF10B981) : const Color(0xFFEF4444);

    return GestureDetector(
      onLongPress: widget.onDelete,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF374151), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Category Icon
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: categoryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: categoryColor.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Icon(categoryIcon, color: categoryColor, size: 24),
            ),
            const SizedBox(width: 16),

            // Category and Date
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.transaction.category,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDate(widget.transaction.date),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF9CA3AF),
                        ),
                  ),
                  if (widget.transaction.note != null &&
                      widget.transaction.note!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      widget.transaction.note!,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: const Color(0xFF6B7280),
                            fontStyle: FontStyle.italic,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),

            // Amount
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${isIncome ? '+' : '-'}\$${widget.transaction.amount.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: categoryColor,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  isIncome ? 'Income' : 'Expense',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: categoryColor.withValues(alpha: 0.7),
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  IconData _getCategoryIcon(String category) {
    final categoryLower = category.toLowerCase();

    const iconMap = {
      'salary': Icons.attach_money,
      'freelance': Icons.computer,
      'investment': Icons.trending_up,
      'bonus': Icons.card_giftcard,
      'groceries': Icons.shopping_basket,
      'food': Icons.restaurant,
      'utilities': Icons.lightbulb,
      'entertainment': Icons.movie,
      'transport': Icons.directions_car,
      'shopping': Icons.shopping_bag,
      'health': Icons.favorite,
      'education': Icons.school,
      'rent': Icons.home,
    };

    return iconMap[categoryLower] ?? Icons.payment;
  }
}
