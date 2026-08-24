# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **Flutter Web** admin dashboard for managing a car service fleet. It connects to an existing Supabase backend that is shared with a mobile app. The web dashboard is for admin roles only (cars_admin, accountant, warehouse_keeper, super_admin).

**Key Constraint:** This app works with an **existing database schema** and must match the existing mobile app's data models and table structure. Do not modify database schema without considering mobile app compatibility.

## Development Commands

### Setup
```bash
# Install dependencies
flutter pub get

# Generate code (Freezed models, JSON serialization)
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode for continuous code generation during development
flutter pub run build_runner watch --delete-conflicting-outputs
```

### Running
```bash
# Run in Chrome (default - credentials are in main.dart)
flutter run -d chrome

# Run with custom Supabase credentials
flutter run -d chrome --dart-define=SUPABASE_URL=your_url --dart-define=SUPABASE_ANON_KEY=your_key
```

### Code Generation
**IMPORTANT:** After modifying any `@freezed` models or adding `@JsonSerializable` classes, you MUST run:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Architecture

### Clean Architecture Pattern
The app follows Clean Architecture with feature-based organization:

```
lib/
├── core/              # Shared infrastructure
│   ├── config/        # Database schema constants, Supabase config
│   ├── routing/       # GoRouter setup with role-based guards
│   ├── theme/         # Material 3 theming
│   ├── widgets/       # Shared UI components (AppScaffold, etc.)
│   └── providers/     # App-level providers (locale, etc.)
├── auth/              # Authentication module
├── vehicles/          # Vehicle management
├── allocations/       # Vehicle allocation workflow
├── expenses/          # Expense tracking
├── maintenance/       # Maintenance requests, history, monthly checkups
├── reports/           # Analytics and reporting
└── shared/            # Shared widgets/utilities
```

### Feature Module Structure
Each feature module follows this pattern:
```
feature/
├── models/            # Freezed data models with JSON serialization
├── repositories/      # Data layer - Supabase queries
├── providers/         # Riverpod state management
├── screens/           # Full-page UI components
└── widgets/           # Feature-specific reusable widgets
```

### Key Architectural Patterns

1. **State Management:** Riverpod (FutureProvider, StreamProvider, StateProvider)
   - Providers are in `providers/` directories
   - Most data fetching uses `FutureProvider` or `FutureProvider.family` for parameterized queries

2. **Data Models:** Freezed with JSON serialization
   - All models use `@freezed` annotation
   - Generated files: `*.freezed.dart` and `*.g.dart`
   - Manual `fromJson`/`toJson` for enums that need DB value conversion

3. **Navigation:** GoRouter with role-based guards
   - Routes defined in `lib/core/routing/app_router.dart`
   - Auth redirect logic checks `authProvider` state
   - Permission checks use `UserRole` extension methods

4. **Database Access:** Direct Supabase client calls in repositories
   - Use `DatabaseSchema` constants for all table/column names
   - Never hardcode table or column names
   - Repositories handle all `toJson()`/`fromJson()` conversions

## Database Schema

### Critical Constants
**ALWAYS use `DatabaseSchema` constants** from `lib/core/config/database_schema.dart`:
```dart
DatabaseSchema.cars              // Table name: 'cars'
DatabaseSchema.allocations       // Table name: 'allocations'
DatabaseSchema.maintenanceRequest // Table name: 'maintenance_request'
DatabaseSchema.pettyCashTransactions // Table name: 'petty_cash_transactions'
```

### Important Tables
- `profiles` - Users with roles (matches auth.users.id)
- `cars` - Vehicles (owner_id → profiles.id)
- `allocations` - Vehicle allocation workflow
- `allocation_history` - Allocation status changes
- `maintenance_request` - Service requests (status: pending → in_progress → completed)
- `maintenance_history` - Immutable maintenance log
- `monthly_checkups` - 30+ field inspection checklist
- `petty_cash_transactions` - Financial transactions (type: allocation | expense)
- `expenses` - Expense tracking with receipts

### Row Level Security (RLS)
- Employees: Can only see their own data (`owner_id = auth.uid()`)
- Admins (cars_admin, accountant, etc.): Can see all data
- Web dashboard users must have admin roles

## User Roles & Permissions

### Role Enum
`UserRole` enum has DB-to-code mapping:
- `employee` ↔ `UserRole.employee`
- `cars_admin` ↔ `UserRole.carsAdmin`
- `accountant` ↔ `UserRole.accountant`
- `warehouse_keeper` ↔ `UserRole.warehouseKeeper`
- `super_admin` ↔ `UserRole.superAdmin`

### Permission Methods (on UserRole)
```dart
userRole.canManageVehicles         // superAdmin, carsAdmin
userRole.canApproveAllocations     // superAdmin, carsAdmin
userRole.canManageMaintenanceRequests // superAdmin, carsAdmin
userRole.canViewReports           // superAdmin, accountant, carsAdmin
userRole.canManageExpenses        // superAdmin, accountant
userRole.canViewAllocations       // superAdmin, accountant
userRole.canViewAllData           // superAdmin only
```

**Route Guards:** Check permissions in `app_router.dart` before rendering pages.

## Key Workflows

### 1. Maintenance Request Lifecycle
```
pending → in_progress → completed
```
When completing a maintenance request:
1. Set `status = 'completed'`
2. Set `completed_at = NOW()`
3. **CRITICAL:** Create entries in `maintenance_history` table
4. Update `oil_change_progress` if oil was changed

### 2. Allocation Workflow
```
pending → approved → handed_over → returned
```
- Request: User requests vehicle allocation
- Approve: Admin approves (sets `approved_by`, `approval_date`)
- Handover: Record mileage, notes, `handover_date`
- Return: Record return mileage, notes, `return_date`
- History tracking in `allocation_history` table

### 3. Petty Cash/Expenses
Two separate systems:
- **Petty Cash:** `petty_cash_transactions` table (allocations to employees, employee expenses)
- **Expenses:** `expenses` table (general expense tracking with receipts)

## Code Generation & Freezed

### When to Regenerate
Run build_runner after:
- Adding/modifying `@freezed` classes
- Adding/modifying `@JsonSerializable` classes
- Adding new fields to models
- Changing model structure

### Common Issues
- **Missing `.freezed.dart` or `.g.dart` files:** Run build_runner
- **JSON parsing errors:** Check that DB column names match `fromJson`/`toJson` keys
- **Enum serialization issues:** Ensure custom `fromString()` and `toDbValue()` methods

## Localization

- Uses `flutter_localizations` with ARB files
- Files: `lib/l10n/app_en.arb`, `lib/l10n/app_ar.arb`
- Generate translations: `flutter gen-l10n` (auto-run by `flutter run`)
- Access via `AppLocalizations.of(context)!.translationKey`

## Important Implementation Notes

### DO
- Use `DatabaseSchema` constants for all table/column references
- Run build_runner after model changes
- Check user permissions before rendering sensitive UI
- Handle nullable fields properly (many DB fields are optional)
- Use Freezed `copyWith()` for model updates
- Add proper error handling in repositories
- Use `AppScaffold` for consistent page layout

### DON'T
- Hardcode table or column names
- Modify database schema without coordinating with mobile app
- Skip code generation after model changes
- Bypass role-based permission checks
- Create new tables without updating `DatabaseSchema`
- Use `auth.uid()` directly - use current user's profile.id
- Make breaking changes to existing model JSON structure

## Testing & Debugging

### Debugging Supabase Queries
- Check browser DevTools → Network tab for API calls
- Review Supabase dashboard → Table Editor for data verification
- Use Supabase dashboard → SQL Editor for query testing

### Common Issues
1. **Auth errors:** Verify Supabase URL/key in `main.dart`
2. **RLS policy blocks:** Check user role in Supabase dashboard
3. **JSON parsing errors:** Column name mismatch or null handling
4. **Route access denied:** Missing permission check in router
5. **Build runner errors:** Delete `.dart_tool` and re-run

## Related Documentation

- [README.md](README.md) - Project setup and overview
- [APP_ARCHITECTURE_AND_BUSINESS_MODEL.md](APP_ARCHITECTURE_AND_BUSINESS_MODEL.md) - Detailed business logic
- [BUSINESS_MODEL_SUMMARY.md](BUSINESS_MODEL_SUMMARY.md) - Quick reference for data models
- [EXCEL_IMPORT_SUMMARY.md](EXCEL_IMPORT_SUMMARY.md) - Excel import feature implementation
