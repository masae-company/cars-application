/// Database schema reference
/// This file documents the actual database structure from Supabase.
/// All table and column names match the actual schema.

class DatabaseSchema {
  // Table names
  static const String profiles = 'profiles';
  static const String cars = 'cars';
  static const String insuranceIntervals = 'insurance_intervals';
  static const String maintenanceHistory = 'maintenance_history';
  static const String maintenanceRequest = 'maintenance_request';
  static const String monthlyCheckups = 'monthly_checkups';
  static const String oilChangeProgress = 'oil_change_progress';
  static const String pettyCashTransactions = 'petty_cash_transactions';
  static const String tools = 'tools';

  // Common column names
  static const String id = 'id';
  static const String createdAt = 'created_at';
  static const String updatedAt = 'updated_at';

  // Profiles columns
  static const String email = 'email';
  static const String name = 'name';
  static const String avatar = 'avatar';
  static const String role = 'role';

  // Cars columns
  static const String model = 'model';
  static const String number = 'number';
  static const String ownerId = 'owner_id';
  static const String image = 'image';
  static const String description = 'description';
  static const String location = 'location';
  static const String isNew = 'is_new';
  static const String isAccident = 'is_accident';

  // Insurance Intervals columns
  static const String carId = 'car_id';
  static const String intervalKilometers = 'interval_kilometers';
  static const String intervalYears = 'interval_years';
  static const String startDate = 'start_date';
  static const String initialKilometers = 'initial_kilometers';

  // Maintenance History columns
  static const String maintenanceType = 'maintenance_type';
  static const String performedAt = 'performed_at';
  static const String performedBy = 'performed_by';
  static const String kilometers = 'kilometers';
  static const String cost = 'cost';
  static const String nextDueDate = 'next_due_date';
  static const String nextDueKilometers = 'next_due_kilometers';
  static const String requestId = 'request_id';
  static const String serviceCenterType = 'service_center_type';

  // Maintenance Request columns
  static const String requestedAt = 'requested_at';
  static const String completedAt = 'completed_at';
  static const String notes = 'notes';
  static const String oilChangePreviousKm = 'oil_change_previous_km';
  static const String oilChangeCurrentKm = 'oil_change_current_km';
  static const String brakePadsLastChanged = 'brake_pads_last_changed';
  static const String sparkPlugsLastChanged = 'spark_plugs_last_changed';
  static const String tyresLastChanged = 'tyres_last_changed';
  static const String acService = 'ac_service';
  static const String lightsService = 'lights_service';
  static const String tyreStackingService = 'tyre_stacking_service';
  static const String tyresPositions = 'tyres_positions';
  static const String status = 'status';
  static const String inProgressAt = 'in_progress_at';
  static const String invoiceUrl = 'invoice_url';

  // Monthly Checkups columns
  static const String checkupDate = 'checkup_date';
  static const String completedAtCheckup = 'completed_at';
  static const String engineOilReplaced = 'engine_oil_replaced';
  static const String engineAirFilterInspected = 'engine_air_filter_inspected';
  static const String engineAirFilterReplaced = 'engine_air_filter_replaced';
  static const String acAirFilterInspected = 'ac_air_filter_inspected';
  static const String automaticTransmissionFluidInspected = 'automatic_transmission_fluid_inspected';
  static const String manualTransmissionFluidInspected = 'manual_transmission_fluid_inspected';
  static const String differentialFluidInspected = 'differential_fluid_inspected';
  static const String sparkPlugsInspected = 'spark_plugs_inspected';
  static const String coolantLevelInspected = 'coolant_level_inspected';
  static const String coolantConditionInspected = 'coolant_condition_inspected';
  static const String brakeClutchFluidInspected = 'brake_clutch_fluid_inspected';
  static const String fluidLeaksInspected = 'fluid_leaks_inspected';
  static const String radiatorHosesInspected = 'radiator_hoses_inspected';
  static const String driveShaftsBootsInspected = 'drive_shafts_boots_inspected';
  static const String fuelFilterInspected = 'fuel_filter_inspected';
  static const String suspensionInspected = 'suspension_inspected';
  static const String shockAbsorberInspected = 'shock_absorber_inspected';
  static const String suspensionRetightened = 'suspension_retightened';
  static const String engineSupportInspected = 'engine_support_inspected';
  static const String driveBeltPulleysInspected = 'drive_belt_pulleys_inspected';
  static const String brakeLinesInspected = 'brake_lines_inspected';
  static const String brakePadsInspected = 'brake_pads_inspected';
  static const String parkBrakeInspected = 'park_brake_inspected';
  static const String tiresInspected = 'tires_inspected';
  static const String exhaustSystemInspected = 'exhaust_system_inspected';
  static const String tiresRotated = 'tires_rotated';
  static const String lightsInspected = 'lights_inspected';
  static const String batteryInspected = 'battery_inspected';
  static const String acOperationInspected = 'ac_operation_inspected';
  static const String wipersInspected = 'wipers_inspected';
  static const String diagnosticToolsUsed = 'diagnostic_tools_used';
  static const String oilServiceReset = 'oil_service_reset';

  // Oil Change Progress columns
  static const String currentKilometers = 'current_kilometers';
  static const String lastOilChangeKilometers = 'last_oil_change_kilometers';
  static const String nextOilChangeKilometers = 'next_oil_change_kilometers';
  static const String lastUpdated = 'last_updated';

  // Petty Cash Transactions columns
  static const String transactionType = 'transaction_type';
  static const String amount = 'amount';
  static const String employeeId = 'employee_id';
  static const String createdBy = 'created_by';
  static const String receiptUrl = 'receipt_url';
  static const String category = 'category';
  static const String transactionDate = 'transaction_date';
  static const String allocationId = 'allocation_id';

  // Tools columns
  static const String toolName = 'name';
  static const String toolOwnerId = 'owner_id';
  static const String toolImage = 'image';
  static const String toolDescription = 'description';
  static const String toolCategory = 'category';

  // Allocations columns (NOTE: These tables don't exist in the current schema)
  // You need to create 'allocations' and 'allocation_history' tables in your database
  static const String allocations = 'allocations';
  static const String allocationHistory = 'allocation_history';
  static const String vehicleId = 'vehicle_id';
  static const String allocatedTo = 'allocated_to';
  static const String requestedBy = 'requested_by';
  static const String approvedBy = 'approved_by';
  static const String requestDate = 'request_date';
  static const String approvalDate = 'approval_date';
  static const String handoverDate = 'handover_date';
  static const String returnDate = 'return_date';
  static const String expectedReturnDate = 'expected_return_date';
  static const String handoverMileage = 'handover_mileage';
  static const String returnMileage = 'return_mileage';
  static const String handoverNotes = 'handover_notes';
  static const String returnNotes = 'return_notes';
  static const String changedBy = 'changed_by';
}

