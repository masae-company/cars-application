import 'package:flutter/material.dart';
import '../models/maintenance_request_model.dart';
import '../../core/utils/date_formatters.dart' as date_utils;

class MaintenanceRequestCard extends StatelessWidget {
  final MaintenanceRequestModel request;
  final VoidCallback? onTap;

  const MaintenanceRequestCard({
    super.key,
    required this.request,
    this.onTap,
  });

  Color _getStatusColor(MaintenanceRequestStatus status) {
    switch (status) {
      case MaintenanceRequestStatus.pending:
        return Colors.orange;
      case MaintenanceRequestStatus.inProgress:
        return Colors.blue;
      case MaintenanceRequestStatus.completed:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    final services = <String>[];
    if (request.oilChangePreviousKm != null || request.oilChangeCurrentKm != null) {
      services.add('Oil Change');
    }
    if (request.brakePadsLastChanged != null) services.add('Brake Pads');
    if (request.sparkPlugsLastChanged != null) services.add('Spark Plugs');
    if (request.tyresLastChanged != null) services.add('Tyres');
    if (request.acService) services.add('AC Service');
    if (request.lightsService) services.add('Lights');
    if (request.tyreStackingService) services.add('Tyre Stacking');

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
                          'Request #${request.id.substring(0, 8)}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Car ID: ${request.carId.substring(0, 8)}...',
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
                      color: _getStatusColor(request.status).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _getStatusColor(request.status),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      request.status.displayName,
                      style: TextStyle(
                        color: _getStatusColor(request.status),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (services.isNotEmpty) ...[
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: services.map((service) {
                    return Chip(
                      label: Text(service),
                      labelStyle: const TextStyle(fontSize: 12),
                      padding: EdgeInsets.zero,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 8),
              ],
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Requested: ${date_utils.DateFormatters.formatDate(request.requestedAt)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              if (request.completedAt != null) ...[
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
                      'Completed: ${date_utils.DateFormatters.formatDate(request.completedAt!)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.green,
                          ),
                    ),
                  ],
                ),
              ],
              if (request.oilChangeCurrentKm != null) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.speed,
                      size: 16,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Oil Change KM: ${request.oilChangeCurrentKm}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

