import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:exui/exui.dart';
import '../../auth/providers/auth_provider.dart';
import '../../auth/models/user_model.dart';
import '../../maintenance/providers/maintenance_request_provider.dart';
import '../../maintenance/models/maintenance_request_model.dart';
import '../../expenses/providers/expense_provider.dart';
import '../../expenses/models/expense_model.dart';
import '../../allocations/providers/allocation_provider.dart';
import '../../allocations/models/allocation_model.dart';
import '../../vehicles/providers/vehicle_provider.dart';
import '../../core/constants/route_names.dart';
import '../../core/widgets/loading_indicator.dart';
import '../../core/config/supabase_config.dart';
import '../../core/config/database_schema.dart';
import '../../core/theme/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../core/utils/date_formatters.dart' as date_utils;

// Helper function to get car info for display
Future<Map<String, dynamic>?> _getCarInfo(String carId) async {
  try {
    final response = await SupabaseConfig.client
        .from(DatabaseSchema.cars)
        .select('${DatabaseSchema.model}, ${DatabaseSchema.number}')
        .eq(DatabaseSchema.id, carId)
        .maybeSingle();
    return response;
  } catch (e) {
    return null;
  }
}

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).value;
    final userRole = user?.role ?? UserRole.employee;

    // Show role-specific dashboard
    switch (userRole) {
      case UserRole.carsAdmin:
      case UserRole.superAdmin:
        return const _CarsAdminDashboard();
      case UserRole.accountant:
        return const _AccountantDashboard();
      case UserRole.warehouseKeeper:
        return const _WarehouseKeeperDashboard();
      default:
        return Center(
          child: Text(
            AppLocalizations.of(context)!.accessDenied,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        );
    }
  }
}

/// Dashboard for Cars Admin - Shows maintenance requests, vehicles overview
class _CarsAdminDashboard extends ConsumerWidget {
  const _CarsAdminDashboard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingRequests = ref.watch(
      maintenanceRequestListProvider(
        MaintenanceRequestListParams(
          statusFilter: MaintenanceRequestStatus.pending,
          limit: 5,
        ),
      ),
    );

    final inProgressRequests = ref.watch(
      maintenanceRequestListProvider(
        MaintenanceRequestListParams(
          statusFilter: MaintenanceRequestStatus.inProgress,
          limit: 5,
        ),
      ),
    );

    final vehicleCountAsync = ref.watch(vehicleCountProvider);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats Grid
          _buildStatsGrid(
            context: context,
            pendingCount: pendingRequests.when(
              data: (requests) => requests.length,
              loading: () => 0,
              error: (_, __) => 0,
            ),
            inProgressCount: inProgressRequests.when(
              data: (requests) => requests.length,
              loading: () => 0,
              error: (_, __) => 0,
            ),
            vehicleCount: vehicleCountAsync.when(
              data: (count) => count,
              loading: () => 0,
              error: (_, __) => 0,
            ),
          ),

          // Pending Requests Section
          _buildRequestsSection(
            context: context,
            title: AppLocalizations.of(context)!.pendingMaintenanceRequests,
            requests: pendingRequests,
            icon: Icons.pending_actions,
            color: AppColors.warning,
            route: RouteNames.maintenanceRequests,
            showCreateButton: true,
          ),

          // In Progress Requests Section
          _buildRequestsSection(
            context: context,
            title: AppLocalizations.of(context)!.inProgressRequestsTitle,
            requests: inProgressRequests,
            icon: Icons.build_circle,
            color: AppColors.info,
            route: RouteNames.maintenanceRequests,
            showCreateButton: false,
          ),
        ],
      ).padding(const EdgeInsets.all(24)),
    );
  }

  Widget _buildStatsGrid({
    required BuildContext context,
    required int pendingCount,
    required int inProgressCount,
    required int vehicleCount,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Row(
        children: [
          Expanded(
            child: _ModernStatCard(
              title: AppLocalizations.of(context)!.pendingRequests,
              value: pendingCount.toString(),
              icon: Icons.pending_actions,
              gradient: const LinearGradient(
                colors: [Color(0xFFFF9800), Color(0xFFFFB74D)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              onTap: () => context.go(RouteNames.maintenanceRequests),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _ModernStatCard(
              title: AppLocalizations.of(context)!.inProgress,
              value: inProgressCount.toString(),
              icon: Icons.build_circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF2196F3), Color(0xFF64B5F6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              onTap: () => context.go(RouteNames.maintenanceRequests),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _ModernStatCard(
              title: AppLocalizations.of(context)!.totalVehicles,
              value: vehicleCount.toString(),
              icon: Icons.directions_car,
              gradient: const LinearGradient(
                colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              onTap: () => context.go(RouteNames.vehicles),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestsSection({
    required BuildContext context,
    required String title,
    required AsyncValue<List<MaintenanceRequestModel>> requests,
    required IconData icon,
    required Color color,
    required String route,
    bool showCreateButton = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: _ModernCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(icon, color: color, size: 24),
                    const SizedBox(width: 12),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    if (showCreateButton)
                      ElevatedButton.icon(
                        onPressed: () => context.push('${RouteNames.maintenanceRequests}/create'),
                        icon: const Icon(Icons.add, size: 18),
                        label: Text(AppLocalizations.of(context)!.create),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                      ),
                    if (showCreateButton) const SizedBox(width: 8),
                    TextButton(
                      onPressed: () => context.go(route),
                      child: Text(
                        AppLocalizations.of(context)!.viewAll,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            requests.when(
              data: (requestList) {
                if (requestList.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Text(
                        AppLocalizations.of(context)!.noRequestsFound,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  );
                }
                return Column(
                  children: requestList.map((request) {
                    return _RequestListItem(
                      request: request,
                      color: color,
                    );
                  }).toList(),
                );
              },
              loading: () => const Padding(
                padding: EdgeInsets.all(32.0),
                child: LoadingIndicator(),
              ),
              error: (error, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Text(
                    '${AppLocalizations.of(context)!.error}: $error',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.error,
                        ),
                  ),
                ),
              ),
            ),
          ],
        ).padding(const EdgeInsets.all(24)),
      ),
    );
  }

}

/// Dashboard for Accountant - Shows financial overview, allocations, expenses
class _AccountantDashboard extends ConsumerWidget {
  const _AccountantDashboard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allocationsAsync = ref.watch(
      allocationListProvider(AllocationListParams(limit: 5)),
    );

    final expensesAsync = ref.watch(
      expenseListProvider(
        ExpenseListParams(
          transactionTypeFilter: TransactionType.expense,
          limit: 5,
        ),
      ),
    );

    final allocationsListAsync = ref.watch(
      expenseListProvider(
        ExpenseListParams(
          transactionTypeFilter: TransactionType.allocation,
          limit: 5,
        ),
      ),
    );

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Financial Stats Grid
          _buildFinancialStatsGrid(
            context: context,
            allocationsAsync: allocationsListAsync,
            expensesAsync: expensesAsync,
          ),

          // Recent Allocations Section
          _buildTransactionsSection(
            context: context,
            title: AppLocalizations.of(context)!.recentAllocations,
            transactions: allocationsAsync,
            icon: Icons.arrow_upward,
            color: AppColors.success,
            route: RouteNames.allocations,
          ),

          // Recent Expenses Section
          _buildExpensesSection(
            context: context,
            expenses: expensesAsync,
          ),
        ],
      ).padding(const EdgeInsets.all(24)),
    );
  }

  Widget _buildFinancialStatsGrid({
    required BuildContext context,
    required AsyncValue<List<ExpenseModel>> allocationsAsync,
    required AsyncValue<List<ExpenseModel>> expensesAsync,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Row(
        children: [
          Expanded(
            child: allocationsAsync.when(
              data: (allocations) {
                final total = allocations.fold<double>(
                  0,
                  (sum, allocation) => sum + allocation.amount,
                );
                return _ModernStatCard(
                  title: AppLocalizations.of(context)!.totalAllocations,
                  value: '\$${total.toStringAsFixed(2)}',
                  icon: Icons.arrow_upward,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  onTap: () => context.go(RouteNames.allocations),
                );
              },
              loading: () => _ModernStatCard(
                title: AppLocalizations.of(context)!.totalAllocations,
                value: '-',
                icon: Icons.arrow_upward,
                gradient: LinearGradient(
                  colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
                ),
              ),
              error: (_, __) => _ModernStatCard(
                title: AppLocalizations.of(context)!.totalAllocations,
                value: 'Error',
                icon: Icons.arrow_upward,
                gradient: LinearGradient(
                  colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: expensesAsync.when(
              data: (expenses) {
                final total = expenses.fold<double>(
                  0,
                  (sum, expense) => sum + expense.amount,
                );
                return _ModernStatCard(
                  title: AppLocalizations.of(context)!.totalExpenses,
                  value: '\$${total.toStringAsFixed(2)}',
                  icon: Icons.arrow_downward,
                  gradient: const LinearGradient(
                    colors: [Color(0xFFBA1A1A), Color(0xFFEF5350)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  onTap: () => context.go(RouteNames.expenses),
                );
              },
              loading: () => _ModernStatCard(
                title: AppLocalizations.of(context)!.totalExpenses,
                value: '-',
                icon: Icons.arrow_downward,
                gradient: LinearGradient(
                  colors: [Color(0xFFBA1A1A), Color(0xFFEF5350)],
                ),
              ),
              error: (_, __) => _ModernStatCard(
                title: AppLocalizations.of(context)!.totalExpenses,
                value: 'Error',
                icon: Icons.arrow_downward,
                gradient: LinearGradient(
                  colors: [Color(0xFFBA1A1A), Color(0xFFEF5350)],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsSection({
    required BuildContext context,
    required String title,
    required AsyncValue<List<AllocationModel>> transactions,
    required IconData icon,
    required Color color,
    required String route,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: _ModernCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(icon, color: color, size: 24),
                    const SizedBox(width: 12),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () => context.go(route),
                  child: Text(
                    AppLocalizations.of(context)!.viewAll,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            transactions.when(
              data: (transactionList) {
                if (transactionList.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Text(
                        AppLocalizations.of(context)!.noTransactionsFound,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  );
                }
                return Column(
                  children: transactionList.take(5).map((allocation) {
                    return _TransactionListItem(
                      allocation: allocation,
                      color: color,
                    );
                  }).toList(),
                );
              },
              loading: () => const Padding(
                padding: EdgeInsets.all(32.0),
                child: LoadingIndicator(),
              ),
              error: (error, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Text(
                    '${AppLocalizations.of(context)!.error}: $error',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.error,
                        ),
                  ),
                ),
              ),
            ),
          ],
        ).padding(const EdgeInsets.all(24)),
      ),
    );
  }

  Widget _buildExpensesSection({
    required BuildContext context,
    required AsyncValue<List<ExpenseModel>> expenses,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: _ModernCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.receipt, color: AppColors.error, size: 24),
                    const SizedBox(width: 12),
                    Text(
                      AppLocalizations.of(context)!.recentExpenses,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => context.push(RouteNames.expenseCreate),
                      icon: const Icon(Icons.add, size: 18),
                      label: Text(AppLocalizations.of(context)!.create),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () => context.push(RouteNames.expenses),
                      child: Text(
                        AppLocalizations.of(context)!.viewAll,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            expenses.when(
              data: (expenseList) {
                if (expenseList.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Text(
                        AppLocalizations.of(context)!.noExpensesFound,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  );
                }
                return Column(
                  children: expenseList.take(5).map((expense) {
                    return _ExpenseListItem(expense: expense);
                  }).toList(),
                );
              },
              loading: () => const Padding(
                padding: EdgeInsets.all(32.0),
                child: LoadingIndicator(),
              ),
              error: (error, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Text(
                    '${AppLocalizations.of(context)!.error}: $error',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.error,
                        ),
                  ),
                ),
              ),
            ),
          ],
        ).padding(const EdgeInsets.all(24)),
      ),
    );
  }

}

/// Dashboard for Warehouse Keeper - Shows inventory overview
class _WarehouseKeeperDashboard extends ConsumerWidget {
  const _WarehouseKeeperDashboard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: _ModernCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.toolsAndInventory,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context)!.inventoryManagementComingSoon,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: AppColors.onSurfaceVariant,
                        ),
                  ),
                ],
              ).padding(const EdgeInsets.all(24)),
            ),
          ),
        ],
      ),
    );
  }
}

// Professional Stat Card Widget - Corporate Design
class _ModernStatCard extends StatefulWidget {
  final String title;
  final String value;
  final IconData icon;
  final Gradient gradient;
  final VoidCallback? onTap;

  const _ModernStatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.gradient,
    this.onTap,
  });

  @override
  State<_ModernStatCard> createState() => _ModernStatCardState();
}

class _ModernStatCardState extends State<_ModernStatCard> {
  bool _isHovered = false;

  Color _getAccentColor() {
    if (widget.gradient is LinearGradient) {
      final linearGradient = widget.gradient as LinearGradient;
      return linearGradient.colors.first;
    }
    return const Color(0xFF1E3A8A);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = _getAccentColor();
    
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 140,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isHovered 
                ? accentColor.withOpacity(0.3)
                : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.04),
              blurRadius: _isHovered ? 12 : 8,
              offset: Offset(0, _isHovered ? 6 : 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Icon and title row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icon container
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: accentColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          widget.icon,
                          color: accentColor,
                          size: 22,
                        ),
                      ),
                      const Spacer(),
                      // Arrow indicator
                      if (widget.onTap != null)
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          transform: Matrix4.translationValues(
                            _isHovered ? 2 : 0,
                            0,
                            0,
                          ),
                          child: Icon(
                            Icons.arrow_forward,
                            color: (isDark ? Colors.white : Colors.black)
                                .withOpacity(0.3),
                            size: 18,
                          ),
                        ),
                    ],
                  ),
                  
                  // Value and title
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.value,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                              fontSize: 28,
                              letterSpacing: -0.5,
                              height: 1.0,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.title,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: (isDark ? Colors.white : Colors.black)
                                  .withOpacity(0.6),
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              height: 1.2,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


// Modern Card Widget
class _ModernCard extends StatelessWidget {
  final Widget child;

  const _ModernCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

// Request List Item - Modern Redesign
class _RequestListItem extends StatelessWidget {
  final MaintenanceRequestModel request;
  final Color color;

  const _RequestListItem({
    required this.request,
    required this.color,
  });

  Color _getStatusColor(MaintenanceRequestStatus status) {
    switch (status) {
      case MaintenanceRequestStatus.pending:
        return AppColors.warning;
      case MaintenanceRequestStatus.inProgress:
        return AppColors.info;
      case MaintenanceRequestStatus.completed:
        return AppColors.success;
    }
  }

  String _getStatusName(BuildContext context, MaintenanceRequestStatus status) {
    switch (status) {
      case MaintenanceRequestStatus.pending:
        return AppLocalizations.of(context)!.pending;
      case MaintenanceRequestStatus.inProgress:
        return AppLocalizations.of(context)!.inProgress;
      case MaintenanceRequestStatus.completed:
        return AppLocalizations.of(context)!.completed;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _getCarInfo(request.carId),
      builder: (context, carSnapshot) {
        final carInfo = carSnapshot.data;
        final statusColor = _getStatusColor(request.status);
        
        // Build services list
        final services = <String>[];
        final l10n = AppLocalizations.of(context)!;
        if (request.oilChangePreviousKm != null || request.oilChangeCurrentKm != null) {
          services.add(l10n.oilChange);
        }
        if (request.brakePadsLastChanged != null) services.add(l10n.brakePads);
        if (request.sparkPlugsLastChanged != null) services.add(l10n.sparkPlugs);
        if (request.tyresLastChanged != null) services.add(l10n.tyres);
        if (request.acService) services.add(l10n.ac);
        if (request.lightsService) services.add(l10n.lights);
        if (request.tyreStackingService) services.add(l10n.tyreStacking);

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Theme.of(context).colorScheme.surface,
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  context.go(
                    RouteNames.maintenanceRequestDetail
                        .replaceAll(':id', request.id),
                  );
                },
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row
                      Row(
                        children: [
                          // Status Indicator
                          Container(
                            width: 4,
                            height: 48,
                            decoration: BoxDecoration(
                              color: statusColor,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Main Content
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${AppLocalizations.of(context)!.request} #${request.id.substring(0, 8)}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: -0.5,
                                            ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: statusColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        _getStatusName(context, request.status),
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall
                                            ?.copyWith(
                                              color: statusColor,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 11,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.directions_car,
                                      size: 14,
                                      color: AppColors.onSurfaceVariant,
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        carSnapshot.connectionState ==
                                                ConnectionState.waiting
                                            ? AppLocalizations.of(context)!.loading
                                            : (carInfo != null
                                                ? '${carInfo[DatabaseSchema.model] ?? 'N/A'} • ${carInfo[DatabaseSchema.number] ?? 'N/A'}'
                                                : 'Car ID: ${request.carId.substring(0, 8)}...'),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: AppColors.onSurfaceVariant,
                                              fontSize: 13,
                                            ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.chevron_right,
                            color: AppColors.onSurfaceVariant.withOpacity(0.5),
                            size: 20,
                          ),
                        ],
                      ),
                      // Services Tags
                      if (services.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: services.take(4).map((service) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .surfaceVariant
                                    .withOpacity(0.5),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                service,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                      fontSize: 11,
                                      color: AppColors.onSurfaceVariant,
                                    ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                      // Date Info
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 12,
                            color: AppColors.onSurfaceVariant.withOpacity(0.7),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            date_utils.DateFormatters.formatDate(request.requestedAt),
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: AppColors.onSurfaceVariant.withOpacity(0.7),
                                  fontSize: 11,
                                ),
                          ),
                          if (request.oilChangeCurrentKm != null) ...[
                            const SizedBox(width: 12),
                            Icon(
                              Icons.speed_outlined,
                              size: 12,
                              color: AppColors.onSurfaceVariant.withOpacity(0.7),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${request.oilChangeCurrentKm} km',
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: AppColors.onSurfaceVariant.withOpacity(0.7),
                                    fontSize: 11,
                                  ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Transaction List Item
class _TransactionListItem extends StatelessWidget {
  final AllocationModel allocation;
  final Color color;

  const _TransactionListItem({
    required this.allocation,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final amount = double.tryParse(allocation.vehicleId) ?? 0.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context)
              .colorScheme
              .surfaceVariant
              .withOpacity(0.5),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              context.go('${RouteNames.allocations}/${allocation.id}');
            },
            borderRadius: BorderRadius.circular(12),
            child: Row(
              children: [
                Icon(Icons.assignment, color: color, size: 24),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${AppLocalizations.of(context)!.allocation} #${allocation.id.substring(0, 8)}',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${AppLocalizations.of(context)!.amount}: \$${amount.toStringAsFixed(2)}',
                        style:
                            Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right,
                    color: AppColors.onSurfaceVariant),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


// Expense List Item
class _ExpenseListItem extends StatelessWidget {
  final ExpenseModel expense;

  const _ExpenseListItem({required this.expense});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context)
              .colorScheme
              .surfaceVariant
              .withOpacity(0.5),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              context.go('${RouteNames.expenses}/${expense.id}');
            },
            borderRadius: BorderRadius.circular(12),
            child: Row(
              children: [
                Icon(Icons.receipt, color: AppColors.error, size: 24),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        expense.description,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${AppLocalizations.of(context)!.amount}: \$${expense.amount.toStringAsFixed(2)}',
                        style:
                            Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: AppColors.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
