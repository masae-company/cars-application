import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/report_provider.dart';
import '../../core/widgets/loading_indicator.dart';
import '../../core/constants/route_names.dart';
import '../../core/widgets/modern_card.dart';
import 'package:go_router/go_router.dart';
import '../../auth/providers/auth_provider.dart';
import '../../auth/models/user_model.dart';

class ReportsDashboardScreen extends ConsumerStatefulWidget {
  const ReportsDashboardScreen({super.key});

  @override
  ConsumerState<ReportsDashboardScreen> createState() => _ReportsDashboardScreenState();
}

class _ReportsDashboardScreenState extends ConsumerState<ReportsDashboardScreen> {
  late final DateTime _now;
  late final DateTime _lastMonth;
  late final CostReportParams _costReportParams;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _lastMonth = _now.subtract(const Duration(days: 30));
    _costReportParams = CostReportParams(
      startDate: _lastMonth,
      endDate: _now,
    );
  }

  @override
  Widget build(BuildContext context) {
    final costReportAsync = ref.watch(
      costReportProvider(_costReportParams),
    );
    final userRole = ref.watch(authProvider).value?.role;

    // Define visibility based on roles
    final canViewFinancials = userRole == UserRole.superAdmin || userRole == UserRole.accountant;
    final canViewVehicleAnalysis = userRole == UserRole.superAdmin || userRole == UserRole.carsAdmin;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Reports & Analytics',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'View insights, track costs, and generate vehicle reports.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
            ),
            const SizedBox(height: 32),

            // Report Tiles Grid
            LayoutBuilder(
              builder: (context, constraints) {
                // Responsive grid: 1 column on mobile, 3 on wide screens
                final crossAxisCount = constraints.maxWidth > 900 ? 3 : (constraints.maxWidth > 600 ? 2 : 1);
                
                final tiles = <Widget>[
                  if (canViewFinancials)
                    _buildReportTile(
                      context,
                      title: 'Usage Reports',
                      description: 'View vehicle allocations and usage statistics.',
                      icon: Icons.access_time_filled,
                      color: Colors.blue,
                      route: RouteNames.usageReport,
                    ),
                  if (canViewFinancials)
                    _buildReportTile(
                      context,
                      title: 'Cost Analysis',
                      description: 'Track expenses and analyze cost effectiveness.',
                      icon: Icons.pie_chart,
                      color: Colors.orange,
                      route: RouteNames.costReport,
                    ),
                  if (canViewVehicleAnalysis)
                    _buildReportTile(
                      context,
                      title: 'Vehicle Analysis',
                      description: 'Comprehensive health checks & PDF exports.',
                      icon: Icons.car_repair,
                      color: Colors.green,
                      route: RouteNames.vehicleAnalysisReport,
                    ),
                ];

                if (tiles.isEmpty) {
                  return const Center(child: Text('No reports available for your role.'));
                }

                return GridView.count(
                  crossAxisCount: crossAxisCount,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 24,
                  mainAxisSpacing: 24,
                  childAspectRatio: 1.3,
                  children: tiles,
                );
              },
            ),

            if (canViewFinancials) ...[
              const SizedBox(height: 32),

              // Quick Summary Section
              Text(
                'Monthly Overview',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              costReportAsync.when(
                data: (report) {
                  if (report == null) {
                    return const ModernCard(child: Text('No data available'));
                  }
                  return ModernCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Total Expenses',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '\$${report.totalCost.toStringAsFixed(2)}',
                                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.attach_money,
                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 32),
                        ...report.costsByCategory.entries.map((entry) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(child: Text(entry.key)),
                                Text(
                                  '\$${entry.value.toStringAsFixed(2)}',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  );
                },
                loading: () => const Center(child: LoadingIndicator()),
                error: (error, stack) => ModernCard(child: Text('Error: $error')),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildReportTile(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required String route,
  }) {
    return ModernCard(
      onTap: () => context.push(route),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const Spacer(),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                'View Report',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.arrow_forward_rounded, color: color, size: 16),
            ],
          ),
        ],
      ),
    );
  }
}

