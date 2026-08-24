import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/report_provider.dart';
import '../../core/widgets/loading_indicator.dart';

class UsageReportScreen extends ConsumerWidget {
  const UsageReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final lastMonth = now.subtract(const Duration(days: 30));

    final usageReportAsync = ref.watch(
      usageReportProvider(
        UsageReportParams(
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
            'Usage Report',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: usageReportAsync.when(
              data: (reports) {
                if (reports.isEmpty) {
                  return const Center(
                    child: Text('No usage data available'),
                  );
                }
                return ListView.builder(
                  itemCount: reports.length,
                  itemBuilder: (context, index) {
                    final report = reports[index];
                    return Card(
                      child: ListTile(
                        title: Text(report.vehicleRegistration),
                        subtitle: Text(
                          '${report.totalAllocations} allocations, '
                          '${report.totalDays} days, '
                          '${report.totalMileage} km',
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const LoadingIndicator(message: 'Loading usage report...'),
              error: (error, stack) => Center(
                child: Text('Error: $error'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


