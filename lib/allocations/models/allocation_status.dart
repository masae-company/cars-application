enum AllocationStatus {
  pending,
  approved,
  handedOver,
  returned,
  cancelled;

  static AllocationStatus? fromString(String? value) {
    if (value == null) return null;
    try {
      return AllocationStatus.values.firstWhere(
        (status) => status.name.toLowerCase().replaceAll('_', '') ==
            value.toLowerCase().replaceAll('_', ''),
      );
    } catch (e) {
      return null;
    }
  }

  String get displayName {
    switch (this) {
      case AllocationStatus.pending:
        return 'Pending';
      case AllocationStatus.approved:
        return 'Approved';
      case AllocationStatus.handedOver:
        return 'Handed Over';
      case AllocationStatus.returned:
        return 'Returned';
      case AllocationStatus.cancelled:
        return 'Cancelled';
    }
  }
}


