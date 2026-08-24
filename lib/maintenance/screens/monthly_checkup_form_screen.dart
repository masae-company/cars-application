import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:exui/exui.dart';
import '../models/monthly_checkup_model.dart';
import '../providers/monthly_checkup_provider.dart';
import '../../vehicles/providers/vehicle_provider.dart';
import '../../vehicles/models/vehicle_model.dart';
import '../../auth/providers/user_provider.dart';
import '../../auth/models/user_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../core/utils/validators.dart';
import '../../core/theme/app_colors.dart';
import '../../auth/providers/auth_provider.dart';

class MonthlyCheckupFormScreen extends ConsumerStatefulWidget {
  final MonthlyCheckupModel? checkup;

  const MonthlyCheckupFormScreen({super.key, this.checkup});

  @override
  ConsumerState<MonthlyCheckupFormScreen> createState() =>
      _MonthlyCheckupFormScreenState();
}

class _MonthlyCheckupFormScreenState
    extends ConsumerState<MonthlyCheckupFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _notesController;
  String? _selectedCarId;
  String? _selectedPerformedBy;
  DateTime? _checkupDate;
  DateTime? _completedAt;
  bool _isLoading = false;

  // All checkup fields
  bool _engineOilReplaced = false;
  bool _engineAirFilterInspected = false;
  bool _engineAirFilterReplaced = false;
  bool _acAirFilterInspected = false;
  bool _automaticTransmissionFluidInspected = false;
  bool _manualTransmissionFluidInspected = false;
  bool _differentialFluidInspected = false;
  bool _sparkPlugsInspected = false;
  bool _coolantLevelInspected = false;
  bool _coolantConditionInspected = false;
  bool _brakeClutchFluidInspected = false;
  bool _fluidLeaksInspected = false;
  bool _radiatorHosesInspected = false;
  bool _driveShaftsBootsInspected = false;
  bool _fuelFilterInspected = false;
  bool _suspensionInspected = false;
  bool _shockAbsorberInspected = false;
  bool _suspensionRetightened = false;
  bool _engineSupportInspected = false;
  bool _driveBeltPulleysInspected = false;
  bool _brakeLinesInspected = false;
  bool _brakePadsInspected = false;
  bool _parkBrakeInspected = false;
  bool _tiresInspected = false;
  bool _exhaustSystemInspected = false;
  bool _tiresRotated = false;
  bool _lightsInspected = false;
  bool _batteryInspected = false;
  bool _acOperationInspected = false;
  bool _wipersInspected = false;
  bool _diagnosticToolsUsed = false;
  bool _oilServiceReset = false;

  @override
  void initState() {
    super.initState();
    final checkup = widget.checkup;
    _notesController = TextEditingController(text: checkup?.notes ?? '');
    _selectedCarId = checkup?.carId;
    _selectedPerformedBy = checkup?.performedBy;
    _checkupDate = checkup?.checkupDate ?? DateTime.now();
    _completedAt = checkup?.completedAt;

    // Initialize all boolean fields
    _engineOilReplaced = checkup?.engineOilReplaced ?? false;
    _engineAirFilterInspected = checkup?.engineAirFilterInspected ?? false;
    _engineAirFilterReplaced = checkup?.engineAirFilterReplaced ?? false;
    _acAirFilterInspected = checkup?.acAirFilterInspected ?? false;
    _automaticTransmissionFluidInspected =
        checkup?.automaticTransmissionFluidInspected ?? false;
    _manualTransmissionFluidInspected =
        checkup?.manualTransmissionFluidInspected ?? false;
    _differentialFluidInspected = checkup?.differentialFluidInspected ?? false;
    _sparkPlugsInspected = checkup?.sparkPlugsInspected ?? false;
    _coolantLevelInspected = checkup?.coolantLevelInspected ?? false;
    _coolantConditionInspected = checkup?.coolantConditionInspected ?? false;
    _brakeClutchFluidInspected = checkup?.brakeClutchFluidInspected ?? false;
    _fluidLeaksInspected = checkup?.fluidLeaksInspected ?? false;
    _radiatorHosesInspected = checkup?.radiatorHosesInspected ?? false;
    _driveShaftsBootsInspected = checkup?.driveShaftsBootsInspected ?? false;
    _fuelFilterInspected = checkup?.fuelFilterInspected ?? false;
    _suspensionInspected = checkup?.suspensionInspected ?? false;
    _shockAbsorberInspected = checkup?.shockAbsorberInspected ?? false;
    _suspensionRetightened = checkup?.suspensionRetightened ?? false;
    _engineSupportInspected = checkup?.engineSupportInspected ?? false;
    _driveBeltPulleysInspected = checkup?.driveBeltPulleysInspected ?? false;
    _brakeLinesInspected = checkup?.brakeLinesInspected ?? false;
    _brakePadsInspected = checkup?.brakePadsInspected ?? false;
    _parkBrakeInspected = checkup?.parkBrakeInspected ?? false;
    _tiresInspected = checkup?.tiresInspected ?? false;
    _exhaustSystemInspected = checkup?.exhaustSystemInspected ?? false;
    _tiresRotated = checkup?.tiresRotated ?? false;
    _lightsInspected = checkup?.lightsInspected ?? false;
    _batteryInspected = checkup?.batteryInspected ?? false;
    _acOperationInspected = checkup?.acOperationInspected ?? false;
    _wipersInspected = checkup?.wipersInspected ?? false;
    _diagnosticToolsUsed = checkup?.diagnosticToolsUsed ?? false;
    _oilServiceReset = checkup?.oilServiceReset ?? false;
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedCarId == null || _selectedCarId!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.pleaseSelectVehicle)),
      );
      return;
    }

    if (_selectedPerformedBy == null || _selectedPerformedBy!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.pleaseSelectPerformedBy)),
      );
      return;
    }

    if (_checkupDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.pleaseSelectCheckupDate)),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final now = DateTime.now();
      final checkup = MonthlyCheckupModel(
        id: widget.checkup?.id ?? '',
        carId: _selectedCarId!,
        checkupDate: _checkupDate!,
        performedBy: _selectedPerformedBy!,
        notes: _notesController.text.isEmpty ? null : _notesController.text.trim(),
        completedAt: _completedAt,
        engineOilReplaced: _engineOilReplaced,
        engineAirFilterInspected: _engineAirFilterInspected,
        engineAirFilterReplaced: _engineAirFilterReplaced,
        acAirFilterInspected: _acAirFilterInspected,
        automaticTransmissionFluidInspected: _automaticTransmissionFluidInspected,
        manualTransmissionFluidInspected: _manualTransmissionFluidInspected,
        differentialFluidInspected: _differentialFluidInspected,
        sparkPlugsInspected: _sparkPlugsInspected,
        coolantLevelInspected: _coolantLevelInspected,
        coolantConditionInspected: _coolantConditionInspected,
        brakeClutchFluidInspected: _brakeClutchFluidInspected,
        fluidLeaksInspected: _fluidLeaksInspected,
        radiatorHosesInspected: _radiatorHosesInspected,
        driveShaftsBootsInspected: _driveShaftsBootsInspected,
        fuelFilterInspected: _fuelFilterInspected,
        suspensionInspected: _suspensionInspected,
        shockAbsorberInspected: _shockAbsorberInspected,
        suspensionRetightened: _suspensionRetightened,
        engineSupportInspected: _engineSupportInspected,
        driveBeltPulleysInspected: _driveBeltPulleysInspected,
        brakeLinesInspected: _brakeLinesInspected,
        brakePadsInspected: _brakePadsInspected,
        parkBrakeInspected: _parkBrakeInspected,
        tiresInspected: _tiresInspected,
        exhaustSystemInspected: _exhaustSystemInspected,
        tiresRotated: _tiresRotated,
        lightsInspected: _lightsInspected,
        batteryInspected: _batteryInspected,
        acOperationInspected: _acOperationInspected,
        wipersInspected: _wipersInspected,
        diagnosticToolsUsed: _diagnosticToolsUsed,
        oilServiceReset: _oilServiceReset,
        createdAt: widget.checkup?.createdAt ?? now,
        updatedAt: now,
      );

      if (widget.checkup != null) {
        await ref.read(updateMonthlyCheckupProvider(checkup).future);
      } else {
        await ref.read(createMonthlyCheckupProvider(checkup).future);
      }

      if (mounted) {
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final vehiclesAsync = ref.watch(vehicleListProvider(VehicleListParams()));
    final usersAsync = ref.watch(allUsersProvider);
    final currentUser = ref.watch(authProvider).valueOrNull;

    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.checkup == null
                ? AppLocalizations.of(context)!.createMonthlyCheckup
                : AppLocalizations.of(context)!.editMonthlyCheckup),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            _buildHeader(context),

            // Form Section
            Form(
              key: _formKey,
              child: _ModernCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Vehicle Selection
                    _buildVehicleDropdown(context, vehiclesAsync),

                    const SizedBox(height: 24),

                    // Performed By Selection
                    _buildPerformedByField(context, usersAsync, currentUser),

                    const SizedBox(height: 24),

                    // Checkup Date
                    _buildDatePicker(
                      context: context,
                      label: '${AppLocalizations.of(context)!.checkupDate} *',
                      date: _checkupDate,
                      onDateSelected: (date) => setState(() => _checkupDate = date),
                    ),

                    const SizedBox(height: 24),

                    // Completed At (optional)
                    _buildDatePicker(
                      context: context,
                      label: AppLocalizations.of(context)!.completedAtOptional,
                      date: _completedAt,
                      onDateSelected: (date) => setState(() => _completedAt = date),
                    ),

                    const SizedBox(height: 24),

                    // Notes
                    _buildFormField(
                      context,
                      icon: Icons.notes,
                      label: AppLocalizations.of(context)!.notes,
                      controller: _notesController,
                      maxLines: 3,
                      isRequired: false,
                    ),

                    const SizedBox(height: 32),

                    // Checkup Sections
                    _buildSectionHeader(context, AppLocalizations.of(context)!.engineAndFluids),
                    const SizedBox(height: 12),
                    _buildCheckbox(
                      context,
                      label: AppLocalizations.of(context)!.engineOilReplaced,
                      value: _engineOilReplaced,
                      onChanged: (value) =>
                          setState(() => _engineOilReplaced = value ?? false),
                    ),
                    _buildCheckbox(
                      context,
                      label: AppLocalizations.of(context)!.engineAirFilterInspected,
                      value: _engineAirFilterInspected,
                      onChanged: (value) =>
                          setState(() => _engineAirFilterInspected = value ?? false),
                    ),
                    _buildCheckbox(
                      context,
                      label: AppLocalizations.of(context)!.engineAirFilterReplaced,
                      value: _engineAirFilterReplaced,
                      onChanged: (value) =>
                          setState(() => _engineAirFilterReplaced = value ?? false),
                    ),
                    _buildCheckbox(
                      context,
                      label: AppLocalizations.of(context)!.acAirFilterInspected,
                      value: _acAirFilterInspected,
                      onChanged: (value) =>
                          setState(() => _acAirFilterInspected = value ?? false),
                    ),
                    _buildCheckbox(
                      context,
                      label: AppLocalizations.of(context)!.automaticTransmissionFluidInspected,
                      value: _automaticTransmissionFluidInspected,
                      onChanged: (value) => setState(
                          () => _automaticTransmissionFluidInspected = value ?? false),
                    ),
                    _buildCheckbox(
                      context,
                      label: AppLocalizations.of(context)!.manualTransmissionFluidInspected,
                      value: _manualTransmissionFluidInspected,
                      onChanged: (value) => setState(
                          () => _manualTransmissionFluidInspected = value ?? false),
                    ),
                    _buildCheckbox(
                      context,
                      label: AppLocalizations.of(context)!.differentialFluidInspected,
                      value: _differentialFluidInspected,
                      onChanged: (value) =>
                          setState(() => _differentialFluidInspected = value ?? false),
                    ),
                    _buildCheckbox(
                      context,
                      label: AppLocalizations.of(context)!.sparkPlugsInspected,
                      value: _sparkPlugsInspected,
                      onChanged: (value) =>
                          setState(() => _sparkPlugsInspected = value ?? false),
                    ),
                    _buildCheckbox(
                      context,
                      label: AppLocalizations.of(context)!.coolantLevelInspected,
                      value: _coolantLevelInspected,
                      onChanged: (value) =>
                          setState(() => _coolantLevelInspected = value ?? false),
                    ),
                    _buildCheckbox(
                      context,
                      label: AppLocalizations.of(context)!.coolantConditionInspected,
                      value: _coolantConditionInspected,
                      onChanged: (value) =>
                          setState(() => _coolantConditionInspected = value ?? false),
                    ),
                    _buildCheckbox(
                      context,
                      label: AppLocalizations.of(context)!.brakeClutchFluidInspected,
                      value: _brakeClutchFluidInspected,
                      onChanged: (value) =>
                          setState(() => _brakeClutchFluidInspected = value ?? false),
                    ),
                    _buildCheckbox(
                      context,
                      label: AppLocalizations.of(context)!.fluidLeaksInspected,
                      value: _fluidLeaksInspected,
                      onChanged: (value) =>
                          setState(() => _fluidLeaksInspected = value ?? false),
                    ),
                    _buildCheckbox(
                      context,
                      label: AppLocalizations.of(context)!.radiatorHosesInspected,
                      value: _radiatorHosesInspected,
                      onChanged: (value) =>
                          setState(() => _radiatorHosesInspected = value ?? false),
                    ),
                    _buildCheckbox(
                      context,
                      label: AppLocalizations.of(context)!.driveShaftsBootsInspected,
                      value: _driveShaftsBootsInspected,
                      onChanged: (value) =>
                          setState(() => _driveShaftsBootsInspected = value ?? false),
                    ),
                    _buildCheckbox(
                      context,
                      label: AppLocalizations.of(context)!.fuelFilterInspected,
                      value: _fuelFilterInspected,
                      onChanged: (value) =>
                          setState(() => _fuelFilterInspected = value ?? false),
                    ),

                    const SizedBox(height: 24),

                    _buildSectionHeader(context, AppLocalizations.of(context)!.suspensionAndBrakes),
                    const SizedBox(height: 12),
                    _buildCheckbox(
                      context,
                      label: AppLocalizations.of(context)!.suspensionInspected,
                      value: _suspensionInspected,
                      onChanged: (value) =>
                          setState(() => _suspensionInspected = value ?? false),
                    ),
                    _buildCheckbox(
                      context,
                      label: AppLocalizations.of(context)!.shockAbsorberInspected,
                      value: _shockAbsorberInspected,
                      onChanged: (value) =>
                          setState(() => _shockAbsorberInspected = value ?? false),
                    ),
                    _buildCheckbox(
                      context,
                      label: AppLocalizations.of(context)!.suspensionRetightened,
                      value: _suspensionRetightened,
                      onChanged: (value) =>
                          setState(() => _suspensionRetightened = value ?? false),
                    ),
                    _buildCheckbox(
                      context,
                      label: AppLocalizations.of(context)!.engineSupportInspected,
                      value: _engineSupportInspected,
                      onChanged: (value) =>
                          setState(() => _engineSupportInspected = value ?? false),
                    ),
                    _buildCheckbox(
                      context,
                      label: AppLocalizations.of(context)!.driveBeltPulleysInspected,
                      value: _driveBeltPulleysInspected,
                      onChanged: (value) =>
                          setState(() => _driveBeltPulleysInspected = value ?? false),
                    ),
                    _buildCheckbox(
                      context,
                      label: AppLocalizations.of(context)!.brakeLinesInspected,
                      value: _brakeLinesInspected,
                      onChanged: (value) =>
                          setState(() => _brakeLinesInspected = value ?? false),
                    ),
                    _buildCheckbox(
                      context,
                      label: AppLocalizations.of(context)!.brakePadsInspected,
                      value: _brakePadsInspected,
                      onChanged: (value) =>
                          setState(() => _brakePadsInspected = value ?? false),
                    ),
                    _buildCheckbox(
                      context,
                      label: AppLocalizations.of(context)!.parkBrakeInspected,
                      value: _parkBrakeInspected,
                      onChanged: (value) =>
                          setState(() => _parkBrakeInspected = value ?? false),
                    ),

                    const SizedBox(height: 24),

                    _buildSectionHeader(context, AppLocalizations.of(context)!.tiresAndExhaust),
                    const SizedBox(height: 12),
                    _buildCheckbox(
                      context,
                      label: AppLocalizations.of(context)!.tiresInspected,
                      value: _tiresInspected,
                      onChanged: (value) =>
                          setState(() => _tiresInspected = value ?? false),
                    ),
                    _buildCheckbox(
                      context,
                      label: AppLocalizations.of(context)!.exhaustSystemInspected,
                      value: _exhaustSystemInspected,
                      onChanged: (value) =>
                          setState(() => _exhaustSystemInspected = value ?? false),
                    ),
                    _buildCheckbox(
                      context,
                      label: AppLocalizations.of(context)!.tiresRotated,
                      value: _tiresRotated,
                      onChanged: (value) =>
                          setState(() => _tiresRotated = value ?? false),
                    ),

                    const SizedBox(height: 24),

                    _buildSectionHeader(context, AppLocalizations.of(context)!.electricalAndOther),
                    const SizedBox(height: 12),
                    _buildCheckbox(
                      context,
                      label: AppLocalizations.of(context)!.lightsInspected,
                      value: _lightsInspected,
                      onChanged: (value) =>
                          setState(() => _lightsInspected = value ?? false),
                    ),
                    _buildCheckbox(
                      context,
                      label: AppLocalizations.of(context)!.batteryInspected,
                      value: _batteryInspected,
                      onChanged: (value) =>
                          setState(() => _batteryInspected = value ?? false),
                    ),
                    _buildCheckbox(
                      context,
                      label: AppLocalizations.of(context)!.acOperationInspected,
                      value: _acOperationInspected,
                      onChanged: (value) =>
                          setState(() => _acOperationInspected = value ?? false),
                    ),
                    _buildCheckbox(
                      context,
                      label: AppLocalizations.of(context)!.wipersInspected,
                      value: _wipersInspected,
                      onChanged: (value) =>
                          setState(() => _wipersInspected = value ?? false),
                    ),
                    _buildCheckbox(
                      context,
                      label: AppLocalizations.of(context)!.diagnosticToolsUsed,
                      value: _diagnosticToolsUsed,
                      onChanged: (value) =>
                          setState(() => _diagnosticToolsUsed = value ?? false),
                    ),
                    _buildCheckbox(
                      context,
                      label: AppLocalizations.of(context)!.oilServiceReset,
                      value: _oilServiceReset,
                      onChanged: (value) =>
                          setState(() => _oilServiceReset = value ?? false),
                    ),

                    const SizedBox(height: 32),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleSubmit,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Text(
                                widget.checkup == null
                                    ? AppLocalizations.of(context)!.createMonthlyCheckup
                                    : AppLocalizations.of(context)!.updateCheckup,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                      ),
                    ),
                  ],
                ).padding(const EdgeInsets.all(24)),
              ),
            ),
          ],
        ).padding(const EdgeInsets.all(24)),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.checkup == null
                ? AppLocalizations.of(context)!.createMonthlyCheckup
                : AppLocalizations.of(context)!.editMonthlyCheckup,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.onBackground,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.checkup == null
                ? AppLocalizations.of(context)!.monthlyCheckupCreationDescription
                : AppLocalizations.of(context)!.monthlyCheckupUpdateDescription,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleDropdown(
    BuildContext context,
    AsyncValue<List<VehicleModel>> vehiclesAsync,
  ) {
    return vehiclesAsync.when(
      data: (vehicles) {
        if (vehicles.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.error.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.warning, color: AppColors.error),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.noVehiclesAvailable,
                    style: TextStyle(color: AppColors.error),
                  ),
                ),
              ],
            ),
          );
        }

        return DropdownButtonFormField<String>(
          value: _selectedCarId,
          decoration: InputDecoration(
            labelText: '${AppLocalizations.of(context)!.vehicle} *',
            prefixIcon: Icon(Icons.directions_car, color: AppColors.primary),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
          ),
          items: vehicles.map((vehicle) {
            return DropdownMenuItem<String>(
              value: vehicle.id,
              child: Text('${vehicle.model} - ${vehicle.number}'),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedCarId = value;
            });
          },
          validator: (value) => Validators.required(value, fieldName: AppLocalizations.of(context)!.vehicle),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Text(AppLocalizations.of(context)!.errorLoadingVehicles(error.toString())),
    );
  }

  Widget _buildPerformedByField(
    BuildContext context,
    AsyncValue<List<UserModel>> usersAsync,
    UserModel? currentUser,
  ) {
    // If creating new checkup, default to current user
    if (widget.checkup == null && currentUser != null && _selectedPerformedBy == null) {
      _selectedPerformedBy = currentUser.id;
    }

    String displayValue = '';
    
    // In edit mode or after selection
    if (_selectedPerformedBy != null) {
      // Try to find the user in the loaded list
      final user = usersAsync.valueOrNull?.cast<UserModel?>().firstWhere(
            (u) => u?.id == _selectedPerformedBy,
            orElse: () => null,
          );
      
      if (user != null) {
        displayValue = user.name ?? user.email;
      } else if (_selectedPerformedBy == currentUser?.id) {
        // Fallback to current user if exact match
        displayValue = currentUser?.name ?? currentUser?.email ?? '';
      } else {
        // If user not found in list (e.g. loading or deleted), show text or ID
        displayValue = _selectedPerformedBy!; 
      }
    } else if (currentUser != null) {
      // Fallback display for current user if not yet assigned
      displayValue = currentUser.name ?? currentUser.email;
    }

    return TextFormField(
      initialValue: displayValue,
      readOnly: true,
      enabled: false, // Make it look disabled/locked
      decoration: InputDecoration(
        labelText: '${AppLocalizations.of(context)!.performedByLabel} *',
        prefixIcon: Icon(Icons.person, color: AppColors.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
      ),
    );
  }

  Widget _buildFormField(
    BuildContext context, {
    required IconData icon,
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
    bool isRequired = true,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: isRequired ? '$label *' : label,
        prefixIcon: Icon(icon, color: AppColors.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
      ),
      validator: isRequired
          ? (value) => Validators.required(value, fieldName: label)
          : null,
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.onBackground,
          ),
    );
  }

  Widget _buildCheckbox(
    BuildContext context, {
    required String label,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return CheckboxListTile(
      title: Text(label),
      value: value,
      onChanged: onChanged,
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildDatePicker({
    required BuildContext context,
    required String label,
    DateTime? date,
    required ValueChanged<DateTime?> onDateSelected,
  }) {
    return InkWell(
      onTap: () async {
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (selectedDate != null) {
          onDateSelected(selectedDate);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.onSurfaceVariant.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, color: AppColors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                date == null
                    ? label
                    : '${label.split(' ')[0]}: ${date.toString().split(' ')[0]}',
                style: TextStyle(
                  color: date == null
                      ? AppColors.onSurfaceVariant
                      : AppColors.onBackground,
                ),
              ),
            ),
            if (date != null)
              IconButton(
                icon: const Icon(Icons.clear, size: 20),
                onPressed: () => onDateSelected(null),
              ),
          ],
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

