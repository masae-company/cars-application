import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/report_provider.dart';
import '../../core/widgets/loading_indicator.dart';

class CostReportScreen extends ConsumerWidget {
  const CostReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final lastMonth = now.subtract(const Duration(days: 30));

    final costReportAsync = ref.watch(
      costReportProvider(
        CostReportParams(
          startDate: lastMonth,
          endDate: now,
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cost Report',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: costReportAsync.when(
              data: (report) {
                if (report == null) {
                  return const Center(
                    child: Text('No cost data available'),
                  );
                }

                final categories = report.costsByCategory.keys.toList();
                final values = report.costsByCategory.values.toList();

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total Cost: \$${report.totalCost.toStringAsFixed(2)}',
                                style: Theme.of(context).textTheme.headlineSmall,
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                height: 300,
                                child: PieChart(
                                  PieChartData(
                                    sections: List.generate(
                                      categories.length,
                                      (index) => PieChartSectionData(
                                        value: values[index],
                                        title: '\$${values[index].toStringAsFixed(0)}',
                                        color: _getColorForIndex(index),
                                        radius: 100,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Costs by Category',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 16),
                              ...report.costsByCategory.entries.map((entry) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(entry.key),
                                      Text(
                                        '\$${entry.value.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              loading: () =>
                  const LoadingIndicator(message: 'Loading cost report...'),
              error: (error, stack) => Center(
                child: Text('Error: $error'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getColorForIndex(int index) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.red,
      Colors.purple,
      Colors.teal,
      Colors.pink,
    ];
    return colors[index % colors.length];
  }
}

