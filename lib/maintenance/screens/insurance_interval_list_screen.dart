import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../vehicles/models/vehicle_model.dart';
import '../../vehicles/providers/vehicle_provider.dart';
import '../models/insurance_interval_model.dart';
import '../providers/insurance_interval_provider.dart';
import '../../core/widgets/loading_indicator.dart';

/// Screen to manage insurance intervals for new cars
class InsuranceIntervalListScreen extends ConsumerWidget {
  const InsuranceIntervalListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Fetch only new cars
    final vehiclesAsync = ref.watch(
      vehicleListProvider(
        VehicleListParams(isNewFilter: true),
      ),
    );

    // Fetch all insurance intervals
    final intervalsAsync = ref.watch(allInsuranceIntervalsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Insurance Intervals'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(vehicleListProvider);
              ref.invalidate(allInsuranceIntervalsProvider);
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: vehiclesAsync.when(
        data: (vehicles) {
          if (vehicles.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shield_outlined,
                    size: 64,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No new cars found',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Insurance intervals can only be set for new cars.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return intervalsAsync.when(
            data: (intervals) {
              // Create a map of carId -> interval for quick lookup
              final intervalMap = {
                for (var interval in intervals) interval.carId: interval
              };

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: vehicles.length,
                itemBuilder: (context, index) {
                  final vehicle = vehicles[index];
                  final interval = intervalMap[vehicle.id];
                  return _InsuranceIntervalCard(
                    vehicle: vehicle,
                    interval: interval,
                  );
                },
              );
            },
            loading: () => const Center(child: LoadingIndicator()),
            error: (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading intervals',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    error.toString(),
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: LoadingIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Error loading vehicles',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InsuranceIntervalCard extends ConsumerWidget {
  final VehicleModel vehicle;
  final InsuranceIntervalModel? interval;

  const _InsuranceIntervalCard({
    required this.vehicle,
    this.interval,
  });

  // Generate kilometer options: 30,000 to 200,000 in increments of 10,000
  static final List<int> _kilometerOptions = List.generate(
    18,
    (index) => 30000 + (index * 10000),
  );

  // Generate year options: 3 to 10
  static final List<int> _yearOptions = List.generate(8, (index) => index + 3);

  // StateProviders for each card (keyed by vehicle ID)
  static final _kilometersProvider = StateProvider.family<int, String>((ref, vehicleId) {
    // This will be initialized when the card is built
    return 30000; // Default
  });

  static final _yearsProvider = StateProvider.family<int, String>((ref, vehicleId) {
    return 3; // Default
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Initialize state providers with existing interval values if available
    final defaultKm = interval?.intervalKilometers ?? _kilometerOptions.first;
    final defaultYears = interval?.intervalYears ?? _yearOptions.first;

    // Get current state from providers, or initialize with defaults
    final kilometersState = ref.watch(_kilometersProvider(vehicle.id));
    final yearsState = ref.watch(_yearsProvider(vehicle.id));

    // Initialize providers if they haven't been set yet
    if (kilometersState == 30000 && interval != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(_kilometersProvider(vehicle.id).notifier).state = defaultKm;
      });
    }
    if (yearsState == 3 && interval != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(_yearsProvider(vehicle.id).notifier).state = defaultYears;
      });
    }

    final selectedKm = kilometersState == 30000 && interval != null ? defaultKm : kilometersState;
    final selectedYears = yearsState == 3 && interval != null ? defaultYears : yearsState;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        leading: Icon(
          Icons.directions_car,
          color: colorScheme.primary,
        ),
        title: Text(
          vehicle.model,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Number: ${vehicle.number}'),
            if (interval != null) ...[
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Interval: ${_formatKilometers(interval!.intervalKilometers)} / ${interval!.intervalYears} years',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Kilometers dropdown
                DropdownButtonFormField<int>(
                  value: selectedKm,
                  decoration: InputDecoration(
                    labelText: 'Interval Kilometers',
                    helperText: 'Select the kilometer interval for insurance renewal',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items: _kilometerOptions.map((km) {
                    return DropdownMenuItem<int>(
                      value: km,
                      child: Text('${_formatKilometers(km)} km'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      ref.read(_kilometersProvider(vehicle.id).notifier).state = value;
                    }
                  },
                ),
                const SizedBox(height: 16),
                // Years dropdown
                DropdownButtonFormField<int>(
                  value: selectedYears,
                  decoration: InputDecoration(
                    labelText: 'Interval Years',
                    helperText: 'Select the year interval for insurance renewal',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items: _yearOptions.map((year) {
                    return DropdownMenuItem<int>(
                      value: year,
                      child: Text('$year ${year == 1 ? 'year' : 'years'}'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      ref.read(_yearsProvider(vehicle.id).notifier).state = value;
                    }
                  },
                ),
                const SizedBox(height: 24),
                // Save button
                ElevatedButton(
                  onPressed: selectedKm != null && selectedYears != null
                      ? () => _saveInterval(context, ref, selectedKm, selectedYears)
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Save Insurance Interval'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatKilometers(int km) {
    return km.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  Future<void> _saveInterval(
    BuildContext context,
    WidgetRef ref,
    int selectedKm,
    int selectedYears,
  ) async {
    try {
      final now = DateTime.now();
      final intervalToSave = interval != null
          ? interval!.copyWith(
              intervalKilometers: selectedKm,
              intervalYears: selectedYears,
            )
          : InsuranceIntervalModel(
              id: '', // Will be generated by database
              carId: vehicle.id,
              intervalKilometers: selectedKm,
              intervalYears: selectedYears,
              startDate: now,
              createdAt: now,
              updatedAt: now,
            );

      if (interval != null) {
        await ref.read(updateInsuranceIntervalProvider(intervalToSave).future);
      } else {
        await ref.read(createInsuranceIntervalProvider(intervalToSave).future);
      }

      // Refresh the intervals list
      ref.invalidate(allInsuranceIntervalsProvider);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Insurance interval saved successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving interval: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

