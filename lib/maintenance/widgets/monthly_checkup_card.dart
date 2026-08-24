import 'package:flutter/material.dart';
import '../models/monthly_checkup_model.dart';
import '../../core/utils/date_formatters.dart';

class MonthlyCheckupCard extends StatelessWidget {
  final MonthlyCheckupModel checkup;
  final VoidCallback? onTap;

  const MonthlyCheckupCard({
    super.key,
    required this.checkup,
    this.onTap,
  });

  int _getCompletedItemsCount() {
    int count = 0;
    if (checkup.engineOilReplaced) count++;
    if (checkup.engineAirFilterInspected) count++;
    if (checkup.engineAirFilterReplaced) count++;
    if (checkup.acAirFilterInspected) count++;
    if (checkup.automaticTransmissionFluidInspected) count++;
    if (checkup.manualTransmissionFluidInspected) count++;
    if (checkup.differentialFluidInspected) count++;
    if (checkup.sparkPlugsInspected) count++;
    if (checkup.coolantLevelInspected) count++;
    if (checkup.coolantConditionInspected) count++;
    if (checkup.brakeClutchFluidInspected) count++;
    if (checkup.fluidLeaksInspected) count++;
    if (checkup.radiatorHosesInspected) count++;
    if (checkup.driveShaftsBootsInspected) count++;
    if (checkup.fuelFilterInspected) count++;
    if (checkup.suspensionInspected) count++;
    if (checkup.shockAbsorberInspected) count++;
    if (checkup.suspensionRetightened) count++;
    if (checkup.engineSupportInspected) count++;
    if (checkup.driveBeltPulleysInspected) count++;
    if (checkup.brakeLinesInspected) count++;
    if (checkup.brakePadsInspected) count++;
    if (checkup.parkBrakeInspected) count++;
    if (checkup.tiresInspected) count++;
    if (checkup.exhaustSystemInspected) count++;
    if (checkup.tiresRotated) count++;
    if (checkup.lightsInspected) count++;
    if (checkup.batteryInspected) count++;
    if (checkup.acOperationInspected) count++;
    if (checkup.wipersInspected) count++;
    if (checkup.diagnosticToolsUsed) count++;
    if (checkup.oilServiceReset) count++;
    return count;
  }

  @override
  Widget build(BuildContext context) {
    final isCompleted = checkup.completedAt != null;
    final completedItems = _getCompletedItemsCount();

    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Monthly Checkup',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Car ID: ${checkup.carId.substring(0, 8)}...',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? Colors.green.withOpacity(0.2)
                          : Colors.orange.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isCompleted ? Colors.green : Colors.orange,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      isCompleted ? 'Completed' : 'Pending',
                      style: TextStyle(
                        color: isCompleted ? Colors.green : Colors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Checkup Date: ${DateFormatters.formatDisplayDate(checkup.checkupDate)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.person,
                    size: 16,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'Performed by: ${checkup.performedBy}',
                      style: Theme.of(context).textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              if (checkup.completedAt != null) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 16,
                      color: Colors.green,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Completed: ${DateFormatters.formatDisplayDate(checkup.completedAt!)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.green,
                          ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.checklist,
                    size: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: completedItems / 33, // Total possible items
                      backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isCompleted
                            ? Colors.green
                            : Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$completedItems/33',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              if (checkup.notes != null && checkup.notes!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  checkup.notes!,
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}


