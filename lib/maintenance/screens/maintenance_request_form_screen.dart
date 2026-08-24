import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:exui/exui.dart';
import '../models/maintenance_request_model.dart';
import '../providers/maintenance_request_provider.dart';
import '../../vehicles/providers/vehicle_provider.dart';
import '../../vehicles/models/vehicle_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../core/utils/validators.dart';
import '../../core/theme/app_colors.dart';

class MaintenanceRequestFormScreen extends ConsumerStatefulWidget {
  final MaintenanceRequestModel? request;

  const MaintenanceRequestFormScreen({super.key, this.request});

  @override
  ConsumerState<MaintenanceRequestFormScreen> createState() =>
      _MaintenanceRequestFormScreenState();
}

class _MaintenanceRequestFormScreenState
    extends ConsumerState<MaintenanceRequestFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _notesController;
  late TextEditingController _oilChangePreviousKmController;
  late TextEditingController _oilChangeCurrentKmController;
  String? _selectedCarId;
  DateTime? _brakePadsLastChanged;
  DateTime? _sparkPlugsLastChanged;
  DateTime? _tyresLastChanged;
  bool _acService = false;
  bool _lightsService = false;
  bool _tyreStackingService = false;
  List<String> _tyresPositions = [];
  MaintenanceRequestStatus _status = MaintenanceRequestStatus.pending;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final request = widget.request;
    _notesController = TextEditingController(text: request?.notes ?? '');
    _oilChangePreviousKmController = TextEditingController(
        text: request?.oilChangePreviousKm?.toString() ?? '');
    _oilChangeCurrentKmController =
        TextEditingController(text: request?.oilChangeCurrentKm?.toString() ?? '');
    _selectedCarId = request?.carId;
    _brakePadsLastChanged = request?.brakePadsLastChanged;
    _sparkPlugsLastChanged = request?.sparkPlugsLastChanged;
    _tyresLastChanged = request?.tyresLastChanged;
    _acService = request?.acService ?? false;
    _lightsService = request?.lightsService ?? false;
    _tyreStackingService = request?.tyreStackingService ?? false;
    _tyresPositions = List.from(request?.tyresPositions ?? []);
    _status = request?.status ?? MaintenanceRequestStatus.pending;
  }

  @override
  void dispose() {
    _notesController.dispose();
    _oilChangePreviousKmController.dispose();
    _oilChangeCurrentKmController.dispose();
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

    setState(() {
      _isLoading = true;
    });

    try {
      final now = DateTime.now();
      final request = MaintenanceRequestModel(
        id: widget.request?.id ?? '',
        carId: _selectedCarId!,
        requestedAt: widget.request?.requestedAt ?? now,
        notes: _notesController.text.isEmpty ? null : _notesController.text.trim(),
        oilChangePreviousKm: _oilChangePreviousKmController.text.isEmpty
            ? null
            : int.tryParse(_oilChangePreviousKmController.text),
        oilChangeCurrentKm: _oilChangeCurrentKmController.text.isEmpty
            ? null
            : int.tryParse(_oilChangeCurrentKmController.text),
        brakePadsLastChanged: _brakePadsLastChanged,
        sparkPlugsLastChanged: _sparkPlugsLastChanged,
        tyresLastChanged: _tyresLastChanged,
        acService: _acService,
        lightsService: _lightsService,
        tyreStackingService: _tyreStackingService,
        tyresPositions: _tyresPositions,
        status: _status,
        inProgressAt: widget.request?.inProgressAt,
        completedAt: widget.request?.completedAt,
        invoiceUrl: widget.request?.invoiceUrl,
        createdAt: widget.request?.createdAt ?? now,
        updatedAt: now,
      );

      if (widget.request != null) {
        await ref.read(updateMaintenanceRequestProvider(request).future);
      } else {
        await ref.read(createMaintenanceRequestProvider(request).future);
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

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.request == null
            ? AppLocalizations.of(context)!.createMaintenanceRequest
            : AppLocalizations.of(context)!.editMaintenanceRequest),
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
                    
                    // Status (only for edit)
                    if (widget.request != null) ...[
                      _buildStatusDropdown(context),
                      const SizedBox(height: 24),
                    ],
                    
                    // Notes
                    _buildFormField(
                      context,
                      icon: Icons.notes,
                      label: AppLocalizations.of(context)!.notes,
                      controller: _notesController,
                      maxLines: 3,
                      isRequired: false,
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Oil Change Section
                    _buildSectionHeader(context, AppLocalizations.of(context)!.oilChange),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildFormField(
                            context,
                            icon: Icons.speed,
                            label: AppLocalizations.of(context)!.previousKm,
                            controller: _oilChangePreviousKmController,
                            keyboardType: TextInputType.number,
                            isRequired: false,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildFormField(
                            context,
                            icon: Icons.speed,
                            label: AppLocalizations.of(context)!.currentKm,
                            controller: _oilChangeCurrentKmController,
                            keyboardType: TextInputType.number,
                            isRequired: false,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Service Checkboxes
                    _buildSectionHeader(context, AppLocalizations.of(context)!.maintenanceServices),
                    const SizedBox(height: 12),
                    _buildCheckbox(
                      context,
                      label: AppLocalizations.of(context)!.acService,
                      value: _acService,
                      onChanged: (value) => setState(() => _acService = value ?? false),
                    ),
                    _buildCheckbox(
                      context,
                      label: AppLocalizations.of(context)!.lightsService,
                      value: _lightsService,
                      onChanged: (value) => setState(() => _lightsService = value ?? false),
                    ),
                    _buildCheckbox(
                      context,
                      label: AppLocalizations.of(context)!.tyreStackingService,
                      value: _tyreStackingService,
                      onChanged: (value) => setState(() => _tyreStackingService = value ?? false),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Last Changed Dates
                    _buildSectionHeader(context, AppLocalizations.of(context)!.lastChangedDates),
                    const SizedBox(height: 12),
                    _buildDatePicker(
                      context: context,
                      label: AppLocalizations.of(context)!.brakePadsLastChanged,
                      date: _brakePadsLastChanged,
                      onDateSelected: (date) => setState(() => _brakePadsLastChanged = date),
                    ),
                    const SizedBox(height: 12),
                    _buildDatePicker(
                      context: context,
                      label: AppLocalizations.of(context)!.sparkPlugsLastChanged,
                      date: _sparkPlugsLastChanged,
                      onDateSelected: (date) => setState(() => _sparkPlugsLastChanged = date),
                    ),
                    const SizedBox(height: 12),
                    _buildDatePicker(
                      context: context,
                      label: AppLocalizations.of(context)!.tyresLastChanged,
                      date: _tyresLastChanged,
                      onDateSelected: (date) => setState(() => _tyresLastChanged = date),
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
                                widget.request == null
                                    ? AppLocalizations.of(context)!.createMaintenanceRequest
                                    : AppLocalizations.of(context)!.updateRequest,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
            widget.request == null
                ? AppLocalizations.of(context)!.createMaintenanceRequest
                : AppLocalizations.of(context)!.editMaintenanceRequest,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.onBackground,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.request == null
                ? AppLocalizations.of(context)!.maintenanceRequestCreationDescription
                : AppLocalizations.of(context)!.maintenanceRequestUpdateDescription,
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
          validator: (value) => Validators.required(value, fieldName: 'Vehicle'),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Text(AppLocalizations.of(context)!.errorLoadingVehicles(error.toString())),
    );
  }

  Widget _buildStatusDropdown(BuildContext context) {
    return DropdownButtonFormField<MaintenanceRequestStatus>(
      value: _status,
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.status,
        prefixIcon: Icon(Icons.info_outline, color: AppColors.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
      ),
      items: MaintenanceRequestStatus.values.map((status) {
        return DropdownMenuItem<MaintenanceRequestStatus>(
          value: status,
          child: Text(_getStatusDisplayName(context, status)),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _status = value;
          });
        }
      },
    );
  }

  Widget _buildFormField(
    BuildContext context, {
    required IconData icon,
    required String label,
    required TextEditingController controller,
    TextInputType? keyboardType,
    int maxLines = 1,
    bool isRequired = true,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
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
          lastDate: DateTime.now(),
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
                date == null ? label : '${label}: ${date.toString().split(' ')[0]}',
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
  String _getStatusDisplayName(BuildContext context, MaintenanceRequestStatus status) {
    switch (status) {
      case MaintenanceRequestStatus.pending:
        return AppLocalizations.of(context)!.pending;
      case MaintenanceRequestStatus.inProgress:
        return AppLocalizations.of(context)!.inProgress;
      case MaintenanceRequestStatus.completed:
        return AppLocalizations.of(context)!.completed;
    }
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

