import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:exui/exui.dart';
import '../models/vehicle_model.dart';
import '../providers/vehicle_provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../auth/providers/user_provider.dart';
import '../../core/utils/validators.dart';
import '../../core/theme/app_colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

 class VehicleFormScreen extends ConsumerStatefulWidget {
  final VehicleModel? vehicle;

  const VehicleFormScreen({super.key, this.vehicle});

  @override
  ConsumerState<VehicleFormScreen> createState() => _VehicleFormScreenState();
}

class _VehicleFormScreenState extends ConsumerState<VehicleFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _numberController;
  late TextEditingController _modelController;
  late TextEditingController _descriptionController;
  late TextEditingController _deductibleController;
  late TextEditingController _makeController;
  late TextEditingController _colorController;
  late TextEditingController _yearController;
  CarLocation? _location;
  VehicleStatus _status = VehicleStatus.active;
  String? _selectedOwnerId;
  bool _isNew = false;
  bool _isLoading = false;
  bool _isAccident = false;
  PlatformFile? _pickedFile;
  String? _existingReportUrl;

  @override
  void initState() {
    super.initState();
    final vehicle = widget.vehicle;
    _numberController = TextEditingController(text: vehicle?.number ?? '');
    _modelController = TextEditingController(text: vehicle?.model ?? '');
    _descriptionController = TextEditingController(text: vehicle?.description ?? '');
    _deductibleController = TextEditingController(text: vehicle?.accidentDeductibleRate?.toString() ?? '');
    _makeController = TextEditingController(text: vehicle?.make ?? '');
    _colorController = TextEditingController(text: vehicle?.color ?? '');
    _yearController = TextEditingController(text: vehicle?.year?.toString() ?? '');
    _location = vehicle?.location;
    _status = vehicle?.status ?? VehicleStatus.active;
    _selectedOwnerId = vehicle?.ownerId;
    _isNew = vehicle?.isNew ?? false;
    _isAccident = vehicle?.isAccident ?? false;
    _existingReportUrl = vehicle?.accidentReportUrl;
  }

  @override
  void dispose() {
    _numberController.dispose();
    _modelController.dispose();
    _descriptionController.dispose();
    _deductibleController.dispose();
    _makeController.dispose();
    _colorController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  Future<void> _pickAccidentReport() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        withData: true,
      );

      if (result != null) {
        setState(() {
          _pickedFile = result.files.first;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.failedToPickFile(e.toString()))),
        );
      }
    }
  }

  Future<String?> _uploadAccidentReport(String vehicleId) async {
    if (_pickedFile == null) return _existingReportUrl;

    try {
      final bytes = _pickedFile!.bytes;
      if (bytes == null) return null;

      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${_pickedFile!.name}';
      final path = 'accident_reports/$vehicleId/$fileName';

      await Supabase.instance.client.storage
          .from('masae')
          .uploadBinary(path, bytes);

      final url = Supabase.instance.client.storage
          .from('masae')
          .getPublicUrl(path);
      
      return url;
    } catch (e) {
      print('Error uploading file: $e');
      // If bucket doesn't exist or other error, return null or handle appropriately
      // For now, we'll try to continue
      return null;
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final currentUser = ref.read(authProvider).value;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.youMustBeLoggedIn)),
      );
      return;
    }

    if (_selectedOwnerId == null || _selectedOwnerId!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.pleaseSelectEmployee)),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final vehicleId = widget.vehicle?.id ?? DateTime.now().millisecondsSinceEpoch.toString(); // Temporary ID if new
      
      String? reportUrl = _existingReportUrl;
      if (_isAccident && _pickedFile != null) {
        reportUrl = await _uploadAccidentReport(vehicleId);
      }

      final vehicle = VehicleModel(
        id: widget.vehicle?.id ?? '', // Correct ID handling handled by repo for create
        model: _modelController.text.trim(),
        number: _numberController.text.trim(),
        ownerId: _selectedOwnerId!,
        description: _descriptionController.text.isEmpty
            ? null
            : _descriptionController.text.trim(),
        location: _location,
        isNew: _isNew,
        status: _status,
        isAccident: _isAccident,
        accidentReportUrl: _isAccident ? reportUrl : null,
        accidentDeductibleRate: _isAccident && _deductibleController.text.isNotEmpty 
            ? int.tryParse(_deductibleController.text) 
            : null,
        createdAt: widget.vehicle?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
        make: _makeController.text.isEmpty ? null : _makeController.text.trim(),
        color: _colorController.text.isEmpty ? null : _colorController.text.trim(),
        year: _yearController.text.isEmpty ? null : int.tryParse(_yearController.text.trim()),
      );

      if (widget.vehicle != null) {
        await ref.read(updateVehicleProvider(vehicle).future);
      } else {
        await ref.read(createVehicleProvider(vehicle).future);
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.vehicle == null ? AppLocalizations.of(context)!.addVehicle : AppLocalizations.of(context)!.editVehicle),
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
                    // Registration Number
                    _buildFormField(
                      context,
                      icon: Icons.confirmation_number,
                      label: AppLocalizations.of(context)!.registrationNumber,
                      controller: _numberController,
                      validator: (value) => Validators.required(
                        value,
                        fieldName: AppLocalizations.of(context)!.registrationNumber,
                      ),
                      isRequired: true,
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Model
                    _buildFormField(
                      context,
                      icon: Icons.local_offer,
                      label: AppLocalizations.of(context)!.model,
                      controller: _modelController,
                      validator: (value) =>
                          Validators.required(value, fieldName: AppLocalizations.of(context)!.model),
                      isRequired: true,
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Make (Manufacturer)
                    _buildFormField(
                      context,
                      icon: Icons.directions_car,
                      label: 'Make',
                      controller: _makeController,
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Color
                    _buildFormField(
                      context,
                      icon: Icons.palette,
                      label: 'Color',
                      controller: _colorController,
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Year
                    _buildFormField(
                      context,
                      icon: Icons.calendar_today,
                      label: 'Year',
                      controller: _yearController,
                      validator: (value) {
                        if (value == null || value.isEmpty) return null;
                        final year = int.tryParse(value);
                        if (year == null) return 'Enter a valid year';
                        if (year < 1900 || year > DateTime.now().year + 1) {
                          return 'Enter a valid year';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Location Dropdown
                    _buildLocationDropdown(context),

                    const SizedBox(height: 24),

                    // Status Dropdown
                    _buildStatusDropdown(context),
                    
                    const SizedBox(height: 24),
                    
                    // Employee/Owner Selection
                    _buildOwnerDropdown(context),
                    
                    const SizedBox(height: 24),
                    
                    // New Vehicle Checkbox
                    _buildNewVehicleCheckbox(context),
                    
                    const SizedBox(height: 24),

                    // Accident Vehicle Checkbox
                    _buildAccidentVehicleCheckbox(context),
                    
                    const SizedBox(height: 24),
                    
                    // Description
                    _buildFormField(
                      context,
                      icon: Icons.description,
                      label: AppLocalizations.of(context)!.description,
                      controller: _descriptionController,
                      maxLines: 4,
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Submit Button
                    _buildSubmitButton(context),
                  ],
                ).padding(const EdgeInsets.all(24)),
              ),
            ).padding(const EdgeInsets.all(24)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6750A4), Color(0xFF9575CD)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.directions_car,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  Text(
                    widget.vehicle == null ? AppLocalizations.of(context)!.addNewVehicle : AppLocalizations.of(context)!.editVehicle,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.vehicle == null
                        ? AppLocalizations.of(context)!.registerNewVehicle
                        : AppLocalizations.of(context)!.updateVehicleInformation,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormField(
    BuildContext context, {
    required IconData icon,
    required String label,
    required TextEditingController controller,
    String? Function(String?)? validator,
    bool isRequired = false,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.onBackground,
                  ),
            ),
            if (isRequired) ...[
              const SizedBox(width: 4),
              Text(
                '*',
                style: TextStyle(
                  color: AppColors.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextFormField(
            controller: controller,
            validator: validator,
            maxLines: maxLines,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              filled: false,
            ),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }

  Widget _buildLocationDropdown(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.location_on, size: 20, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(
              AppLocalizations.of(context)!.location,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.onBackground,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonFormField<CarLocation?>(
            value: _location,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            items: [
              DropdownMenuItem<CarLocation?>(
                value: null,
                child: Text(AppLocalizations.of(context)!.selectLocation),
              ),
              ...CarLocation.values.map((location) {
                return DropdownMenuItem<CarLocation?>(
                  value: location,
                  child: Text(location.displayName),
                );
              }),
            ],
            onChanged: (value) {
              setState(() {
                _location = value;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStatusDropdown(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.info_outline, size: 20, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(
              AppLocalizations.of(context)!.status,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.onBackground,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonFormField<VehicleStatus>(
            value: _status,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            items: VehicleStatus.values.map((status) {
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
                child: Text(label),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _status = value;
                });
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildOwnerDropdown(BuildContext context) {
    final usersAsync = ref.watch(allUsersProvider);

    return usersAsync.when(
      data: (users) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person, size: 20, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context)!.assignedEmployee,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.onBackground,
                      ),
                ),
                const SizedBox(width: 4),
                Text(
                  '*',
                  style: TextStyle(
                    color: AppColors.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonFormField<String>(
                value: _selectedOwnerId,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
                items: users.map((user) {
                  return DropdownMenuItem<String>(
                    value: user.id,
                    child: Text(user.name ?? user.email),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedOwnerId = value;
                  });
                },
                validator: (value) =>
                    Validators.required(value, fieldName: AppLocalizations.of(context)!.assignedEmployee),
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Text(AppLocalizations.of(context)!.errorLoadingEmployees(error.toString())),
    );
  }

  Widget _buildNewVehicleCheckbox(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _isNew
              ? AppColors.success.withOpacity(0.5)
              : Colors.transparent,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.new_releases,
            color: _isNew ? AppColors.success : AppColors.onSurfaceVariant,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              AppLocalizations.of(context)!.markAsNewVehicle,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.onBackground,
                  ),
            ),
          ),
          Switch(
            value: _isNew,
            onChanged: (value) {
              setState(() {
                _isNew = value;
              });
            },
            activeColor: AppColors.success,
          ),
        ],
      ),
    );
  }

  Widget _buildAccidentVehicleCheckbox(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isAccident
                  ? AppColors.error.withOpacity(0.5)
                  : Colors.transparent,
              width: 2,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: _isAccident ? AppColors.error : AppColors.onSurfaceVariant,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.accidentVehicle,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.onBackground,
                      ),
                ),
              ),
              Switch(
                value: _isAccident,
                onChanged: (value) {
                  setState(() {
                    _isAccident = value;
                  });
                },
                activeColor: AppColors.error,
              ),
            ],
          ),
        ),
        
        if (_isAccident) ...[
          const SizedBox(height: 16),
          
          // Deductible Percentage
          _buildFormField(
            context,
            icon: Icons.percent,
            label: AppLocalizations.of(context)!.deductiblePercentage,
            controller: _deductibleController,
            validator: (value) {
              if (value == null || value.isEmpty) return null; // Optional?
              final number = int.tryParse(value);
              if (number == null) return AppLocalizations.of(context)!.enterValidNumber;
              return null;
            },
            // Since it's percentage, you might want to enforce types
          ),

          const SizedBox(height: 16),

          // PDF Attachment
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.onSurfaceVariant.withOpacity(0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.picture_as_pdf, size: 20, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text(
                      AppLocalizations.of(context)!.accidentReport,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.onBackground,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (_pickedFile != null || _existingReportUrl != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.onSurfaceVariant.withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.description, color: AppColors.error),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _pickedFile?.name ?? 'Report.pdf',
                            style: Theme.of(context).textTheme.bodyMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (_pickedFile != null)
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _pickedFile = null;
                              });
                            },
                            icon: const Icon(Icons.close, size: 20),
                            tooltip: AppLocalizations.of(context)!.removeFile,
                          ),
                      ],
                    ),
                  )
                else
                  InkWell(
                    onTap: _pickAccidentReport,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.5),
                          style: BorderStyle.solid,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        color: AppColors.primary.withOpacity(0.05),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.upload_file, size: 32, color: AppColors.primary),
                          const SizedBox(height: 8),
                          Text(
                            AppLocalizations.of(context)!.attachPdf,
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6750A4), Color(0xFF9575CD)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isLoading ? null : _handleSubmit,
          borderRadius: BorderRadius.circular(12),
          child: Center(
            child: _isLoading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        widget.vehicle == null ? Icons.add : Icons.save,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.vehicle == null ? AppLocalizations.of(context)!.createVehicle : AppLocalizations.of(context)!.updateVehicle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
          ),
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
