import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/foundation.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/loading_indicator.dart';
import '../../vehicles/providers/vehicle_provider.dart';
import '../../maintenance/providers/maintenance_request_provider.dart';
import '../../maintenance/providers/maintenance_history_provider.dart';
import '../../maintenance/models/maintenance_request_model.dart';
import '../../vehicles/providers/oil_change_progress_provider.dart';
import '../services/pdf_generator_service.dart';
import '../services/html_pdf_generator.dart';

class VehicleAnalysisReportScreen extends ConsumerStatefulWidget {
  const VehicleAnalysisReportScreen({super.key});

  @override
  ConsumerState<VehicleAnalysisReportScreen> createState() => _VehicleAnalysisReportScreenState();
}

class _VehicleAnalysisReportScreenState extends ConsumerState<VehicleAnalysisReportScreen> {
  String? _selectedVehicleId;

  @override
  Widget build(BuildContext context) {
    final vehiclesAsync = ref.watch(vehicleListProvider(VehicleListParams()));

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.reports), // "Reports" or specific title
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 24),
            
            // Vehicle Selector
            vehiclesAsync.when(
              data: (vehicles) {
                return DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.selectVehicle,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.directions_car),
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                  ),
                  value: _selectedVehicleId,
                  items: vehicles.map((v) {
                    return DropdownMenuItem(
                      value: v.id,
                      child: Text('${v.model} - ${v.number}'),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedVehicleId = val;
                    });
                  },
                );
              },
              loading: () => const LinearProgressIndicator(),
              error: (err, _) => Text('Error loading vehicles: $err'),
            ),

            const SizedBox(height: 32),

            if (_selectedVehicleId != null)
              _buildVehicleAnalysis(context, _selectedVehicleId!)
            else
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(48.0),
                  child: Column(
                    children: [
                      Icon(Icons.analytics_outlined, size: 64, color: AppColors.primary.withOpacity(0.5)),
                      const SizedBox(height: 16),
                      Text(
                        'Select a vehicle to generate analysis',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Vehicle Analysis & Reports',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Generate detailed PDF reports including maintenance history, oil health, and service requests.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildVehicleAnalysis(BuildContext context, String vehicleId) {
    final vehicleAsync = ref.watch(vehicleProvider(vehicleId));
    final requestsAsync = ref.watch(maintenanceRequestListProvider(MaintenanceRequestListParams(carId: vehicleId)));
    final oilProgressAsync = ref.watch(oilChangeProgressProvider(vehicleId));
    final historyAsync = ref.watch(maintenanceHistoryListProvider(MaintenanceHistoryListParams(carId: vehicleId)));

    if (vehicleAsync.isLoading || requestsAsync.isLoading || oilProgressAsync.isLoading || historyAsync.isLoading) {
      return const Center(child: LoadingIndicator());
    }

    if (vehicleAsync.hasError) return Text('Error loading vehicle: ${vehicleAsync.error}');

    final vehicle = vehicleAsync.valueOrNull;
    final requests = requestsAsync.valueOrNull ?? [];
    final oilProgress = oilProgressAsync.valueOrNull;
    final maintenanceHistory = historyAsync.valueOrNull ?? [];

    if (vehicle == null) return const Text('Vehicle not found.');

    // Calculations
    final pendingCount = requests.where((r) => r.status == MaintenanceRequestStatus.pending).length;
    final inProgressCount = requests.where((r) => r.status == MaintenanceRequestStatus.inProgress).length;
    final completedCount = requests.where((r) => r.status == MaintenanceRequestStatus.completed).length;

    return Column(
      children: [
        // Action Bar (Download PDF)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              const Icon(Icons.picture_as_pdf, color: Colors.white, size: 48),
              const SizedBox(height: 16),
              const Text(
                'Ready to Export',
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                '${vehicle.model} - ${vehicle.number}',
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () async {
                      try {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Generating HTML report with perfect Arabic...')),
                        );

                        final htmlGenerator = HtmlPdfGenerator();
                        await htmlGenerator.generateVehicleReportPDF(
                          vehicle: vehicle,
                          allRequests: requests,
                          oilProgress: oilProgress,
                          maintenanceHistory: maintenanceHistory,
                          l10n: AppLocalizations.of(context)!,
                        );
                        
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('✅ HTML report downloaded! Open it in browser to view perfect Arabic'),
                              backgroundColor: Colors.green,
                              duration: Duration(seconds: 5),
                            ),
                          );
                        }
                      } catch (e, stack) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error: $e'),
                              backgroundColor: Colors.red,
                              duration: const Duration(seconds: 5),
                            ),
                          );
                        }
                        debugPrint('HTML PDF Error: $e\n$stack');
                      }
                    },
                    icon: const Icon(Icons.language),
                    label: const Text('Download HTML (Perfect Arabic!)'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: () async {
                      Uint8List? pdfData; // Define outside try block
                      try {
                        // Show loading indication if needed, or rely on UI responsiveness
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Generating report...')),
                        );

                        final pdfService = ref.read(pdfGeneratorServiceProvider);
                        pdfData = await pdfService.generateVehicleReport(
                          vehicle: vehicle,
                          allRequests: requests,
                          oilProgress: oilProgress,
                          maintenanceHistory: maintenanceHistory,
                          l10n: AppLocalizations.of(context)!,
                        );
                        
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        }

                        await Printing.sharePdf(
                          bytes: pdfData!,
                          filename: 'report_${vehicle.number}.pdf',
                        );
                      } catch (e, stack) {
                         if (context.mounted) {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          
                          // Fallback: Try FilePicker or just Print if Share fails
                          if (e.toString().contains('MissingPluginException')) {
                             debugPrint('Printing plugin missing. Please restart the application.');
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error generating PDF: $e\nIf this persists, please RESTART the app.'),
                              backgroundColor: Colors.red,
                              duration: const Duration(seconds: 10),
                            ),
                          );
                        }
                        debugPrint('PDF Generation Error: $e\n$stack');
                      }
                    },
                    icon: const Icon(Icons.download),
                    label: const Text('Standard PDF'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        // Quick Stats Grid
        GridView.count(
          crossAxisCount: MediaQuery.of(context).size.width > 900 ? 4 : 2,
          shrinkWrap: true,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildStatCard(context, 'Pending Requests', pendingCount.toString(), Icons.pending_actions, Colors.orange),
            _buildStatCard(context, 'In Progress', inProgressCount.toString(), Icons.autorenew, Colors.blue),
            _buildStatCard(context, 'Completed Jobs', completedCount.toString(), Icons.history, Colors.green),
            _buildStatCard(context, 'Oil Health', '${((oilProgress?.progress ?? 0) * 100).toInt()}% Used', Icons.oil_barrel, 
              (oilProgress?.isOverdue ?? false) ? Colors.red : Colors.teal),
          ],
        ),

        const SizedBox(height: 32),
        
        // Oil Details specific view if needed, or rely on PDF.
        // Let's add the oil progress bar here too for quick view
        if (oilProgress != null)
           _buildOilProgressIndicator(context, oilProgress),
      ],
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32, color: color),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(fontSize: 14, color: AppColors.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildOilProgressIndicator(BuildContext context, oilProgress) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
         border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Oil Life', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: 1.0 - (oilProgress.progress as double).clamp(0.0, 1.0),
            backgroundColor: Colors.grey[200],
            color: (oilProgress.isOverdue as bool) ? Colors.red : Colors.green,
            minHeight: 10,
            borderRadius: BorderRadius.circular(5),
          ),
           const SizedBox(height: 8),
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               Text('${oilProgress.currentKilometers} km (Current)'),
               Text('${oilProgress.nextOilChangeKilometers} km (Target)'),
             ],
           )
        ],
      ),
    );
  }
}
