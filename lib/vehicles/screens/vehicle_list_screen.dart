
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart' hide Border;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:exui/exui.dart';
import '../providers/vehicle_provider.dart';
import '../models/vehicle_model.dart';
import '../widgets/vehicle_card.dart';
import '../../core/constants/route_names.dart';
import '../../core/widgets/loading_indicator.dart';
import '../../core/theme/app_colors.dart';
import '../../auth/providers/auth_provider.dart';

class VehicleListScreen extends ConsumerStatefulWidget {
  const VehicleListScreen({super.key});

  @override
  ConsumerState<VehicleListScreen> createState() => _VehicleListScreenState();
}

class _VehicleListScreenState extends ConsumerState<VehicleListScreen> {
  final _searchController = TextEditingController();
  CarLocation? _selectedLocation;
  bool? _isNewFilter;
  VehicleStatus? _statusFilter;
  bool? _isAccidentFilter;
  String? _selectedModel;
  bool _isImporting = false;

  Future<void> _importFromExcel() async {
    final currentUser = ref.read(authProvider).value;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.youMustBeLoggedIn)),
      );
      return;
    }

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
      );

      if (result == null || result.files.isEmpty) return;

      setState(() {
        _isImporting = true;
      });

      // Fetch all existing car numbers AND vehicles to check for duplicates and update
      final repository = ref.read(vehicleRepositoryProvider);
      final existingVehicles = await repository.getAllVehicles();
      // Create a map for quick lookup by plate number
      final existingVehiclesMap = {
        for (var v in existingVehicles) v.number.toLowerCase().trim(): v
      };

      // Use bytes directly for web compatibility
      final bytes = result.files.single.bytes!;
      final excel = Excel.decodeBytes(bytes);

      int successCount = 0;
      int updateCount = 0;
      int failCount = 0;

      // Collect vehicles to create and update (batch processing)
      final List<VehicleModel> vehiclesToCreate = [];
      final List<VehicleModel> vehiclesToUpdate = [];

      for (var table in excel.tables.keys) {
        final sheet = excel.tables[table];
        if (sheet == null) continue;

        // Skip first 2 rows (headers), data starts at row 3 (index 2)
        int rowIndex = 0;
        for (var row in sheet.rows) {
          rowIndex++;
          
          // Skip first 2 rows (row 1 and row 2)
          if (rowIndex <= 2) continue;
          
          if (row.isEmpty) continue;

          try {
            // Excel column mapping (0-based index):
            // Column B (index 1): Location (الموقع) - الرياض، الدمام، الأحساء
            // Column C (index 2): Make/Manufacturer (النوع)
            // Column D (index 3): Model/Sub-model (الطراز)
            // Column E (index 4): Plate Number (رقم اللوحة)
            // Column F (index 5): Color (اللون)
            // Column G (index 6): Year (الإصدار)
            
            final locationRaw = row.length > 1 ? row[1]?.value?.toString() : null;
            final make = row.length > 2 ? row[2]?.value?.toString() : null;
            final model = row.length > 3 ? row[3]?.value?.toString() : null;
            final number = row.length > 4 ? row[4]?.value?.toString() : null;
            final color = row.length > 5 ? row[5]?.value?.toString() : null;
            final yearRaw = row.length > 6 ? row[6]?.value : null;
            
            // Skip if essential fields are missing
            if (number == null || number.trim().isEmpty || model == null || model.trim().isEmpty) {
              continue;
            }
            
            final location = CarLocation.fromString(locationRaw);
            
            // Handle year - CellValue can be different types
            int? year;
            if (yearRaw != null) {
              switch (yearRaw.runtimeType.toString()) {
                case 'IntCellValue':
                  year = (yearRaw as IntCellValue).value;
                  break;
                case 'DoubleCellValue':
                  year = (yearRaw as DoubleCellValue).value.toInt();
                  break;
                case 'TextCellValue':
                  final textSpan = (yearRaw as TextCellValue).value;
                  year = int.tryParse(textSpan.text ?? '');
                  break;
                default:
                  // Try to parse as string if it's any other type
                  year = int.tryParse(yearRaw.toString());
              }
            }

            // Check if vehicle already exists
            final normalizedNumber = number.toLowerCase().trim();
            final existingVehicle = existingVehiclesMap[normalizedNumber];
            
            if (existingVehicle != null) {
              // Prepare UPDATE
              final updatedVehicle = VehicleModel(
                id: existingVehicle.id,
                model: model.trim(),
                number: number.trim(),
                ownerId: existingVehicle.ownerId,
                location: location ?? existingVehicle.location,
                make: make?.trim() ?? existingVehicle.make,
                color: color?.trim() ?? existingVehicle.color,
                year: year ?? existingVehicle.year,
                isNew: existingVehicle.isNew,
                createdAt: existingVehicle.createdAt,
                updatedAt: DateTime.now(),
                description: existingVehicle.description,
                image: existingVehicle.image,
              );
              vehiclesToUpdate.add(updatedVehicle);
            } else {
              // Prepare CREATE
              final vehicle = VehicleModel(
                id: '',
                model: model.trim(),
                number: number.trim(),
                ownerId: currentUser.id,
                location: location,
                make: make?.trim(),
                color: color?.trim(),
                year: year,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              );
              vehiclesToCreate.add(vehicle);
              existingVehiclesMap[normalizedNumber] = vehicle;
            }
          } catch (e) {
            failCount++;
          }
        }
      }

      // Show confirmation dialog before processing
      if (mounted && (vehiclesToCreate.isNotEmpty || vehiclesToUpdate.isNotEmpty)) {
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => _ImportConfirmationDialog(
            vehiclesToCreate: vehiclesToCreate,
            vehiclesToUpdate: vehiclesToUpdate,
          ),
        );

        if (confirmed != true) {
          // User cancelled
          if (mounted) {
            setState(() {
              _isImporting = false;
            });
          }
          return;
        }
      }

      // Batch process all vehicles
      try {
        if (vehiclesToCreate.isNotEmpty) {
          await repository.batchCreateVehicles(vehiclesToCreate);
          successCount = vehiclesToCreate.length;
        }
        
        if (vehiclesToUpdate.isNotEmpty) {
          await repository.batchUpdateVehicles(vehiclesToUpdate);
          updateCount = vehiclesToUpdate.length;
        }
      } catch (e) {
        print('Error in batch processing: $e');
        // If batch fails, count all as failed
        failCount += vehiclesToCreate.length + vehiclesToUpdate.length;
        successCount = 0;
        updateCount = 0;
      }

      if (mounted) {
        final totalProcessed = successCount + updateCount;
        final message = totalProcessed > 0
            ? '${AppLocalizations.of(context)!.carsImportedSuccessfully} (New: $successCount, Updated: $updateCount)${failCount > 0 ? ' • Failed: $failCount' : ''}'
            : 'No cars imported${failCount > 0 ? ' • Failed: $failCount' : ''}';
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: successCount > 0 ? AppColors.success : AppColors.error,
            duration: const Duration(seconds: 5),
          ),
        );
        
        // Refresh the list providers
        ref.invalidate(vehicleRepositoryProvider);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.failedToImportCars(e.toString())),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isImporting = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }



  void _clearFilters() {
    setState(() {
      _selectedLocation = null;
      _isNewFilter = null;
      _statusFilter = null;
      _isAccidentFilter = null;
      _selectedModel = null;
      _searchController.clear();
    });
  }

  bool get _hasActiveFilters {
    return _selectedLocation != null ||
        _isNewFilter != null ||
        _statusFilter != null ||
        _isAccidentFilter != null ||
        _selectedModel != null ||
        _searchController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final searchQuery = _searchController.text.isEmpty
        ? null
        : _searchController.text;
    
    final params = VehicleListParams(
      locationFilter: _selectedLocation,
      isNewFilter: _isNewFilter,
      statusFilter: _statusFilter,
      isAccidentFilter: _isAccidentFilter,
      modelFilter: _selectedModel,
      searchQuery: searchQuery,
    );
    
    final vehiclesAsync = ref.watch(vehicleListProvider(params));
    
    // Get total count (for display when no filters)
    final totalCountAsync = ref.watch(vehicleCountProvider);
    
    // Get all vehicles to extract unique models for filter dropdown
    final allVehiclesAsync = ref.watch(
      vehicleListProvider(
        VehicleListParams(),
      ),
    );

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          _buildHeader(context),
          
          // Search and Add Section
          _buildSearchSection(context),
          
          const SizedBox(height: 16),
          
          // Filters Section
          _buildFiltersSection(context, allVehiclesAsync),
          
          const SizedBox(height: 16),
          
          // Results count and vehicles grid
          vehiclesAsync.when(
            data: (vehicles) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Results count
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _hasActiveFilters
                        ? Text(
                            AppLocalizations.of(context)!.vehiclesFound(vehicles.length),
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.onSurfaceVariant,
                                ),
                          )
                        : totalCountAsync.when(
                            data: (totalCount) => Text(
                              AppLocalizations.of(context)!.totalVehiclesCount(totalCount),
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.onSurfaceVariant,
                                  ),
                            ),
                            loading: () => const SizedBox.shrink(),
                            error: (_, __) => const SizedBox.shrink(),
                          ),
                  ),
                  if (vehicles.isEmpty)
                    _buildEmptyState(context)
                  else
                    _buildVehiclesGrid(context, vehicles),
                ],
              );
            },
            loading: () => Padding(
              padding: const EdgeInsets.all(64.0),
              child: LoadingIndicator(message: AppLocalizations.of(context)!.loadingVehicles),
            ),
            error: (error, stack) => _buildErrorState(context, error, () {
              ref.invalidate(vehicleListProvider(params));
            }),
          ),
        ],
      ).padding(const EdgeInsets.symmetric(horizontal: 24, vertical: 20)),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppLocalizations.of(context)!.fleetManagement,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.onBackground,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSection(BuildContext context) {
    return _ModernCard(
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.searchVehicles,
                  prefixIcon: Icon(
                    Icons.search,
                    color: AppColors.onSurfaceVariant,
                    size: 20,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  isDense: true,
                ),
                onChanged: (_) {
                  setState(() {});
                },
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Import Button
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.primary.withOpacity(0.5)),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _isImporting ? null : _importFromExcel,
                borderRadius: BorderRadius.circular(10),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: _isImporting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.upload_file,
                                color: AppColors.primary, size: 20),
                            const SizedBox(width: 6),
                            Text(
                              AppLocalizations.of(context)!.importFromExcel,
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6750A4), Color(0xFF9575CD)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  context.push(RouteNames.vehicleCreate);
                },
                borderRadius: BorderRadius.circular(10),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.add, color: Colors.white, size: 20),
                      const SizedBox(width: 6),
                      Text(
                        AppLocalizations.of(context)!.add,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ).padding(const EdgeInsets.all(16)),
    );
  }

  Widget _buildFiltersSection(
    BuildContext context,
    AsyncValue<List<VehicleModel>> allVehiclesAsync,
  ) {
    // Extract unique models from all vehicles (case-insensitive)
    final uniqueModels = allVehiclesAsync.when(
      data: (vehicles) {
        // Create a map to store normalized (lowercase) -> original (best format)
        final modelMap = <String, String>{};
        
        for (final vehicle in vehicles) {
          final normalized = vehicle.model.toLowerCase().trim();
          if (normalized.isEmpty) continue;
          
          // If we haven't seen this model yet, or if current one is better formatted
          if (!modelMap.containsKey(normalized)) {
            // Use the first occurrence, or prefer capitalized version
            modelMap[normalized] = _capitalizeModel(vehicle.model);
          } else {
            // Prefer the version that's already capitalized properly
            final existing = modelMap[normalized]!;
            final current = _capitalizeModel(vehicle.model);
            // Keep the one that looks more "proper" (has capital letters)
            if (current != current.toLowerCase() && existing == existing.toLowerCase()) {
              modelMap[normalized] = current;
            }
          }
        }
        
        // Get unique models, sorted
        final models = modelMap.values.toList()..sort();
        return models;
      },
      loading: () => <String>[],
      error: (_, __) => <String>[],
    );

    return _ModernCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.filter_list,
                    color: AppColors.primary,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    AppLocalizations.of(context)!.filters,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.onBackground,
                        ),
                  ),
                ],
              ),
              if (_hasActiveFilters)
                TextButton(
                  onPressed: _clearFilters,
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.error,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.clear, size: 16),
                      const SizedBox(width: 4),
                      Text(AppLocalizations.of(context)!.clear, style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              // Model Filter
              _buildModelFilter(context, uniqueModels),
              // Status Filter
              _buildStatusFilter(context),
              // New Cars Filter
              _buildNewCarsFilter(context),
              // Accident Filter
              _buildAccidentFilter(context),
              // Location Filters
              ...CarLocation.values.map((location) {
                return _buildLocationFilter(context, location);
              }),
            ],
          ),
        ],
      ).padding(const EdgeInsets.all(16)),
    );
  }

  Widget _buildModelFilter(BuildContext context, List<String> models) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: _selectedModel != null
            ? AppColors.primary.withOpacity(0.1)
            : Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _selectedModel != null
              ? AppColors.primary
              : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedModel,
          hint: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.local_offer, size: 14, color: AppColors.onSurfaceVariant),
              const SizedBox(width: 4),
              Text(
                AppLocalizations.of(context)!.model,
                style: TextStyle(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          items: [
            DropdownMenuItem<String>(
              value: null,
              child: Text(AppLocalizations.of(context)!.allModels, style: const TextStyle(fontSize: 13)),
            ),
            ...models.map((model) {
              return DropdownMenuItem<String>(
                value: model,
                child: Text(model, style: const TextStyle(fontSize: 13)),
              );
            }),
          ],
          onChanged: (value) {
            setState(() {
              _selectedModel = value;
            });
          },
          icon: Icon(
            Icons.arrow_drop_down,
            color: AppColors.onSurfaceVariant,
            size: 18,
          ),
          style: TextStyle(
            color: AppColors.onBackground,
            fontSize: 13,
          ),
          isDense: true,
        ),
      ),
    );
  }

  // Helper function to capitalize model name properly
  String _capitalizeModel(String model) {
    if (model.isEmpty) return model;
    final trimmed = model.trim();
    // If it's all lowercase, capitalize first letter
    if (trimmed == trimmed.toLowerCase()) {
      return trimmed.isEmpty
          ? trimmed
          : trimmed[0].toUpperCase() + trimmed.substring(1);
    }
    // If it already has capital letters, use as is (but trim)
    return trimmed;
  }

  Widget _buildNewCarsFilter(BuildContext context) {
    final isActive = _isNewFilter == true;
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.new_releases,
            size: 14,
            color: isActive ? AppColors.success : AppColors.onSurfaceVariant,
          ),
          const SizedBox(width: 4),
          Text(AppLocalizations.of(context)!.newLabel, style: TextStyle(fontSize: 13)),
        ],
      ),
      selected: isActive,
      onSelected: (selected) {
        setState(() {
          _isNewFilter = selected ? true : null;
        });
      },
      selectedColor: AppColors.success.withOpacity(0.2),
      checkmarkColor: AppColors.success,
      side: BorderSide(
        color: isActive ? AppColors.success : Colors.transparent,
        width: 1.5,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  Widget _buildStatusFilter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: _statusFilter != null
            ? AppColors.primary.withOpacity(0.1)
            : Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _statusFilter != null
              ? AppColors.primary
              : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<VehicleStatus>(
          value: _statusFilter,
          hint: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.info_outline, size: 14, color: AppColors.onSurfaceVariant),
              const SizedBox(width: 4),
              Text(
                AppLocalizations.of(context)!.status,
                style: TextStyle(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          items: [
            DropdownMenuItem<VehicleStatus>(
              value: null,
              child: Text(AppLocalizations.of(context)!.allStatuses, style: const TextStyle(fontSize: 13)),
            ),
            ...VehicleStatus.values.map((status) {
              String label;
              switch (status) {
                case VehicleStatus.active:
                  label = AppLocalizations.of(context)!.vehicleStatusActive;
                  break;
                case VehicleStatus.workshop:
                  label = AppLocalizations.of(context)!.vehicleStatusWorkshop;
                  break;
                case VehicleStatus.insurance:
                  label = AppLocalizations.of(context)!.vehicleStatusInsurance;
                  break;
              }
              return DropdownMenuItem<VehicleStatus>(
                value: status,
                child: Text(label, style: const TextStyle(fontSize: 13)),
              );
            }),
          ],
          onChanged: (value) {
            setState(() {
              _statusFilter = value;
            });
          },
          icon: Icon(
            Icons.arrow_drop_down,
            color: AppColors.onSurfaceVariant,
            size: 18,
          ),
          style: TextStyle(
            color: AppColors.onBackground,
            fontSize: 13,
          ),
          isDense: true,
        ),
      ),
    );
  }

  Widget _buildAccidentFilter(BuildContext context) {
    final isActive = _isAccidentFilter == true;
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            size: 14,
            color: isActive ? AppColors.error : AppColors.onSurfaceVariant,
          ),
          const SizedBox(width: 4),
          Text(AppLocalizations.of(context)!.accidentVehicle, style: TextStyle(fontSize: 13)),
        ],
      ),
      selected: isActive,
      onSelected: (selected) {
        setState(() {
          _isAccidentFilter = selected ? true : null;
        });
      },
      selectedColor: AppColors.error.withOpacity(0.2),
      checkmarkColor: AppColors.error,
      side: BorderSide(
        color: isActive ? AppColors.error : Colors.transparent,
        width: 1.5,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  Widget _buildLocationFilter(BuildContext context, CarLocation location) {
    final isActive = _selectedLocation == location;
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.location_on,
            size: 14,
            color: isActive ? AppColors.info : AppColors.onSurfaceVariant,
          ),
          const SizedBox(width: 4),
          Text(
            _getLocationName(context, location),
            style: const TextStyle(fontSize: 13),
          ),
        ],
      ),
      selected: isActive,
      onSelected: (selected) {
        setState(() {
          _selectedLocation = selected ? location : null;
        });
      },
      selectedColor: AppColors.info.withOpacity(0.2),
      checkmarkColor: AppColors.info,
      side: BorderSide(
        color: isActive ? AppColors.info : Colors.transparent,
        width: 1.5,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  Widget _buildVehiclesGrid(BuildContext context, List vehicles) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 2.2, // Match dashboard tile proportions (wider/shorter)
      ),
      itemCount: vehicles.length,
      itemBuilder: (context, index) {
        return VehicleCard(vehicle: vehicles[index]);
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return _ModernCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.directions_car_outlined,
            size: 80,
            color: AppColors.onSurfaceVariant.withOpacity(0.5),
          ),
          const SizedBox(height: 24),
          Text(
            AppLocalizations.of(context)!.noVehiclesFound,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchController.text.isEmpty
                ? AppLocalizations.of(context)!.getStartedAddVehicle
                : AppLocalizations.of(context)!.adjustSearchCriteria,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
            textAlign: TextAlign.center,
          ),
          if (_searchController.text.isEmpty) ...[
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.push(RouteNames.vehicleCreate);
              },
              icon: const Icon(Icons.add),
              label: Text(AppLocalizations.of(context)!.addVehicle),
            ),
          ],
        ],
      ).padding(const EdgeInsets.all(64)),
    );
  }

  Widget _buildErrorState(
    BuildContext context,
    Object error,
    VoidCallback onRetry,
  ) {
    return _ModernCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: AppColors.error.withOpacity(0.7),
          ),
          const SizedBox(height: 24),
          Text(
            AppLocalizations.of(context)!.somethingWentWrong,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.error,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: Text(AppLocalizations.of(context)!.retry),
          ),
        ],
      ).padding(const EdgeInsets.all(64)),
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

String _getLocationName(BuildContext context, CarLocation location) {
  switch (location) {
    case CarLocation.ahsaa:
      return AppLocalizations.of(context)!.locationAhsaa;
    case CarLocation.dammam:
      return AppLocalizations.of(context)!.locationDammam;
    case CarLocation.riyadh:
      return AppLocalizations.of(context)!.locationRiyadh;
  }
}

// Import Confirmation Dialog
class _ImportConfirmationDialog extends StatelessWidget {
  final List<VehicleModel> vehiclesToCreate;
  final List<VehicleModel> vehiclesToUpdate;

  const _ImportConfirmationDialog({
    required this.vehiclesToCreate,
    required this.vehiclesToUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final totalCount = vehiclesToCreate.length + vehiclesToUpdate.length;
    
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.upload_file, color: AppColors.primary),
          const SizedBox(width: 12),
          Text('Confirm Import'),
        ],
      ),
      content: SizedBox(
        width: 600,
        height: 500,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ready to import $totalCount vehicle${totalCount != 1 ? 's' : ''}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  if (vehiclesToCreate.isNotEmpty)
                    Row(
                      children: [
                        Icon(Icons.add_circle, size: 16, color: AppColors.success),
                        const SizedBox(width: 6),
                        Text('${vehiclesToCreate.length} new vehicle${vehiclesToCreate.length != 1 ? 's' : ''}'),
                      ],
                    ),
                  if (vehiclesToUpdate.isNotEmpty)
                    Row(
                      children: [
                        Icon(Icons.update, size: 16, color: AppColors.info),
                        const SizedBox(width: 6),
                        Text('${vehiclesToUpdate.length} update${vehiclesToUpdate.length != 1 ? 's' : ''}'),
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Vehicle List
            Expanded(
              child: ListView(
                children: [
                  if (vehiclesToCreate.isNotEmpty) ...[
                    Text(
                      'New Vehicles',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.success,
                          ),
                    ),
                    const SizedBox(height: 8),
                    ...vehiclesToCreate.map((v) => _buildVehicleItem(context, v, true)),
                    const SizedBox(height: 16),
                  ],
                  if (vehiclesToUpdate.isNotEmpty) ...[
                    Text(
                      'Updates',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.info,
                          ),
                    ),
                    const SizedBox(height: 8),
                    ...vehiclesToUpdate.map((v) => _buildVehicleItem(context, v, false)),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
          child: Text('Import $totalCount Vehicle${totalCount != 1 ? 's' : ''}'),
        ),
      ],
    );
  }

  Widget _buildVehicleItem(BuildContext context, VehicleModel vehicle, bool isNew) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isNew ? AppColors.success.withOpacity(0.3) : AppColors.info.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isNew ? Icons.add_circle_outline : Icons.update,
            size: 20,
            color: isNew ? AppColors.success : AppColors.info,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vehicle.number,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${vehicle.formattedMake ?? 'N/A'} ${vehicle.formattedModel}${vehicle.year != null ? ' (${vehicle.year})' : ''}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                ),
                if (vehicle.location != null || vehicle.color != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Row(
                      children: [
                        if (vehicle.location != null) ...[
                          Icon(Icons.location_on, size: 12, color: AppColors.onSurfaceVariant),
                          const SizedBox(width: 4),
                          Text(
                            vehicle.location!.displayName,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                  fontSize: 11,
                                ),
                          ),
                        ],
                        if (vehicle.location != null && vehicle.color != null)
                          const SizedBox(width: 12),
                        if (vehicle.color != null) ...[
                          Icon(Icons.palette, size: 12, color: AppColors.onSurfaceVariant),
                          const SizedBox(width: 4),
                          Text(
                            vehicle.color!,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                  fontSize: 11,
                                ),
                          ),
                        ],
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

