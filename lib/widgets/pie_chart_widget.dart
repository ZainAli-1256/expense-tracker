import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PieChartWidget extends StatelessWidget {
  final Map<String, double> categorySpending;

  const PieChartWidget({Key? key, required this.categorySpending})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (categorySpending.isEmpty) {
      return Center(
        child: Text(
          'No spending data',
          style: TextStyle(color: Colors.grey[600]),
        ),
      );
    }

    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.yellow,
      Colors.pink,
      Colors.teal,
    ];

    List<PieChartSectionData> sections = [];
    int colorIndex = 0;

    categorySpending.forEach((category, amount) {
      sections.add(
        PieChartSectionData(
          color: colors[colorIndex % colors.length],
          value: amount,
          title: category,
          radius: 80,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
      colorIndex++;
    });

    return Column(
      children: [
        SizedBox(
          height: 300,
          child: PieChart(
            PieChartData(
              sections: sections,
              centerSpaceRadius: 40,
              sectionsSpace: 2,
            ),
          ),
        ),
        const SizedBox(height: 20),
        // Legend
        Wrap(
          spacing: 16,
          runSpacing: 12,
          children: List.generate(categorySpending.length, (index) {
            final entries = categorySpending.entries.toList();
            final entry = entries[index];
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: colors[index % colors.length],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${entry.key}: ₹${entry.value.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            );
          }),
        ),
      ],
    );
  }
}
