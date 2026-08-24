import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../auth/providers/auth_provider.dart';
import '../../auth/models/user_model.dart';
import '../../core/constants/route_names.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/language_switcher.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Sidebar extends ConsumerWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentRoute = GoRouterState.of(context).uri.path;
    final userRole = ref.watch(authProvider).value?.role ?? UserRole.employee;
    final user = ref.watch(authProvider).value;

    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          right: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.primary.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.directions_car,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.carServiceTitle,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                          ),
                          Text(
                            AppLocalizations.of(context)!.adminPanel,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 12,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (user != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.white.withOpacity(0.3),
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.name ?? user.email.split('@')[0],
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _getUserRoleName(context, user.role),
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 11,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Quick Actions Section Removed

          const Divider(height: 1),

          // Navigation Menu
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _SidebarMenuItem(
                  icon: Icons.dashboard_outlined,
                  selectedIcon: Icons.dashboard,
                  label: AppLocalizations.of(context)!.dashboard,
                  isSelected: currentRoute == RouteNames.dashboard || currentRoute == RouteNames.home,
                  onTap: () => context.go(RouteNames.dashboard),
                ),
                const SizedBox(height: 4),
                if (userRole.canManageVehicles)
                  _SidebarMenuItem(
                    icon: Icons.directions_car_outlined,
                    selectedIcon: Icons.directions_car,
                    label: AppLocalizations.of(context)!.vehicles,
                    isSelected: currentRoute.startsWith('/vehicles'),
                    onTap: () => context.go(RouteNames.vehicles),
                  ),
                if (userRole.canManageMaintenanceRequests) ...[
                  const SizedBox(height: 4),
                  _SidebarMenuItem(
                    icon: Icons.build_outlined,
                    selectedIcon: Icons.build,
                    label: AppLocalizations.of(context)!.maintenanceRequests,
                    isSelected: currentRoute == RouteNames.maintenanceRequests,
                    onTap: () => context.go(RouteNames.maintenanceRequests),
                  ),
                  const SizedBox(height: 4),
                  _SidebarMenuItem(
                    icon: Icons.history_outlined,
                    selectedIcon: Icons.history,
                    label: AppLocalizations.of(context)!.maintenanceHistory,
                    isSelected: currentRoute == RouteNames.maintenanceHistory,
                    onTap: () => context.go(RouteNames.maintenanceHistory),
                  ),
                  const SizedBox(height: 4),
                  _SidebarMenuItem(
                    icon: Icons.checklist_outlined,
                    selectedIcon: Icons.checklist,
                    label: AppLocalizations.of(context)!.monthlyCheckups,
                    isSelected: currentRoute == RouteNames.monthlyCheckups,
                    onTap: () => context.go(RouteNames.monthlyCheckups),
                  ),
                ],
                if (userRole.canViewAllocations) ...[
                  const SizedBox(height: 4),
                  _SidebarMenuItem(
                    icon: Icons.assignment_outlined,
                    selectedIcon: Icons.assignment,
                    label: AppLocalizations.of(context)!.allocations,
                    isSelected: currentRoute.startsWith('/allocations'),
                    onTap: () => context.go(RouteNames.allocations),
                  ),
                ],
                if (userRole.canManageExpenses) ...[
                  const SizedBox(height: 4),
                  _SidebarMenuItem(
                    icon: Icons.receipt_outlined,
                    selectedIcon: Icons.receipt,
                    label: AppLocalizations.of(context)!.expenses,
                    isSelected: currentRoute.startsWith('/expenses'),
                    onTap: () => context.go(RouteNames.expenses),
                  ),
                ],
                if (userRole.canViewReports) ...[
                  const SizedBox(height: 4),
                  _SidebarMenuItem(
                    icon: Icons.analytics_outlined,
                    selectedIcon: Icons.analytics,
                    label: AppLocalizations.of(context)!.reports,
                    isSelected: currentRoute.startsWith('/reports'),
                    onTap: () => context.go(RouteNames.reports),
                  ),
                ],
                if (userRole == UserRole.superAdmin) ...[
                  const SizedBox(height: 4),
                  _SidebarMenuItem(
                    icon: Icons.admin_panel_settings_outlined,
                    selectedIcon: Icons.admin_panel_settings,
                    label: AppLocalizations.of(context)!.systemAdmin,
                    isSelected: currentRoute.startsWith('/admin'),
                    onTap: () {
                      // Future: Add system admin panel
                    },
                  ),
                ],
              ],
            ),
          ),

          // Language Switcher
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.language,
                  size: 20,
                  color: AppColors.onSurfaceVariant,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.language,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 14,
                        ),
                  ),
                ),
                const LanguageSwitcher(),
              ],
            ),
          ),

          // Logout Button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
                  width: 1,
                ),
              ),
            ),
            child: _SidebarMenuItem(
              icon: Icons.logout_outlined,
              selectedIcon: Icons.logout,
              label: AppLocalizations.of(context)!.logout,
              isSelected: false,
              onTap: () async {
                await ref.read(authProvider.notifier).signOut();
                if (context.mounted) {
                  context.go(RouteNames.login);
                }
              },
              isDestructive: true,
            ),
          ),
        ],
      ),
    );
  }
  String _getUserRoleName(BuildContext context, UserRole role) {
    switch (role) {
      case UserRole.superAdmin:
        return AppLocalizations.of(context)!.superAdminRole;
      case UserRole.carsAdmin:
        return AppLocalizations.of(context)!.carsAdmin;
      case UserRole.accountant:
        return AppLocalizations.of(context)!.accountantRole;
      case UserRole.warehouseKeeper:
        return AppLocalizations.of(context)!.warehouseKeeperRole;
      case UserRole.employee:
        return 'Employee'; // Fallback or add to ARB if strictly needed
    }
  }
}

// Sidebar Menu Item Widget
class _SidebarMenuItem extends StatelessWidget {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDestructive;

  const _SidebarMenuItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive
        ? AppColors.error
        : (isSelected
            ? Theme.of(context).colorScheme.primary
            : AppColors.onSurfaceVariant);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: isSelected
            ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                Icon(
                  isSelected ? selectedIcon : icon,
                  size: 22,
                  color: color,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: color,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          fontSize: 14,
                        ),
                  ),
                ),
                if (isSelected)
                  Container(
                    width: 4,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


