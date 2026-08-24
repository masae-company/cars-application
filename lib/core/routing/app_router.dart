import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/providers/auth_provider.dart';
import '../../auth/models/user_model.dart';
import '../../auth/screens/login_screen.dart';
import '../../core/constants/route_names.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../reports/screens/reports_dashboard_screen.dart';
import '../../reports/screens/usage_report_screen.dart';
import '../../reports/screens/cost_report_screen.dart';
import '../../reports/screens/vehicle_analysis_report_screen.dart';
import '../../core/screens/dashboard_screen.dart';
import '../../vehicles/screens/vehicle_list_screen.dart';
import '../../vehicles/screens/vehicle_detail_screen.dart';
import '../../vehicles/screens/vehicle_form_screen.dart';
import '../../vehicles/providers/vehicle_provider.dart';
import '../../allocations/screens/allocation_list_screen.dart';
import '../../allocations/screens/allocation_detail_screen.dart';
import '../../allocations/screens/allocation_request_screen.dart';
import '../../expenses/screens/expense_list_screen.dart';
import '../../expenses/screens/expense_detail_screen.dart';
import '../../expenses/screens/expense_form_screen.dart';
import '../../expenses/providers/expense_provider.dart';
import '../../maintenance/screens/maintenance_request_list_screen.dart';
import '../../maintenance/screens/maintenance_request_detail_screen.dart';
import '../../maintenance/screens/maintenance_request_form_screen.dart';
import '../../maintenance/providers/maintenance_request_provider.dart';
import '../../maintenance/screens/maintenance_history_list_screen.dart';
import '../../maintenance/screens/monthly_checkup_list_screen.dart';
import '../../maintenance/screens/monthly_checkup_form_screen.dart';
import '../../maintenance/providers/monthly_checkup_provider.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: RouteNames.login,
    redirect: (context, state) {
      // Wait for auth state to finish loading before redirecting
      if (authState.isLoading) {
        return null; // Don't redirect while loading
      }

      final isLoggedIn = authState.value != null;
      final isLoginRoute = state.uri.path == RouteNames.login;

      if (!isLoggedIn && !isLoginRoute) {
        return RouteNames.login;
      }
      if (isLoggedIn && isLoginRoute) {
        return RouteNames.dashboard;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: RouteNames.login,
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.dashboard,
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: const AppScaffold(
            showAppBar: false,
            body: DashboardScreen(),
          ),
        ),
      ),
      GoRoute(
        path: RouteNames.allocations,
        pageBuilder: (context, state) {
          final userRole = ref.read(authProvider).value?.role ?? UserRole.employee;
          if (!userRole.canViewAllocations) {
            return NoTransitionPage<void>(
              key: state.pageKey,
              child: const AppScaffold(
                showAppBar: false,
                title: 'Access Denied',
                body: Center(child: Text('You do not have permission to access this page')),
              ),
            );
          }
          return NoTransitionPage<void>(
            key: state.pageKey,
            child: const AppScaffold(
              showAppBar: false,
              title: 'Allocations',
              body: AllocationListScreen(),
            ),
          );
        },
        routes: [
          GoRoute(
            path: ':id',
            pageBuilder: (context, state) {
              final id = state.pathParameters['id']!;
              return NoTransitionPage<void>(
                key: state.pageKey,
                child: AppScaffold(
                  showAppBar: false,
                  title: 'Allocation Details',
                  body: AllocationDetailScreen(allocationId: id),
                ),
              );
            },
          ),
          GoRoute(
            path: 'request',
            pageBuilder: (context, state) => NoTransitionPage<void>(
              key: state.pageKey,
              child: const AppScaffold(
                showAppBar: false,
                title: 'Give Allocation',
                body: AllocationRequestScreen(),
              ),
            ),
          ),
        ],
      ),
      GoRoute(
        path: RouteNames.expenses,
        pageBuilder: (context, state) {
          final userRole = ref.read(authProvider).value?.role ?? UserRole.employee;
          if (!userRole.canManageExpenses) {
            return NoTransitionPage<void>(
              key: state.pageKey,
              child: const AppScaffold(
                showAppBar: false,
                title: 'Access Denied',
                body: Center(child: Text('You do not have permission to access this page')),
              ),
            );
          }
          return NoTransitionPage<void>(
            key: state.pageKey,
            child: const AppScaffold(
              showAppBar: false,
              title: 'Expenses',
              body: ExpenseListScreen(),
            ),
          );
        },
        routes: [
          GoRoute(
            path: ':id',
            pageBuilder: (context, state) {
              final id = state.pathParameters['id']!;
              return NoTransitionPage<void>(
                key: state.pageKey,
                child: AppScaffold(
                  showAppBar: false,
                  title: 'Expense Details',
                  body: ExpenseDetailScreen(expenseId: id),
                ),
              );
            },
            routes: [
              GoRoute(
                path: 'edit',
                pageBuilder: (context, state) {
                  final id = state.pathParameters['id']!;
                  // Load expense using provider and pass to form
                  return NoTransitionPage<void>(
                    key: state.pageKey,
                    child: AppScaffold(
                      showAppBar: false,
                      title: 'Edit Expense',
                      body: Consumer(
                        builder: (context, ref, child) {
                          final expenseAsync = ref.watch(expenseProvider(id));
                          return expenseAsync.when(
                            data: (expense) => ExpenseFormScreen(expense: expense),
                            loading: () => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            error: (error, stack) => Center(
                              child: Text('Error loading expense: $error'),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          GoRoute(
            path: 'create',
            pageBuilder: (context, state) => NoTransitionPage<void>(
              key: state.pageKey,
              child: const AppScaffold(
                showAppBar: false,
                title: 'Add Expense',
                body: ExpenseFormScreen(),
              ),
            ),
          ),
        ],
      ),
      GoRoute(
        path: RouteNames.reports,
        pageBuilder: (context, state) {
          final userRole = ref.read(authProvider).value?.role ?? UserRole.employee;
          if (!userRole.canViewReports) {
            return NoTransitionPage<void>(
              key: state.pageKey,
              child: const AppScaffold(
                showAppBar: false,
                title: 'Access Denied',
                body: Center(child: Text('You do not have permission to access this page')),
              ),
            );
          }
          return NoTransitionPage<void>(
            key: state.pageKey,
            child: const AppScaffold(
              showAppBar: false,
              title: 'Reports',
              body: ReportsDashboardScreen(),
            ),
          );
        },
        routes: [
          GoRoute(
            path: 'usage',
            pageBuilder: (context, state) {
              final userRole = ref.read(authProvider).value?.role ?? UserRole.employee;
              if (userRole != UserRole.superAdmin && userRole != UserRole.accountant) {
                return NoTransitionPage<void>(
                  key: state.pageKey,
                  child: const AppScaffold(
                    showAppBar: false,
                    title: 'Access Denied',
                    body: Center(child: Text('Access Denied')),
                  ),
                );
              }
              return NoTransitionPage<void>(
                key: state.pageKey,
                child: const AppScaffold(
                  showAppBar: false,
                  title: 'Usage Report',
                  body: UsageReportScreen(),
                ),
              );
            },
          ),
          GoRoute(
            path: 'cost',
            pageBuilder: (context, state) {
              final userRole = ref.read(authProvider).value?.role ?? UserRole.employee;
              if (userRole != UserRole.superAdmin && userRole != UserRole.accountant) {
                return NoTransitionPage<void>(
                  key: state.pageKey,
                  child: const AppScaffold(
                    showAppBar: false,
                    title: 'Access Denied',
                    body: Center(child: Text('Access Denied')),
                  ),
                );
              }
              return NoTransitionPage<void>(
                key: state.pageKey,
                child: const AppScaffold(
                  showAppBar: false,
                  title: 'Cost Report',
                  body: CostReportScreen(),
                ),
              );
            },
          ),
          GoRoute(
            path: 'vehicle-analysis',
            pageBuilder: (context, state) {
              final userRole = ref.read(authProvider).value?.role ?? UserRole.employee;
              if (userRole != UserRole.superAdmin && userRole != UserRole.carsAdmin) {
                return NoTransitionPage<void>(
                  key: state.pageKey,
                  child: const AppScaffold(
                    showAppBar: false,
                    title: 'Access Denied',
                    body: Center(child: Text('Access Denied')),
                  ),
                );
              }
              return NoTransitionPage<void>(
                key: state.pageKey,
                child: const AppScaffold(
                  showAppBar: false,
                  title: 'Vehicle Analysis',
                  body: VehicleAnalysisReportScreen(),
                ),
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: RouteNames.maintenanceRequests,
        pageBuilder: (context, state) {
          final userRole = ref.read(authProvider).value?.role ?? UserRole.employee;
          if (!userRole.canManageMaintenanceRequests) {
            return NoTransitionPage<void>(
              key: state.pageKey,
              child: const AppScaffold(
                showAppBar: false,
                title: 'Access Denied',
                body: Center(child: Text('You do not have permission to access this page')),
              ),
            );
          }
          return NoTransitionPage<void>(
            key: state.pageKey,
            child: const AppScaffold(
              showAppBar: false,
              title: 'Maintenance Requests',
              body: MaintenanceRequestListScreen(),
            ),
          );
        },
        routes: [
          // Create route must come before :id route to avoid matching "create" as an ID
          GoRoute(
            path: 'create',
            pageBuilder: (context, state) => NoTransitionPage<void>(
              key: state.pageKey,
              child: const AppScaffold(
                showAppBar: false,
                title: 'Create Maintenance Request',
                body: MaintenanceRequestFormScreen(),
              ),
            ),
          ),
          GoRoute(
            path: ':id',
            pageBuilder: (context, state) {
              final id = state.pathParameters['id']!;
              return NoTransitionPage<void>(
                key: state.pageKey,
                child: AppScaffold(
                  showAppBar: false,
                  title: 'Maintenance Request Details',
                  body: MaintenanceRequestDetailScreen(requestId: id),
                ),
              );
            },
            routes: [
              GoRoute(
                path: 'edit',
                pageBuilder: (context, state) {
                  final id = state.pathParameters['id']!;
                  // Load maintenance request using provider and pass to form
                  return NoTransitionPage<void>(
                    key: state.pageKey,
                    child: AppScaffold(
                      showAppBar: false,
                      title: 'Edit Maintenance Request',
                      body: Consumer(
                        builder: (context, ref, child) {
                          final requestAsync = ref.watch(maintenanceRequestProvider(id));
                          return requestAsync.when(
                            data: (request) => MaintenanceRequestFormScreen(request: request),
                            loading: () => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            error: (error, stack) => Center(
                              child: Text('Error loading request: $error'),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: RouteNames.maintenanceHistory,
        pageBuilder: (context, state) {
          final userRole = ref.read(authProvider).value?.role ?? UserRole.employee;
          if (!userRole.canManageMaintenanceRequests) {
            return NoTransitionPage<void>(
              key: state.pageKey,
              child: const AppScaffold(
                showAppBar: false,
                title: 'Access Denied',
                body: Center(child: Text('You do not have permission to access this page')),
              ),
            );
          }
          return NoTransitionPage<void>(
            key: state.pageKey,
            child: const AppScaffold(
              showAppBar: false,
              title: 'Maintenance History',
              body: MaintenanceHistoryListScreen(),
            ),
          );
        },
      ),
      GoRoute(
        path: RouteNames.monthlyCheckups,
        pageBuilder: (context, state) {
          final userRole = ref.read(authProvider).value?.role ?? UserRole.employee;
          if (!userRole.canManageMaintenanceRequests) {
            return NoTransitionPage<void>(
              key: state.pageKey,
              child: const AppScaffold(
                showAppBar: false,
                title: 'Access Denied',
                body: Center(child: Text('You do not have permission to access this page')),
              ),
            );
          }
          return NoTransitionPage<void>(
            key: state.pageKey,
            child: const AppScaffold(
              showAppBar: false,
              title: 'Monthly Checkups',
              body: MonthlyCheckupListScreen(),
            ),
          );
        },
        routes: [
          // Create route must come before :id route
          GoRoute(
            path: 'create',
            pageBuilder: (context, state) => NoTransitionPage<void>(
              key: state.pageKey,
              child: const AppScaffold(
                showAppBar: false,
                title: 'Create Monthly Checkup',
                body: MonthlyCheckupFormScreen(),
              ),
            ),
          ),
          GoRoute(
            path: ':id/edit',
            pageBuilder: (context, state) {
              final id = state.pathParameters['id']!;
              return NoTransitionPage<void>(
                key: state.pageKey,
                child: AppScaffold(
                  showAppBar: false,
                  title: 'Edit Monthly Checkup',
                  body: Consumer(
                    builder: (context, ref, child) {
                      final checkupAsync = ref.watch(monthlyCheckupProvider(id));
                      return checkupAsync.when(
                        data: (checkup) => MonthlyCheckupFormScreen(checkup: checkup),
                        loading: () => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        error: (error, stack) => Center(
                          child: Text('Error loading checkup: $error'),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: RouteNames.vehicles,
        pageBuilder: (context, state) {
          final userRole = ref.read(authProvider).value?.role ?? UserRole.employee;
          if (!userRole.canManageVehicles) {
            return NoTransitionPage<void>(
              key: state.pageKey,
              child: const AppScaffold(
                showAppBar: false,
                title: 'Access Denied',
                body: Center(child: Text('You do not have permission to access this page')),
              ),
            );
          }
          return NoTransitionPage<void>(
            key: state.pageKey,
            child: const AppScaffold(
              showAppBar: false,
              title: 'Vehicles',
              body: VehicleListScreen(),
            ),
          );
        },
        routes: [
          // Create route must come before :id route to avoid matching "create" as an ID
          GoRoute(
            path: 'create',
            pageBuilder: (context, state) => NoTransitionPage<void>(
              key: state.pageKey,
              child: const AppScaffold(
                showAppBar: false,
                title: 'Add Vehicle',
                body: VehicleFormScreen(),
              ),
            ),
          ),
          GoRoute(
            path: ':id',
            pageBuilder: (context, state) {
              final id = state.pathParameters['id']!;
              return NoTransitionPage<void>(
                key: state.pageKey,
                child: AppScaffold(
                  showAppBar: false,
                  title: 'Vehicle Details',
                  body: VehicleDetailScreen(vehicleId: id),
                ),
              );
            },
            routes: [
              GoRoute(
                path: 'edit',
                pageBuilder: (context, state) {
                  final id = state.pathParameters['id']!;
                  // Load vehicle using provider and pass to form
                  return NoTransitionPage<void>(
                    key: state.pageKey,
                    child: AppScaffold(
                      showAppBar: false,
                      title: 'Edit Vehicle',
                      body: Consumer(
                        builder: (context, ref, child) {
                          final vehicleAsync = ref.watch(vehicleProvider(id));
                          return vehicleAsync.when(
                            data: (vehicle) => VehicleFormScreen(vehicle: vehicle),
                            loading: () => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            error: (error, stack) => Center(
                              child: Text('Error loading vehicle: $error'),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

