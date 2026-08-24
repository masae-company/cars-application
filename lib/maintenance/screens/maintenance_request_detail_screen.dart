import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:exui/exui.dart';
import '../models/maintenance_request_model.dart';
import '../providers/maintenance_request_provider.dart';
import '../../core/widgets/loading_indicator.dart';
import '../../core/utils/date_formatters.dart' as date_utils;
import '../../auth/providers/auth_provider.dart';
import '../../auth/models/user_model.dart';
import '../../core/theme/app_colors.dart';
import '../../core/config/supabase_config.dart';
import '../../core/config/database_schema.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Helper function to get car info for display
Future<Map<String, dynamic>?> _getCarInfo(String carId) async {
  try {
    final response = await SupabaseConfig.client
        .from(DatabaseSchema.cars)
        .select('${DatabaseSchema.model}, ${DatabaseSchema.number}')
        .eq(DatabaseSchema.id, carId)
        .maybeSingle();
    return response;
  } catch (e) {
    return null;
  }
}

class MaintenanceRequestDetailScreen extends ConsumerWidget {
  final String requestId;

  const MaintenanceRequestDetailScreen({
    super.key,
    required this.requestId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestAsync = ref.watch(maintenanceRequestProvider(requestId));
    final userRole = ref.watch(authProvider).value?.role ?? UserRole.employee;

    return requestAsync.when(
      data: (request) {
        if (request == null) {
          return Center(
            child: Text(
              AppLocalizations.of(context)!.maintenanceRequestNotFound,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card with Status
              _ModernCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 4,
                          height: 48,
                          decoration: BoxDecoration(
                            color: _getStatusColor(request.status),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Request #${request.id.substring(0, 8)}',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: -0.5,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              FutureBuilder<Map<String, dynamic>?>(
                                future: _getCarInfo(request.carId),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Text(
                                      AppLocalizations.of(context)!.loadingCarInfo,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: AppColors.onSurfaceVariant,
                                          ),
                                    );
                                  }
                                  final carInfo = snapshot.data;
                                  return Text(
                                    carInfo != null
                                        ? '${carInfo[DatabaseSchema.model] ?? 'N/A'} • ${carInfo[DatabaseSchema.number] ?? 'N/A'}'
                                        : AppLocalizations.of(context)!.carId(request.carId.substring(0, 8)),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: AppColors.onSurfaceVariant,
                                        ),
                                  );
                                },
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
                            color: _getStatusColor(request.status)
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: _getStatusColor(request.status),
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            _getStatusDisplayName(context, request.status),
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                  color: _getStatusColor(request.status),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ).padding(const EdgeInsets.all(20)),
              ),
              const SizedBox(height: 16),

              // Timeline Card
              _ModernCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.timeline,
                          size: 20,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          AppLocalizations.of(context)!.timeline,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildTimelineItem(
                      context,
                      icon: Icons.schedule,
                      label: 'Requested',
                      value: date_utils.DateFormatters.formatDisplayDateTime(
                        request.requestedAt,
                      ),
                      isActive: true,
                    ),
                    if (request.inProgressAt != null)
                      _buildTimelineItem(
                        context,
                        icon: Icons.play_circle_outline,
                        label: 'In Progress',
                        value: date_utils.DateFormatters.formatDisplayDateTime(
                          request.inProgressAt!,
                        ),
                        isActive: true,
                        color: AppColors.info,
                      ),
                    if (request.completedAt != null)
                      _buildTimelineItem(
                        context,
                        icon: Icons.check_circle_outline,
                        label: 'Completed',
                        value: date_utils.DateFormatters.formatDisplayDateTime(
                          request.completedAt!,
                        ),
                        isActive: true,
                        color: AppColors.success,
                      ),
                  ],
                ).padding(const EdgeInsets.all(20)),
              ),
              const SizedBox(height: 16),

              // Services Card
              _ModernCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.build_circle_outlined,
                          size: 20,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          AppLocalizations.of(context)!.servicesRequested,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        if (request.oilChangePreviousKm != null ||
                            request.oilChangeCurrentKm != null)
                          _buildServiceChip(context, AppLocalizations.of(context)!.oilChange),
                        if (request.brakePadsLastChanged != null)
                          _buildServiceChip(context, AppLocalizations.of(context)!.brakePads),
                        if (request.sparkPlugsLastChanged != null)
                          _buildServiceChip(context, AppLocalizations.of(context)!.sparkPlugs),
                        if (request.tyresLastChanged != null)
                          _buildServiceChip(context, AppLocalizations.of(context)!.tyres),
                        if (request.acService)
                          _buildServiceChip(context, AppLocalizations.of(context)!.acService),
                        if (request.lightsService)
                          _buildServiceChip(context, AppLocalizations.of(context)!.lightsService),
                        if (request.tyreStackingService)
                          _buildServiceChip(context, AppLocalizations.of(context)!.tyreStackingService),
                      ],
                    ),
                  ],
                ).padding(const EdgeInsets.all(20)),
              ),

              // Oil Change Info Card
              if (_hasOilChangeInfo(request)) ...[
                const SizedBox(height: 16),
                _ModernCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.oil_barrel_outlined,
                            size: 20,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            AppLocalizations.of(context)!.oilChangeInformation,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (request.oilChangePreviousKm != null)
                        _buildInfoItem(
                          context,
                          icon: Icons.speed_outlined,
                          label: 'Previous KM',
                          value: '${request.oilChangePreviousKm} km',
                        ),
                      if (request.oilChangeCurrentKm != null)
                        _buildInfoItem(
                          context,
                          icon: Icons.speed,
                          label: 'Current KM',
                          value: '${request.oilChangeCurrentKm} km',
                        ),
                    ],
                  ).padding(const EdgeInsets.all(20)),
                ),
              ],

              // Notes Card
              if (request.notes != null && request.notes!.isNotEmpty) ...[
                const SizedBox(height: 16),
                _ModernCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.note_outlined,
                            size: 20,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            AppLocalizations.of(context)!.notes,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceVariant
                              .withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          request.notes!,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ).padding(const EdgeInsets.all(20)),
                ),
              ],

              // Actions Card
              if (userRole.canManageMaintenanceRequests &&
                  request.status != MaintenanceRequestStatus.completed) ...[
                const SizedBox(height: 16),
                _ModernCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.settings_outlined,
                            size: 20,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            AppLocalizations.of(context)!.actions,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (request.status == MaintenanceRequestStatus.pending)
                        _buildActionButton(
                          context,
                          ref,
                          request,
                          label: AppLocalizations.of(context)!.startWork,
                          icon: Icons.play_arrow,
                          color: AppColors.info,
                          status: MaintenanceRequestStatus.inProgress,
                        ),
                      if (request.status == MaintenanceRequestStatus.inProgress)
                        _buildActionButton(
                          context,
                          ref,
                          request,
                          label: AppLocalizations.of(context)!.markAsCompleted,
                          icon: Icons.check_circle,
                          color: AppColors.success,
                          status: MaintenanceRequestStatus.completed,
                        ),
                    ],
                  ).padding(const EdgeInsets.all(20)),
                ),
              ],
            ],
          ),
        );
      },
      loading: () => LoadingIndicator(
        message: AppLocalizations.of(context)!.loadingMaintenanceRequest,
      ),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: AppColors.error,
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.errorLoadingRequest,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.error,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              '$error',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                ref.invalidate(maintenanceRequestProvider(requestId));
              },
              icon: const Icon(Icons.refresh),
              label: Text(AppLocalizations.of(context)!.retry),
            ),
          ],
        ),
      ),
    );
  }

  bool _hasOilChangeInfo(MaintenanceRequestModel request) {
    return request.oilChangePreviousKm != null ||
        request.oilChangeCurrentKm != null;
  }

  Widget _buildTimelineItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required bool isActive,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (color ?? AppColors.onSurfaceVariant)
                  .withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 18,
              color: color ?? AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 12,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: color ?? AppColors.onSurface,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: AppColors.onSurfaceVariant,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 12,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceChip(BuildContext context, String service) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.build,
            size: 14,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 6),
          Text(
            service,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    WidgetRef ref,
    MaintenanceRequestModel request, {
    required String label,
    required IconData icon,
    required Color color,
    required MaintenanceRequestStatus status,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _updateStatus(context, ref, request, status),
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
      ),
    );
  }

  Color _getStatusColor(MaintenanceRequestStatus status) {
    switch (status) {
      case MaintenanceRequestStatus.pending:
        return AppColors.warning;
      case MaintenanceRequestStatus.inProgress:
        return AppColors.info;
      case MaintenanceRequestStatus.completed:
        return AppColors.success;
    }
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

  Future<void> _updateStatus(
    BuildContext context,
    WidgetRef ref,
    MaintenanceRequestModel request,
    MaintenanceRequestStatus newStatus,
  ) async {
    try {
      final repository = ref.read(maintenanceRequestRepositoryProvider);
      await repository.updateMaintenanceRequestStatus(request.id, newStatus);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 8),
                Text(AppLocalizations.of(context)!.statusUpdatedTo(_getStatusDisplayName(context, newStatus))),
              ],
            ),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
        ref.invalidate(maintenanceRequestProvider(requestId));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(AppLocalizations.of(context)!.errorUpdatingStatus(e.toString())),
                ),
              ],
            ),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
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
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

