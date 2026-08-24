import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:file_picker/file_picker.dart';
import '../models/allocation_model.dart';
import '../models/allocation_status.dart';
import '../repositories/allocation_repository.dart';
import '../../auth/providers/auth_provider.dart';
import '../../auth/providers/user_provider.dart';
import '../../expenses/repositories/expense_repository.dart';
import '../../core/utils/validators.dart';
import '../../core/theme/app_colors.dart';

class AllocationRequestScreen extends ConsumerStatefulWidget {
  final String? vehicleId;

  const AllocationRequestScreen({super.key, this.vehicleId});

  @override
  ConsumerState<AllocationRequestScreen> createState() =>
      _AllocationRequestScreenState();
}

class _AllocationRequestScreenState
    extends ConsumerState<AllocationRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _amountController;
  late TextEditingController _descriptionController;
  String? _selectedEmployeeId;
  String? _receiptPath;
  String? _receiptUrl;
  List<int>? _receiptBytes;
  bool _isLoading = false;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickReceipt() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null && result.files.single.bytes != null) {
      setState(() {
        _receiptPath = result.files.single.name;
        _receiptBytes = result.files.single.bytes;
        _isUploading = true;
      });

      try {
        // Upload receipt
        final fileName =
            'allocation_${DateTime.now().millisecondsSinceEpoch}_${result.files.single.name}';
        final repository = ExpenseRepository();
        // Note: You'll need to update uploadReceipt to accept bytes instead of path
        // For now, this will need to be updated in the repository
        final url = await repository.uploadReceiptBytes(_receiptBytes!, fileName);

        setState(() {
          _receiptUrl = url;
          _isUploading = false;
        });
      } catch (e) {
        setState(() {
          _isUploading = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error uploading receipt: $e')),
          );
        }
      }
    }
  }


  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final currentUser = ref.read(authProvider).value;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be logged in')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Parse amount
      final amount = double.tryParse(_amountController.text.trim()) ?? 0.0;
      if (amount <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid amount')),
        );
        return;
      }

      if (_selectedEmployeeId == null || _selectedEmployeeId!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select an employee')),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final allocation = AllocationModel(
        id: '',
        vehicleId: amount.toStringAsFixed(2), // Store amount in vehicleId field temporarily
        allocatedTo: _selectedEmployeeId!,
        requestedBy: currentUser.id,
        status: AllocationStatus.handedOver,
        requestDate: DateTime.now(),
        handoverDate: DateTime.now(),
        handoverNotes: _descriptionController.text.trim().isEmpty 
            ? null 
            : _descriptionController.text.trim(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Create allocation with receipt URL
      // We need to call repository directly to pass receiptUrl
      // Since createAllocationProvider doesn't support receiptUrl parameter
      final repository = AllocationRepository();
      await repository.createAllocation(allocation, receiptUrl: _receiptUrl);

      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Allocation given successfully')),
        );
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
        title: const Text('Give Allocation'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount *',
                  prefixText: '\$',
                  hintText: '0.00',
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  final amount = double.tryParse(value);
                  if (amount == null || amount <= 0) {
                    return 'Please enter a valid amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildEmployeeDropdown(context),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Optional description or notes',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              _buildReceiptUpload(context),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _handleSubmit,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Create Allocation'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmployeeDropdown(BuildContext context) {
    final usersAsync = ref.watch(allUsersProvider);

    return usersAsync.when(
      data: (users) {
        return DropdownButtonFormField<String>(
          value: _selectedEmployeeId,
          decoration: const InputDecoration(
            labelText: 'Employee *',
            prefixIcon: Icon(Icons.person),
            border: OutlineInputBorder(),
          ),
          items: users.map((user) {
            return DropdownMenuItem<String>(
              value: user.id,
              child: Text(user.name ?? user.email),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedEmployeeId = value;
            });
          },
          validator: (value) =>
              Validators.required(value, fieldName: 'Employee'),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Text('Error loading employees: $error'),
    );
  }

  Widget _buildReceiptUpload(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Receipt (Optional)',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: _isUploading ? null : _pickReceipt,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.onSurfaceVariant.withOpacity(0.3),
              ),
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.receipt,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _isUploading
                      ? const Text('Uploading...')
                      : Text(
                          _receiptPath != null
                              ? 'Receipt selected: ${_receiptPath!.split('/').last}'
                              : 'Tap to select receipt image',
                          style: TextStyle(
                            color: _receiptPath != null
                                ? AppColors.onBackground
                                : AppColors.onSurfaceVariant,
                          ),
                        ),
                ),
                if (_receiptPath != null && !_isUploading)
                  IconButton(
                    icon: const Icon(Icons.clear, size: 20),
                    onPressed: () {
                      setState(() {
                        _receiptPath = null;
                        _receiptUrl = null;
                      });
                    },
                  ),
              ],
            ),
          ),
        ),
        if (_receiptUrl != null && _receiptUrl!.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            'Receipt uploaded successfully',
            style: TextStyle(
              color: AppColors.success,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }
}

