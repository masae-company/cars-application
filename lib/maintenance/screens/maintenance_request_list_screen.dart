import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/maintenance_request_model.dart';
import '../providers/maintenance_request_provider.dart';
import '../widgets/maintenance_request_card.dart';
import '../../core/constants/route_names.dart';
import '../../core/widgets/loading_indicator.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MaintenanceRequestListScreen extends ConsumerStatefulWidget {
  const MaintenanceRequestListScreen({super.key});

  @override
  ConsumerState<MaintenanceRequestListScreen> createState() =>
      _MaintenanceRequestListScreenState();
}

class _MaintenanceRequestListScreenState
    extends ConsumerState<MaintenanceRequestListScreen> {
  MaintenanceRequestStatus? _selectedStatus;

  @override
  Widget build(BuildContext context) {
    final params = MaintenanceRequestListParams(
      statusFilter: _selectedStatus,
    );

    final requestsAsync = ref.watch(maintenanceRequestListProvider(params));

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: DropdownButton<MaintenanceRequestStatus?>(
                  value: _selectedStatus,
                  hint: Text(AppLocalizations.of(context)!.filterByStatus),
                  items: [
                    DropdownMenuItem<MaintenanceRequestStatus?>(
                      value: null,
                      child: Text(AppLocalizations.of(context)!.allStatuses),
                    ),
                    ...MaintenanceRequestStatus.values.map(
                      (status) => DropdownMenuItem<MaintenanceRequestStatus?>(
                        value: status,
                        child: Text(_getStatusDisplayName(status)),
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedStatus = value;
                    });
                  },
                ),
              ),

            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: requestsAsync.when(
              data: (requests) {
                if (requests.isEmpty) {
                  return Center(
                    child: Text(AppLocalizations.of(context)!.noMaintenanceRequestsFound),
                  );
                }
                return ListView.builder(
                  itemCount: requests.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: MaintenanceRequestCard(
                        request: requests[index],
                        onTap: () {
                          context.push(
                            RouteNames.maintenanceRequestDetail
                                .replaceAll(':id', requests[index].id),
                          );
                        },
                      ),
                    );
                  },
                );
              },
              loading: () => LoadingIndicator(
                message: AppLocalizations.of(context)!.loadingMaintenanceRequests,
              ),
              error: (error, stack) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${AppLocalizations.of(context)!.error}: $error'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          ref.invalidate(maintenanceRequestListProvider(params));
                        },
                        child: Text(AppLocalizations.of(context)!.tryAgain),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusDisplayName(MaintenanceRequestStatus status) {
    switch (status) {
      case MaintenanceRequestStatus.pending:
        return AppLocalizations.of(context)!.pending;
      case MaintenanceRequestStatus.inProgress:
        return AppLocalizations.of(context)!.inProgress;
      case MaintenanceRequestStatus.completed:
        return AppLocalizations.of(context)!.completed;
    }
  }
}

