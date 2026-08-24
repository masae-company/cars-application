import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/vehicle_model.dart';
import '../providers/oil_change_progress_provider.dart';
import '../../core/constants/route_names.dart';
import '../../core/theme/app_colors.dart';

class VehicleCard extends ConsumerWidget {
  final VehicleModel vehicle;

  const VehicleCard({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 180, // Increased height to show more info
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            context.go('${RouteNames.vehicles}/${vehicle.id}');
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row: Plate number and badges
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Plate Number
                    Expanded(
                      child: Text(
                        vehicle.number,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.onBackground,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Badges
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                         // Accident Badge
                        if (vehicle.isAccident)
                          _buildBadge(
                            'Accident', // Localization could be passed but for card concise 'Accident' is fine or icon
                            AppColors.error,
                            Icons.warning_amber_rounded,
                          ),
                        
                        // Status Badge (if not active, since active is default/implied)
                        if (vehicle.status != VehicleStatus.active)
                           _buildBadge(
                            _getShortStatus(vehicle.status), // Helper needed or inline map
                            _getStatusColor(vehicle.status),
                            _getStatusIcon(vehicle.status),
                          ),
                          
                        if (vehicle.isNew)
                          _buildBadge(
                            'New',
                            AppColors.success,
                            Icons.new_releases,
                          ),
                        if (vehicle.location != null)
                          _buildBadge(
                            vehicle.location!.displayName,
                            AppColors.info,
                            Icons.location_on,
                          ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Vehicle details row
                Row(
                  children: [
                    // Make & Model
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (vehicle.formattedMake != null)
                            Text(
                              vehicle.formattedMake!,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.onSurfaceVariant,
                                    fontSize: 11,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          Text(
                            vehicle.formattedModel,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.onBackground,
                                  fontWeight: FontWeight.w600,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    // Year & Color
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (vehicle.year != null)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 12,
                                color: AppColors.onSurfaceVariant,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                vehicle.year.toString(),
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.onSurfaceVariant,
                                      fontSize: 11,
                                    ),
                              ),
                            ],
                          ),
                        if (vehicle.color != null && vehicle.color!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.palette,
                                  size: 12,
                                  color: AppColors.onSurfaceVariant,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  vehicle.formattedColor!,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: AppColors.onSurfaceVariant,
                                        fontSize: 11,
                                      ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Oil progress indicator with real data
                _buildOilProgress(context, ref),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOilProgress(BuildContext context, WidgetRef ref) {
    final oilProgressAsync = ref.watch(oilChangeProgressProvider(vehicle.id));
    
    return oilProgressAsync.when(
      data: (oilProgress) {
        if (oilProgress == null) {
          // No oil tracking data
          return _buildNoOilTracking(context);
        }

        final progress = oilProgress.progress;
        final isOverdue = oilProgress.isOverdue;
        final isDueSoon = progress >= 0.8 && !isOverdue;
        
        // Determine color based on status
        Color progressColor;
        if (isOverdue) {
          progressColor = AppColors.error;
        } else if (isDueSoon) {
          progressColor = AppColors.warning;
        } else {
          progressColor = AppColors.success;
        }

        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                progressColor.withOpacity(0.1),
                progressColor.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: progressColor.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: progressColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(
                          Icons.oil_barrel,
                          size: 16,
                          color: progressColor,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Oil Change',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.onBackground,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                          ),
                          Text(
                            isOverdue
                                ? '${oilProgress.overdueKilometers} km overdue'
                                : '${oilProgress.remainingKilometers} km remaining',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: progressColor,
                                  fontSize: 10,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: progressColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${(progress * 100).toInt()}%',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: progressColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.onSurfaceVariant.withOpacity(0.1),
                  ),
                  child: Stack(
                    children: [
                      FractionallySizedBox(
                        widthFactor: progress.clamp(0.0, 1.0),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                progressColor,
                                progressColor.withOpacity(0.7),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => _buildOilTrackingLoading(context),
      error: (_, __) => _buildNoOilTracking(context),
    );
  }

  Widget _buildNoOilTracking(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.onSurfaceVariant.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.onSurfaceVariant.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.oil_barrel_outlined,
            size: 16,
            color: AppColors.onSurfaceVariant.withOpacity(0.5),
          ),
          const SizedBox(width: 8),
          Text(
            'No oil tracking',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 11,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildOilTrackingLoading(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.onSurfaceVariant.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation(AppColors.onSurfaceVariant.withOpacity(0.5)),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Loading...',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 11,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String label, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: color),
          const SizedBox(width: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
  // Helper methods for status display on card
  String _getShortStatus(VehicleStatus status) {
    // Return short English string or could use context for localized if needed
    // Keeping it simple/icon-based for card might be better
    switch (status) {
      case VehicleStatus.active: return 'Active';
      case VehicleStatus.workshop: return 'Workshop';
      case VehicleStatus.insurance: return 'Insurance';
    }
  }

  Color _getStatusColor(VehicleStatus status) {
    switch (status) {
      case VehicleStatus.active: return AppColors.success;
      case VehicleStatus.workshop: return AppColors.warning;
      case VehicleStatus.insurance: return AppColors.info;
    }
  }

  IconData _getStatusIcon(VehicleStatus status) {
    switch (status) {
      case VehicleStatus.active: return Icons.check_circle;
      case VehicleStatus.workshop: return Icons.build;
      case VehicleStatus.insurance: return Icons.verified_user;
    }
  }
}

