# Car Service Admin Panel

A Flutter Web dashboard application for managing vehicles, allocations, and expenses.

## Features

- **Vehicle Management**: CRUD operations for vehicles with status tracking
- **Allocation Management**: Request, approve, handover, and return workflows
- **Expense Tracking**: Track expenses linked to vehicles or allocations with receipt upload
- **Reports**: Usage and cost reports with charts and analytics
- **Authentication**: Supabase Auth integration with role-based access control

## Architecture

The application follows Clean Architecture principles with feature-based organization:

- **Presentation Layer**: Screens, Widgets, State Providers (Riverpod)
- **Domain Layer**: Models, Repositories, Use Cases
- **Data Layer**: Supabase Client, Data Sources
- **Backend**: Supabase (PostgreSQL + Auth + Storage)

## Tech Stack

- Flutter Web
- Material 3
- Riverpod (State Management)
- GoRouter (Navigation)
- Supabase (Backend & Database)
- Freezed (Code Generation)
- fl_chart (Charts)

## Setup

### Prerequisites

- Flutter SDK (3.6.2 or higher)
- Supabase account and project
- Existing Supabase database with tables: `profiles`, `vehicles`, `allocations`, `expenses`, `maintenance_records`

### Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Generate code (Freezed, JSON serialization):
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. Configure Supabase:
   - Update `lib/main.dart` with your Supabase URL and anon key
   - Or set environment variables:
     ```bash
     flutter run -d chrome --dart-define=SUPABASE_URL=your_url --dart-define=SUPABASE_ANON_KEY=your_key
     ```

### Database Schema

The application expects the following tables in your Supabase database:

- `profiles` - User profiles with roles
- `vehicles` - Vehicle information
- `allocations` - Vehicle allocation records
- `allocation_history` - Allocation status history
- `expenses` - Expense tracking
- `maintenance_records` - Vehicle maintenance history

See `lib/core/config/database_schema.dart` for expected column names.

## Running the Application

```bash
flutter run -d chrome
```

## Project Structure

```
lib/
├── core/           # Core infrastructure (config, theme, routing, widgets)
├── auth/           # Authentication module
├── vehicles/       # Vehicle management module
├── allocations/    # Allocation management module
├── expenses/       # Expense tracking module
├── reports/        # Reports and analytics module
├── shared/         # Shared widgets and utilities
├── main.dart       # App entry point
└── app.dart        # Root widget
```

## Key Files

- `lib/main.dart` - Application entry point with Supabase initialization
- `lib/core/routing/app_router.dart` - Route configuration
- `lib/core/config/supabase_config.dart` - Supabase client configuration
- `lib/core/config/database_schema.dart` - Database schema reference

## Features by Module

### Vehicles
- List all vehicles with filtering and search
- View vehicle details
- Create and edit vehicles
- Track vehicle status (Available, In Use, Maintenance, Retired)

### Allocations
- Request vehicle allocations
- Approve/reject allocations (managers)
- Handover and return workflows
- View allocation history timeline

### Expenses
- Track expenses by category
- Link expenses to vehicles or allocations
- Upload receipt images
- Filter by date range and category

### Reports
- Usage reports by vehicle
- Cost reports with category breakdown
- Charts and visualizations

## Environment Variables

Set these when running the app:

- `SUPABASE_URL` - Your Supabase project URL
- `SUPABASE_ANON_KEY` - Your Supabase anon key

## Notes

- The application is designed to work with an existing Supabase database used by a mobile app
- Models and repositories are structured to match the existing database schema
- All database operations respect existing Row Level Security (RLS) policies
- The app uses Material 3 design system

## License

This project is for internal use only.
# cars-application
