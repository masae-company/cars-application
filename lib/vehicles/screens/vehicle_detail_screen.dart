import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/vehicle_provider.dart';
import '../models/vehicle_model.dart';
import '../providers/oil_change_progress_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../core/constants/route_names.dart';
import '../../core/utils/date_formatters.dart';
import '../../core/widgets/loading_indicator.dart';
import '../../core/theme/app_colors.dart';

class VehicleDetailScreen extends ConsumerWidget {
  final String vehicleId;

  const VehicleDetailScreen({super.key, required this.vehicleId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicleAsync = ref.watch(vehicleProvider(vehicleId));

    return vehicleAsync.when(
      data: (vehicle) {
        if (vehicle == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 80,
                  color: AppColors.error.withOpacity(0.5),
                ),
                const SizedBox(height: 24),
                Text(
                  AppLocalizations.of(context)!.vehicleNotFound,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.error,
                      ),
                ),
              ],
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
              vehicle.number,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withOpacity(0.8),
                  ],
                ),
              ),
            ),
            iconTheme: const IconThemeData(color: Colors.white),
            titleTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () {
                    context.push('${RouteNames.vehicles}/${vehicle.id}/edit');
                  },
                  icon: const Icon(Icons.edit, color: Colors.white),
                  tooltip: 'Edit',
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Card containing key info
                _buildHeaderInfoCard(context, vehicle),
                
                const SizedBox(height: 24),

                LayoutBuilder(
                  builder: (context, constraints) {
                    final isWideScreen = constraints.maxWidth > 900;
                    
                    if (isWideScreen) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left Column
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Consumer(
                                  builder: (context, ref, child) {
                                    final oilProgressAsync = ref.watch(oilChangeProgressProvider(vehicleId));
                                    return oilProgressAsync.when(
                                      data: (oilProgress) => _buildOilProgressCard(context, oilProgress),
                                      loading: () => _buildLoadingCard(context),
                                      error: (_, __) => const SizedBox.shrink(),
                                    );
                                  },
                                ),
                                const SizedBox(height: 24),
                                _buildQuickStatsGrid(context, vehicle),
                                const SizedBox(height: 24),
                                _buildActionButtons(context, vehicle),
                              ],
                            ),
                          ),
                          const SizedBox(width: 24),
                          // Right Column
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildDetailsCard(context, vehicle),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Consumer(
                            builder: (context, ref, child) {
                              final oilProgressAsync = ref.watch(oilChangeProgressProvider(vehicleId));
                              return oilProgressAsync.when(
                                data: (oilProgress) => _buildOilProgressCard(context, oilProgress),
                                loading: () => _buildLoadingCard(context),
                                error: (_, __) => const SizedBox.shrink(),
                              );
                            },
                          ),
                          const SizedBox(height: 24),
                          _buildQuickStatsGrid(context, vehicle),
                          const SizedBox(height: 24),
                          _buildDetailsCard(context, vehicle),
                          const SizedBox(height: 24),
                          _buildActionButtons(context, vehicle),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
      loading: () => Scaffold(
        body: Center(
          child: LoadingIndicator(
            message: AppLocalizations.of(context)!.loadingVehicle,
          ),
        ),
      ),
      error: (error, stack) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 80,
                color: AppColors.error.withOpacity(0.5),
              ),
              const SizedBox(height: 24),
              Text(
                AppLocalizations.of(context)!.errorLoadingVehicle,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.error,
                    ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: Text(
                  error.toString(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderInfoCard(BuildContext context, vehicle) {
    return _buildModernCard(
      context,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.registrationNumber,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        vehicle.number,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${vehicle.formattedMake ?? ''} ${vehicle.formattedModel}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppColors.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ],
                  ),
                ),
                // Badges
                Wrap(
                  direction: Axis.vertical,
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.end,
                  children: [
                    if (vehicle.isAccident)
                      _buildHeaderBadge(
                        AppLocalizations.of(context)!.accidentVehicle,
                        Icons.warning_amber_rounded,
                        AppColors.error,
                      ),
                    if (vehicle.isNew)
                      _buildHeaderBadge(
                        'New',
                        Icons.new_releases,
                        AppColors.success,
                      ),
                    if (vehicle.location != null)
                      _buildHeaderBadge(
                        vehicle.location!.displayName,
                        Icons.location_on,
                        AppColors.info,
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderBadge(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getVehicleStatusIcon(VehicleStatus status) {
    if (status == VehicleStatus.active) return Icons.check_circle_outline;
    if (status == VehicleStatus.workshop) return Icons.build_circle_outlined;
    if (status == VehicleStatus.insurance) return Icons.verified_user_outlined;
    return Icons.info_outline;
  }

  String _getVehicleStatusName(BuildContext context, VehicleStatus status) {
    switch (status) {
      case VehicleStatus.active:
        return AppLocalizations.of(context)!.vehicleStatusActive;
      case VehicleStatus.workshop:
        return AppLocalizations.of(context)!.vehicleStatusWorkshop;
      case VehicleStatus.insurance:
        return AppLocalizations.of(context)!.vehicleStatusInsurance;
    }
  }

  Color _getVehicleStatusColor(VehicleStatus status) {
    switch (status) {
      case VehicleStatus.active:
        return AppColors.success;
      case VehicleStatus.workshop:
        return AppColors.warning;
      case VehicleStatus.insurance:
        return AppColors.info;
    }
  }

  Widget _buildOilProgressCard(BuildContext context, oilProgress) {
    if (oilProgress == null) {
      return _buildModernCard(
        context,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.onSurfaceVariant.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.oil_barrel_outlined,
                  size: 32,
                  color: AppColors.onSurfaceVariant.withOpacity(0.5),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Oil Change Tracking',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'No tracking data available',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    final progress = oilProgress.progress;
    final isOverdue = oilProgress.isOverdue;
    final isDueSoon = progress >= 0.8 && !isOverdue;

    Color statusColor;
    String statusText;
    IconData statusIcon;

    if (isOverdue) {
      statusColor = AppColors.error;
      statusText = 'Overdue';
      statusIcon = Icons.warning;
    } else if (isDueSoon) {
      statusColor = AppColors.warning;
      statusText = 'Due Soon';
      statusIcon = Icons.schedule;
    } else {
      statusColor = AppColors.success;
      statusText = 'Good';
      statusIcon = Icons.check_circle;
    }

    return _buildModernCard(
      context,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              statusColor.withOpacity(0.1),
              statusColor.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.oil_barrel,
                        size: 28,
                        color: statusColor,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Oil Change Status',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(statusIcon, size: 16, color: statusColor),
                            const SizedBox(width: 6),
                            Text(
                              statusText,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: statusColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${(progress * 100).toInt()}%',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Progress Bar
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: 12,
                decoration: BoxDecoration(
                  color: AppColors.onSurfaceVariant.withOpacity(0.1),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: progress.clamp(0.0, 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          statusColor,
                          statusColor.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Stats Row
            Row(
              children: [
                Expanded(
                  child: _buildOilStat(
                    context,
                    'Current',
                    '${oilProgress.currentKilometers} km',
                    Icons.speed,
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: AppColors.onSurfaceVariant.withOpacity(0.2),
                ),
                Expanded(
                  child: _buildOilStat(
                    context,
                    isOverdue ? 'Overdue' : 'Remaining',
                    isOverdue
                        ? '${oilProgress.overdueKilometers} km'
                        : '${oilProgress.remainingKilometers} km',
                    isOverdue ? Icons.warning_amber : Icons.route,
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: AppColors.onSurfaceVariant.withOpacity(0.2),
                ),
                Expanded(
                  child: _buildOilStat(
                    context,
                    'Next Change',
                    '${oilProgress.nextOilChangeKilometers} km',
                    Icons.flag,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOilStat(BuildContext context, String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 20, color: AppColors.onSurfaceVariant),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.onSurfaceVariant,
                fontSize: 11,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  Widget _buildQuickStatsGrid(BuildContext context, vehicle) {
    return Row(
      children: [
        if (vehicle.year != null)
          Expanded(
            child: _buildStatCard(
              context,
              'Year',
              vehicle.year.toString(),
              Icons.calendar_today,
              AppColors.info,
            ),
          ),
        if (vehicle.year != null && vehicle.color != null) const SizedBox(width: 16),
        if (vehicle.color != null)
          Expanded(
            child: _buildStatCard(
              context,
              'Color',
              vehicle.color!,
              Icons.palette,
              AppColors.secondary,
            ),
          ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return _buildModernCard(
      context,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 28, color: color),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsCard(BuildContext context, vehicle) {
    return _buildModernCard(
      context,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vehicle Information',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),
            _buildDetailRow(
              context,
              Icons.confirmation_number,
              AppLocalizations.of(context)!.registrationNumber,
              vehicle.number,
            ),
            _buildDivider(),
            _buildDetailRow(
              context,
              Icons.local_offer,
              AppLocalizations.of(context)!.model,
              vehicle.model,
            ),
            if (vehicle.formattedMake != null) ...[
              _buildDivider(),
              _buildDetailRow(
                context,
                Icons.directions_car,
                AppLocalizations.of(context)!.make,
                vehicle.formattedMake!,
              ),
            ],
            if (vehicle.location != null) ...[
              _buildDivider(),
              _buildDetailRow(
                context,
                Icons.location_on,
                AppLocalizations.of(context)!.location,
                vehicle.location!.displayName,
              ),
            ],
            _buildDivider(),
            _buildDetailRow(
              context,
              _getVehicleStatusIcon(vehicle.status),
              AppLocalizations.of(context)!.status,
              _getVehicleStatusName(context, vehicle.status),
              valueColor: _getVehicleStatusColor(vehicle.status),
            ),
            if (vehicle.isAccident) ...[
               _buildDivider(),
               Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 24),
                        const SizedBox(width: 8),
                        Text(
                          AppLocalizations.of(context)!.accidentReport,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.error,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow(
                      context,
                      Icons.percent,
                      AppLocalizations.of(context)!.deductiblePercentage,
                      '${vehicle.accidentDeductibleRate ?? 0}%',
                    ),
                    if (vehicle.description != null && vehicle.description!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.error.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.error.withOpacity(0.1)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Accident Description', // TODO: Localize if needed, currently reusing user request term
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: AppColors.error,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              vehicle.description!,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.onBackground,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    if (vehicle.accidentReportUrl != null) ...[
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () async {
                             final uri = Uri.parse(vehicle.accidentReportUrl!);
                             if (await canLaunchUrl(uri)) {
                               await launchUrl(uri);
                             } else {
                               if (context.mounted) {
                                 ScaffoldMessenger.of(context).showSnackBar(
                                   SnackBar(content: Text('Could not launch ${vehicle.accidentReportUrl}')),
                                 );
                               }
                             }
                          }, 
                          icon: const Icon(Icons.picture_as_pdf, size: 18),
                          label: Text(AppLocalizations.of(context)!.viewReport),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: BorderSide(color: AppColors.primary.withOpacity(0.5)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
               ),
            ],
            _buildDivider(),
            _buildDetailRow(
              context,
              Icons.access_time,
              AppLocalizations.of(context)!.created,
              DateFormatters.formatDisplayDate(vehicle.createdAt),
            ),
            _buildDivider(),
            _buildDetailRow(
              context,
              Icons.update,
              AppLocalizations.of(context)!.lastUpdated,
              DateFormatters.formatDisplayDate(vehicle.updatedAt),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    IconData icon,
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: valueColor ?? AppColors.onBackground,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      color: AppColors.onSurfaceVariant.withOpacity(0.1),
    );
  }

  Widget _buildActionButtons(BuildContext context, vehicle) {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            context,
            'Maintenance History', // TODO: Localize if needed
            Icons.history,
            AppColors.info,
            () {
              context.push(RouteNames.maintenanceHistory);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return _buildModernCard(
      context,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 12),
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernCard(BuildContext context, {required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildLoadingCard(BuildContext context) {
    return _buildModernCard(
      context,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 20),
            Text(
              'Loading oil change data...',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
