import 'package:flutter/material.dart';
import '../models/allocation_status.dart';
import '../../core/theme/app_colors.dart';

class AllocationStatusChip extends StatelessWidget {
  final AllocationStatus status;

  const AllocationStatusChip({super.key, required this.status});

  Color get _statusColor {
    switch (status) {
      case AllocationStatus.pending:
        return AppColors.allocationPending;
      case AllocationStatus.approved:
        return AppColors.allocationApproved;
      case AllocationStatus.handedOver:
        return AppColors.allocationHandedOver;
      case AllocationStatus.returned:
        return AppColors.allocationReturned;
      case AllocationStatus.cancelled:
        return AppColors.allocationCancelled;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        status.displayName,
        style: const TextStyle(fontSize: 12),
      ),
      backgroundColor: _statusColor.withOpacity(0.2),
      labelStyle: TextStyle(color: _statusColor),
      side: BorderSide(color: _statusColor),
    );
  }
}


