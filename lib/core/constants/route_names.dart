class RouteNames {
  // Auth
  static const String login = '/login';

  // Dashboard
  static const String dashboard = '/';
  static const String home = '/home';

  // Vehicles
  static const String vehicles = '/vehicles';
  static const String vehicleDetail = '/vehicles/:id';
  static const String vehicleCreate = '/vehicles/create';
  static const String vehicleEdit = '/vehicles/:id/edit';

  // Allocations
  static const String allocations = '/allocations';
  static const String allocationDetail = '/allocations/:id';
  static const String allocationRequest = '/allocations/request';
  static const String admin = '/admin';

  // Expenses
  static const String expenses = '/expenses';
  static const String expenseDetail = '/expenses/:id';
  static const String expenseCreate = '/expenses/create';
  static const String expenseEdit = '/expenses/:id/edit';

  // Maintenance Requests
  static const String maintenanceRequests = '/maintenance';
  static const String maintenanceRequestDetail = '/maintenance/:id';
  
  // Maintenance History
  static const String maintenanceHistory = '/maintenance-history';
  
  // Monthly Checkups
  static const String monthlyCheckups = '/monthly-checkups';
  static const String monthlyCheckupCreate = '/monthly-checkups/create';
  static const String monthlyCheckupEdit = '/monthly-checkups/:id/edit';

  // Reports
  static const String reports = '/reports';
  static const String usageReport = '/reports/usage';
  static const String costReport = '/reports/cost';
  static const String vehicleAnalysisReport = '/reports/vehicle-analysis';
}

