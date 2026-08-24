import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:file_picker/file_picker.dart';
import '../models/expense_model.dart';
import '../providers/expense_provider.dart';
import '../repositories/expense_repository.dart';
import '../../auth/providers/auth_provider.dart';
import '../../core/utils/validators.dart';

class ExpenseFormScreen extends ConsumerStatefulWidget {
  final ExpenseModel? expense;

  const ExpenseFormScreen({super.key, this.expense});

  @override
  ConsumerState<ExpenseFormScreen> createState() => _ExpenseFormScreenState();
}

class _ExpenseFormScreenState extends ConsumerState<ExpenseFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _amountController;
  late TextEditingController _descriptionController;
  late TextEditingController _employeeIdController;
  late TextEditingController _allocationIdController;
  late TextEditingController _categoryController;
  late TextEditingController _transactionDateController;
  TransactionType _transactionType = TransactionType.expense;
  DateTime? _transactionDate;
  String? _receiptPath;
  List<int>? _receiptBytes;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final expense = widget.expense;
    _amountController =
        TextEditingController(text: expense?.amount.toString() ?? '');
    _descriptionController =
        TextEditingController(text: expense?.description ?? '');
    _employeeIdController =
        TextEditingController(text: expense?.employeeId ?? '');
    _allocationIdController =
        TextEditingController(text: expense?.allocationId ?? '');
    _categoryController =
        TextEditingController(text: expense?.category ?? '');
    _transactionDateController = TextEditingController();
    _transactionType = expense?.transactionType ?? TransactionType.expense;
    _transactionDate = expense?.transactionDate ?? DateTime.now();
    _transactionDateController.text = _transactionDate != null
        ? '${_transactionDate!.year}-${_transactionDate!.month.toString().padLeft(2, '0')}-${_transactionDate!.day.toString().padLeft(2, '0')}'
        : '';
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _employeeIdController.dispose();
    _allocationIdController.dispose();
    _categoryController.dispose();
    _transactionDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _transactionDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _transactionDate = picked;
        _transactionDateController.text =
            '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      });
    }
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null && result.files.single.bytes != null) {
      setState(() {
        _receiptPath = result.files.single.name;
        _receiptBytes = result.files.single.bytes;
      });
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_transactionDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a transaction date')),
      );
      return;
    }

    if (_employeeIdController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Employee ID is required')),
      );
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
      String? receiptUrl;
      if (_receiptBytes != null && _receiptPath != null) {
        // Upload receipt using bytes (web-compatible)
        final fileName = 'expense_${DateTime.now().millisecondsSinceEpoch}_$_receiptPath';
        final repository = ExpenseRepository();
        receiptUrl = await repository.uploadReceiptBytes(_receiptBytes!, fileName);
      }

      final expense = ExpenseModel(
        id: widget.expense?.id ?? '',
        transactionType: _transactionType,
        amount: double.parse(_amountController.text),
        description: _descriptionController.text.isEmpty
            ? 'No description'
            : _descriptionController.text.trim(),
        employeeId: _employeeIdController.text.trim(),
        createdBy: currentUser.id,
        receiptUrl: receiptUrl ?? widget.expense?.receiptUrl,
        category: _categoryController.text.isEmpty
            ? null
            : _categoryController.text.trim(),
        transactionDate: _transactionDate!,
        allocationId: _allocationIdController.text.isEmpty
            ? null
            : _allocationIdController.text.trim(),
        createdAt: widget.expense?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      if (widget.expense != null) {
        await ref.read(updateExpenseProvider(expense).future);
      } else {
        await ref.read(createExpenseProvider(expense).future);
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
        title: Text(widget.expense == null ? 'Add Expense' : 'Edit Expense'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<TransactionType>(
                value: _transactionType,
                decoration: const InputDecoration(
                  labelText: 'Transaction Type *',
                ),
                items: TransactionType.values.map((type) {
                  return DropdownMenuItem<TransactionType>(
                    value: type,
                    child: Text(type.displayName),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _transactionType = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount *',
                  prefixText: '\$',
                ),
                keyboardType: TextInputType.number,
                validator: (value) => Validators.positiveNumber(
                  value,
                  fieldName: 'Amount',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _employeeIdController,
                decoration: const InputDecoration(
                  labelText: 'Employee ID *',
                ),
                validator: (value) =>
                    Validators.required(value, fieldName: 'Employee ID'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _transactionDateController,
                decoration: const InputDecoration(
                  labelText: 'Transaction Date *',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: _selectDate,
                validator: (value) => Validators.required(
                  value,
                  fieldName: 'Transaction Date',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(
                  labelText: 'Category (optional)',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _allocationIdController,
                decoration: const InputDecoration(
                  labelText: 'Allocation ID (optional)',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description *',
                ),
                maxLines: 3,
                validator: (value) =>
                    Validators.required(value, fieldName: 'Description'),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _pickFile,
                icon: const Icon(Icons.upload_file),
                label: Text(_receiptPath != null
                    ? 'Receipt Selected'
                    : 'Upload Receipt'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _handleSubmit,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(widget.expense == null ? 'Create' : 'Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
