# Car Service App - Business Model Summary

**Quick Reference Guide for Web Dashboard Integration**

---

## 📋 Table of Contents
1. [User Roles & Permissions](#user-roles--permissions)
2. [Core Entities](#core-entities)
3. [Database Schema Reference](#database-schema-reference)
4. [Business Processes](#business-processes)
5. [Data Relationships](#data-relationships)
6. [Integration Checklist](#integration-checklist)

---

## 👥 User Roles & Permissions

### Role Hierarchy

| Role | DB Value | Access Level | Key Permissions |
|------|----------|--------------|-----------------|
| **Employee** | `employee` | Limited | • Own cars<br>• Submit maintenance requests<br>• Create expenses<br>• View own data only |
| **Cars Admin** | `cars_admin` | Admin | • View/manage ALL cars<br>• Approve/manage maintenance requests<br>• View reports<br>• Approve allocations |
| **Accountant** | `accountant` | Financial Admin | • Manage petty cash allocations<br>• Review all expenses<br>• View financial reports<br>• Manage expenses |
| **Warehouse Keeper** | `warehouse_keeper` | Inventory Admin | • Manage tools & inventory<br>• (Future: parts inventory) |
| **Super Admin** | `super_admin` | Full Access | • All permissions<br>• System administration |

### Permission Checks (from `UserRole` enum)

```dart
bool canManageVehicles      // superAdmin, carsAdmin
bool canApproveAllocations  // superAdmin, carsAdmin
bool canViewReports         // superAdmin, accountant, carsAdmin
bool canManageExpenses      // superAdmin, accountant
bool canViewAllData         // superAdmin only
```

### Web Dashboard Access
**Only these roles can access the web dashboard:**
- `cars_admin`
- `accountant`
- `warehouse_keeper`
- `super_admin`

**Employees are restricted to mobile app only.**

---

## 🗄️ Core Entities

### 1. Profiles (Users)
- **Table**: `profiles`
- **Primary Key**: `id` (matches `auth.users.id`)
- **Key Fields**: `role`, `name`, `email`, `avatar`
- **Relations**: Parent to Cars, Tools, Petty Cash transactions

### 2. Cars (Vehicles)
- **Table**: `cars`
- **Key Fields**: 
  - `id`, `model`, `number`
  - `owner_id` → `profiles.id`
  - `status`, `location` ('Ahsaa', 'Dammam')
  - `image`, `description`, `is_new`
- **RLS Policy**: 
  - Employees see only their cars (`owner_id = auth.uid()`)
  - Admins see all cars

### 3. Maintenance Request
- **Table**: `maintenance_request`
- **Key Fields**:
  - `id`, `car_id` → `cars.id`
  - `status`: `pending` → `in_progress` → `completed`
  - `requested_at`, `in_progress_at`, `completed_at`
  - Service flags: `ac_service`, `lights_service`, `tyre_stacking_service`
  - Oil change: `oil_change_previous_km`, `oil_change_current_km`
  - Last changed dates: `brake_pads_last_changed`, `spark_plugs_last_changed`, `tyres_last_changed`
  - `tyres_positions` (array), `notes`, `invoice_url`
- **Status Flow**: `pending` → `in_progress` → `completed`

### 4. Maintenance History
- **Table**: `maintenance_history`
- **Key Fields**:
  - `id`, `car_id` → `cars.id`
  - `request_id` → `maintenance_request.id` (optional, links to originating request)
  - `maintenance_type` (enum: oilChange, brakePads, sparkPlugs, tyres, etc.)
  - `performed_at`, `performed_by`, `kilometers`, `cost`
  - `next_due_date`, `next_due_kilometers`
  - `service_center_type`
- **Purpose**: Immutable audit log of all maintenance work
- **Critical**: When a request is completed, entries MUST be written here

### 5. Petty Cash Transactions
- **Table**: `petty_cash_transactions` ⚠️ (Note: Not `petty_cash` as in some docs)
- **Key Fields**:
  - `id`, `transaction_type`: `allocation` | `expense`
  - `employee_id` → `profiles.id`
  - `created_by` → `profiles.id`
  - `amount`, `description`, `category`
  - `transaction_date`, `receipt_url`
  - `allocation_id` → `petty_cash_transactions.id` (self-referencing FK)
    - Links an `expense` to the specific `allocation` it used
- **Process**:
  1. **Allocation**: Accountant creates `transaction_type='allocation'` for employee
  2. **Expense**: Employee creates `transaction_type='expense'` with `allocation_id` pointing to allocation
- **Balance Calculation**: 
  ```
  Employee Balance = SUM(allocations) - SUM(expenses)
  ```

### 6. Monthly Checkups
- **Table**: `monthly_checkups`
- **Key Fields**: 
  - `id`, `car_id` → `cars.id`
  - `checkup_date`, `completed_at`
  - 30+ inspection fields (engine, transmission, brakes, tires, etc.)
- **Purpose**: Granular vehicle inspection checklist

### 7. Oil Change Progress
- **Table**: `oil_change_progress`
- **Key Fields**:
  - `car_id` → `cars.id`
  - `current_kilometers`, `last_oil_change_kilometers`, `next_oil_change_kilometers`
  - `last_updated`
- **Purpose**: Tracks oil change intervals per vehicle

### 8. Allocations (Vehicle Allocations)
- **Note**: Currently stored in `petty_cash_transactions` with `transaction_type='allocation'`
- **Future**: May have dedicated `allocations` table
- **Key Fields** (if separate table):
  - `id`, `vehicle_id` → `cars.id`
  - `allocated_to` → `profiles.id`
  - `requested_by`, `approved_by` → `profiles.id`
  - `request_date`, `approval_date`, `handover_date`, `return_date`
  - `handover_mileage`, `return_mileage`
  - `handover_notes`, `return_notes`

---

## 🔗 Data Relationships

### Entity Relationship Diagram

```
PROFILES (Users)
  ├── CARS (owned by employees)
  │     ├── MAINTENANCE_REQUEST (status flow)
  │     │     └── MAINTENANCE_HISTORY (generated on completion)
  │     ├── MAINTENANCE_HISTORY (direct entries)
  │     ├── MONTHLY_CHECKUPS (inspections)
  │     └── OIL_CHANGE_PROGRESS (tracking)
  │
  └── PETTY_CASH_TRANSACTIONS
        ├── Allocations (transaction_type='allocation')
        └── Expenses (transaction_type='expense', allocation_id → allocation.id)
```

### Critical Foreign Keys

1. **User → Cars**: `cars.owner_id = profiles.id`
2. **Cars → Maintenance**: `maintenance_request.car_id = cars.id`
3. **Request → History**: `maintenance_history.request_id = maintenance_request.id`
4. **User → Financials**: `petty_cash_transactions.employee_id = profiles.id`
5. **Expense → Allocation**: `petty_cash_transactions.allocation_id = petty_cash_transactions.id` (self-reference)

---

## 🔄 Business Processes

### 1. Maintenance Request Lifecycle

```
┌─────────────────┐
│ Employee        │
│ Creates Request │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Status: pending │
└────────┬────────┘
         │
         ▼
┌──────────────────────┐
│ Admin Reviews        │
│ Updates to           │
│ in_progress          │
└────────┬─────────────┘
         │
         ▼
┌──────────────────────┐
│ Work Performed       │
│ Status: completed    │
└────────┬─────────────┘
         │
         ▼
┌──────────────────────┐
│ Write to             │
│ maintenance_history  │
│ Update               │
│ oil_change_progress  │
└──────────────────────┘
```

**Implementation Checklist:**
- [ ] Set `status = 'completed'`
- [ ] Set `completed_at = NOW()`
- [ ] Create entries in `maintenance_history` for each service performed
- [ ] Update `oil_change_progress` if oil was changed
- [ ] Update car's current kilometers if provided

### 2. Petty Cash Flow

```
┌─────────────────────┐
│ Accountant          │
│ Creates Allocation  │
│ (type='allocation') │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│ Employee Receives   │
│ Money (Balance +)   │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│ Employee Creates    │
│ Expense             │
│ (type='expense',    │
│  allocation_id=...)│
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│ Balance Updated     │
│ (Allocations -      │
│  Expenses)          │
└─────────────────────┘
```

**Balance Query:**
```sql
SELECT 
  employee_id,
  SUM(CASE WHEN transaction_type = 'allocation' THEN amount ELSE 0 END) as total_allocations,
  SUM(CASE WHEN transaction_type = 'expense' THEN amount ELSE 0 END) as total_expenses,
  SUM(CASE WHEN transaction_type = 'allocation' THEN amount ELSE -amount END) as balance
FROM petty_cash_transactions
WHERE employee_id = ?
GROUP BY employee_id;
```

### 3. Financial Reporting

**Revenue Sources:**
- Petty Cash Allocations (money injected into system)

**Expense Sources:**
- Employee Expenses (from petty cash)
- Maintenance Costs (from `maintenance_history.cost`)

**Report Aggregation:**
```sql
-- Petty Cash Operations
SELECT 
  transaction_type,
  SUM(amount) as total,
  COUNT(*) as count
FROM petty_cash_transactions
WHERE transaction_date BETWEEN ? AND ?
GROUP BY transaction_type;

-- Maintenance Costs
SELECT 
  maintenance_type,
  SUM(cost) as total_cost,
  COUNT(*) as service_count
FROM maintenance_history
WHERE performed_at BETWEEN ? AND ?
GROUP BY maintenance_type;
```

---

## 📊 Database Schema Reference

### Table Names (from `DatabaseSchema`)

```dart
profiles
cars
insurance_intervals
maintenance_history
maintenance_request
monthly_checkups
oil_change_progress
petty_cash_transactions  // ⚠️ Note: actual table name
tools
```

### Common Column Patterns

- `id` (UUID, primary key)
- `created_at` (timestamp)
- `updated_at` (timestamp)
- Foreign keys: `*_id` (e.g., `car_id`, `employee_id`)

### Enum Mappings

**UserRole:**
- `employee` ↔ `UserRole.employee`
- `cars_admin` ↔ `UserRole.carsAdmin`
- `accountant` ↔ `UserRole.accountant`
- `warehouse_keeper` ↔ `UserRole.warehouseKeeper`
- `super_admin` ↔ `UserRole.superAdmin`

**MaintenanceRequestStatus:**
- `pending` ↔ `MaintenanceRequestStatus.pending`
- `in_progress` ↔ `MaintenanceRequestStatus.inProgress`
- `completed` ↔ `MaintenanceRequestStatus.completed`

**TransactionType:**
- `allocation` ↔ `TransactionType.allocation`
- `expense` ↔ `TransactionType.expense`

---

## ✅ Integration Checklist

### Authentication & Authorization
- [ ] Use same Supabase project URL and keys
- [ ] Check `profile.role` immediately after login
- [ ] Restrict web dashboard to admin roles only
- [ ] Implement role-based route guards
- [ ] Handle RLS policies correctly (admins see all, employees see own)

### Data Models
- [ ] Reuse `UserRole` enum (ensure database values match)
- [ ] Reuse `MaintenanceRequestStatus` enum
- [ ] Reuse `TransactionType` enum
- [ ] Ensure model JSON serialization matches database schema
- [ ] Handle nullable fields correctly

### Business Logic
- [ ] Implement maintenance request status flow
- [ ] Create maintenance history entries on completion
- [ ] Update oil change progress when oil changed
- [ ] Calculate petty cash balances correctly
- [ ] Link expenses to allocations via `allocation_id`

### Data Access
- [ ] Use correct table names (`petty_cash_transactions`, not `petty_cash`)
- [ ] Join tables using correct foreign keys
- [ ] Respect RLS policies (test with different user roles)
- [ ] Handle pagination for large datasets
- [ ] Implement proper error handling

### Web-Specific Features
- [ ] Dashboard analytics (aggregate maintenance costs, counts)
- [ ] Bulk operations (status updates, CSV exports)
- [ ] Advanced filtering and search
- [ ] Data visualization (charts, graphs)
- [ ] Export functionality (CSV, PDF reports)

### Testing
- [ ] Test with each user role
- [ ] Verify RLS policies work correctly
- [ ] Test maintenance request lifecycle
- [ ] Test petty cash balance calculations
- [ ] Test foreign key relationships

---

## 🚨 Important Notes

1. **Table Name Discrepancy**: 
   - Documentation mentions `petty_cash` table
   - Actual table is `petty_cash_transactions`
   - Always use `DatabaseSchema.pettyCashTransactions`

2. **Allocations Storage**:
   - Currently stored in `petty_cash_transactions` with `transaction_type='allocation'`
   - May have dedicated table in future
   - Check repository implementation for current approach

3. **Maintenance History**:
   - **CRITICAL**: Must be created when request is completed
   - Links to request via `request_id` (optional but recommended)
   - Immutable log - never update, only insert

4. **RLS Policies**:
   - Employees: Can only see their own cars, requests, expenses
   - Admins: Can see all data
   - Test thoroughly with different roles

5. **Status Transitions**:
   - Maintenance requests: `pending` → `in_progress` → `completed`
   - No backward transitions allowed
   - Always set timestamps (`in_progress_at`, `completed_at`)

---

## 📚 Related Files

- **Models**: `lib/auth/models/user_model.dart`
- **Schema**: `lib/core/config/database_schema.dart`
- **Enums**: Check model files for enum definitions
- **Architecture Doc**: `APP_ARCHITECTURE_AND_BUSINESS_MODEL.md`

---

**Last Updated**: Based on codebase analysis and architecture documentation
**Version**: 1.0


