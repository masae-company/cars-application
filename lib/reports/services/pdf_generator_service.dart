import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../vehicles/models/vehicle_model.dart';
import '../../maintenance/models/maintenance_request_model.dart';
import '../../maintenance/models/maintenance_history_model.dart';
import '../../vehicles/models/oil_change_progress_model.dart';
import 'package:intl/intl.dart' as intl;

final pdfGeneratorServiceProvider = Provider<PdfGeneratorService>((ref) {
  return PdfGeneratorService();
});

class PdfGeneratorService {
  /// Pass-through for text - let the font and RTL direction handle Arabic rendering
  /// The PDF package with proper font + RTL should handle connected letters
  String _fix(String? text) {
    if (text == null || text.isEmpty) return '';
    // Return text as-is - the font's OpenType features will handle shaping
    return text;
  }

  Future<Uint8List> generateVehicleReport({
    required VehicleModel vehicle,
    required List<MaintenanceRequestModel> allRequests,
    required AppLocalizations l10n,
    OilChangeProgressModel? oilProgress,
    List<MaintenanceHistoryModel>? maintenanceHistory,
  }) async {
    final pdf = pw.Document();
    final isArabic = l10n.localeName == 'ar';

    // Load Omnes font (supports Latin)
    final omnesData = await rootBundle.load('assets/fonts/Omnes Regular.ttf');
    final omnes = pw.Font.ttf(omnesData);

    // Load cairo.ttf - Working Arabic font!
    final arabicData = await rootBundle.load('assets/fonts/cairo.ttf');
    final arabic = pw.Font.ttf(arabicData);

    // Text direction
    final textDirection = isArabic ? pw.TextDirection.rtl : pw.TextDirection.ltr;
    final alignment = isArabic ? pw.CrossAxisAlignment.end : pw.CrossAxisAlignment.start;

    // Date formatter
    final dateFormat = intl.DateFormat('dd/MM/yyyy', l10n.localeName);
    final dateTimeFormat = intl.DateFormat('dd/MM/yyyy HH:mm', l10n.localeName);

    // Maintenance calculations
    final completedRequests = allRequests.where((r) => r.status == MaintenanceRequestStatus.completed).toList();
    final pendingRequests = allRequests.where((r) => r.status == MaintenanceRequestStatus.pending).toList();
    final inProgressRequests = allRequests.where((r) => r.status == MaintenanceRequestStatus.inProgress).toList();

    // === PAGE 1: OVERVIEW ===
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        textDirection: textDirection,
        theme: pw.ThemeData.withFont(
          base: omnes,
          bold: omnes,
          fontFallback: [arabic],
        ),
        margin: const pw.EdgeInsets.all(40),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: alignment,
            children: [
              // Professional Header
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(24),
                decoration: pw.BoxDecoration(
                  gradient: const pw.LinearGradient(
                    colors: [PdfColor.fromInt(0xFF1565C0), PdfColor.fromInt(0xFF1976D2)],
                  ),
                  borderRadius: const pw.BorderRadius.all(pw.Radius.circular(12)),
                ),
                child: pw.Column(
                  crossAxisAlignment: alignment,
                  children: [
                    pw.Text(
                      _fix(l10n.vehicleReport).toUpperCase(),
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.white,
                      ),
                      textDirection: textDirection,
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text(
                      '${_fix(l10n.generatedAt)}: ${dateTimeFormat.format(DateTime.now())}',
                      style: const pw.TextStyle(fontSize: 11, color: PdfColors.white),
                      textDirection: textDirection,
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 32),

              // Vehicle Information
              _buildSection(
                l10n.vehicleDetails,
                [
                  _InfoRow(_fix(l10n.model), _fix(vehicle.model)),
                  _InfoRow(_fix(l10n.plateNumber), _fix(vehicle.number)),
                  _InfoRow(_fix(l10n.status), _fix(vehicle.status.toDbValue())),
                  if (vehicle.year != null) _InfoRow(_fix(l10n.year), vehicle.year.toString()),
                  if (vehicle.formattedColor != null) _InfoRow(_fix(l10n.color), _fix(vehicle.formattedColor!)),
                  if (vehicle.location != null) _InfoRow(_fix('الموقع'), _fix(vehicle.location!.displayName)),
                ],
                textDirection,
                alignment,
              ),
              pw.SizedBox(height: 24),

              // Accident Warning (if applicable)
              if (vehicle.isAccident) ...[
                pw.Container(
                  width: double.infinity,
                  padding: const pw.EdgeInsets.all(16),
                  decoration: pw.BoxDecoration(
                    color: PdfColor.fromInt(0xFFFFEBEE),
                    border: pw.Border.all(color: PdfColor.fromInt(0xFFD32F2F), width: 2),
                    borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Text(
                        '⚠',
                        style: const pw.TextStyle(fontSize: 24, color: PdfColor.fromInt(0xFFD32F2F)),
                      ),
                      pw.SizedBox(width: 12),
                      pw.Column(
                        crossAxisAlignment: alignment,
                        children: [
                          pw.Text(
                            _fix(l10n.accidentStatus),
                            style: pw.TextStyle(
                              fontSize: 14,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColor.fromInt(0xFFD32F2F),
                            ),
                            textDirection: textDirection,
                          ),
                          if (vehicle.accidentDeductibleRate != null)
                            pw.Text(
                              '${_fix(l10n.accidentDeductible)}: ${vehicle.accidentDeductibleRate}%',
                              style: const pw.TextStyle(fontSize: 12),
                              textDirection: textDirection,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 24),
              ],

              // Oil Status
              if (oilProgress != null && oilProgress.currentKilometers > 0) ...[
                _buildSection(
                  l10n.oilStatus,
                  [
                    _InfoRow(_fix(l10n.mileage), '${oilProgress.currentKilometers} km'),
                    _InfoRow(_fix(l10n.lastChange), '${oilProgress.lastOilChangeKilometers} km'),
                    _InfoRow(_fix(l10n.nextChange), '${oilProgress.nextOilChangeKilometers} km'),
                    _InfoRow(
                      _fix(l10n.remaining),
                      '${oilProgress.nextOilChangeKilometers - oilProgress.currentKilometers} km',
                      valueColor: oilProgress.isOverdue ? PdfColor.fromInt(0xFFD32F2F) : PdfColor.fromInt(0xFF388E3C),
                    ),
                  ],
                  textDirection,
                  alignment,
                  customContent: pw.Column(
                    children: [
                      pw.SizedBox(height: 12),
                      // Progress bar
                      pw.Stack(
                        children: [
                          pw.Container(
                            width: double.infinity,
                            height: 24,
                            decoration: pw.BoxDecoration(
                              color: PdfColors.grey300,
                              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(12)),
                            ),
                          ),
                          pw.Container(
                            width: (oilProgress.progress.clamp(0.0, 1.0) * 450),
                            height: 24,
                            decoration: pw.BoxDecoration(
                              color: oilProgress.isOverdue ? PdfColor.fromInt(0xFFD32F2F) : PdfColor.fromInt(0xFF388E3C),
                              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(12)),
                            ),
                          ),
                          pw.Container(
                            width: double.infinity,
                            height: 24,
                            alignment: pw.Alignment.center,
                            child: pw.Text(
                              '${(oilProgress.progress * 100).toInt()}%',
                              style: pw.TextStyle(
                                fontSize: 11,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 24),
              ],

              // Maintenance Summary
              _buildSectionTitle(l10n.maintenanceHistory, textDirection, alignment),
              pw.SizedBox(height: 16),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatBox(l10n.completed, completedRequests.length.toString(), PdfColor.fromInt(0xFF388E3C), textDirection, alignment),
                  _buildStatBox(l10n.inProgress, inProgressRequests.length.toString(), PdfColor.fromInt(0xFF1976D2), textDirection, alignment),
                  _buildStatBox(l10n.pending, pendingRequests.length.toString(), PdfColor.fromInt(0xFFF57C00), textDirection, alignment),
                ],
              ),
            ],
          );
        },
      ),
    );

    // === PAGE 2: MAINTENANCE HISTORY TABLE ===
    if (maintenanceHistory != null && maintenanceHistory.isNotEmpty) {
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          textDirection: textDirection,
          theme: pw.ThemeData.withFont(
            base: omnes,
            bold: omnes,
            fontFallback: [arabic],
          ),
          margin: const pw.EdgeInsets.all(40),
          build: (context) {
            return pw.Column(
              crossAxisAlignment: alignment,
              children: [
                _buildSectionTitle('${_fix(l10n.maintenanceHistory)} - ${_fix(l10n.services)}', textDirection, alignment),
                pw.SizedBox(height: 20),

                // Table
                pw.Table(
                  border: pw.TableBorder.all(color: PdfColors.grey400, width: 0.5),
                  columnWidths: {
                    0: const pw.FlexColumnWidth(2.5),
                    1: const pw.FlexColumnWidth(2),
                    2: const pw.FlexColumnWidth(1.5),
                    3: const pw.FlexColumnWidth(1.5),
                  },
                  children: [
                    // Header
                    pw.TableRow(
                      decoration: pw.BoxDecoration(color: PdfColor.fromInt(0xFF1565C0)),
                      children: [
                        _buildTableCell('نوع الخدمة', isHeader: true, isWhite: true),
                        _buildTableCell('التاريخ', isHeader: true, isWhite: true),
                        _buildTableCell('الكيلومترات', isHeader: true, isWhite: true),
                        _buildTableCell('التكلفة', isHeader: true, isWhite: true),
                      ],
                    ),
                    // Data rows
                    ...maintenanceHistory.take(20).map((history) => pw.TableRow(
                      decoration: pw.BoxDecoration(
                        color: maintenanceHistory.indexOf(history) % 2 == 0 ? PdfColors.white : PdfColors.grey100,
                      ),
                      children: [
                        _buildTableCell(history.maintenanceType.displayName),
                        _buildTableCell(dateFormat.format(history.performedAt)),
                        _buildTableCell(history.kilometers?.toString() ?? '-'),
                        _buildTableCell(history.cost != null ? '${history.cost!.toStringAsFixed(0)} ${_fix("ريال")}' : '-'),
                      ],
                    )),
                  ],
                ),

                if (maintenanceHistory.length > 20)
                  pw.Padding(
                    padding: const pw.EdgeInsets.only(top: 12),
                    child: pw.Text(
                      _fix('... ${maintenanceHistory.length - 20} سجل إضافي'),
                      style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
                      textDirection: textDirection,
                    ),
                  ),
              ],
            );
          },
        ),
      );
    }

    // === PAGE 3: ACTIVE REQUESTS ===
    if (pendingRequests.isNotEmpty || inProgressRequests.isNotEmpty) {
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          textDirection: textDirection,
          theme: pw.ThemeData.withFont(
            base: omnes,
            bold: omnes,
            fontFallback: [arabic],
          ),
          margin: const pw.EdgeInsets.all(40),
          build: (context) {
            return pw.Column(
              crossAxisAlignment: alignment,
              children: [
                _buildSectionTitle(l10n.activeMaintenanceRequests, textDirection, alignment),
                pw.SizedBox(height: 20),

                if (inProgressRequests.isNotEmpty) ...[
                  pw.Text(
                    '${_fix(l10n.inProgress)} (${inProgressRequests.length})',
                    style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColor.fromInt(0xFF1976D2)),
                    textDirection: textDirection,
                  ),
                  pw.SizedBox(height: 12),
                  ...inProgressRequests.take(8).map((req) => _buildRequestCard(req, dateFormat, textDirection, alignment)),
                  pw.SizedBox(height: 24),
                ],

                if (pendingRequests.isNotEmpty) ...[
                  pw.Text(
                    '${_fix(l10n.pending)} (${pendingRequests.length})',
                    style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColor.fromInt(0xFFF57C00)),
                    textDirection: textDirection,
                  ),
                  pw.SizedBox(height: 12),
                  ...pendingRequests.take(8).map((req) => _buildRequestCard(req, dateFormat, textDirection, alignment)),
                ],
              ],
            );
          },
        ),
      );
    }

    return pdf.save();
  }

  // Helper Widgets
  pw.Widget _buildSectionTitle(String title, pw.TextDirection direction, pw.CrossAxisAlignment alignment) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: pw.BoxDecoration(
        color: PdfColor.fromInt(0xFF1565C0),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
      ),
      child: pw.Text(
        _fix(title),
        style: pw.TextStyle(
          fontSize: 16,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.white,
        ),
        textDirection: direction,
        textAlign: alignment == pw.CrossAxisAlignment.end ? pw.TextAlign.right : pw.TextAlign.left,
      ),
    );
  }

  pw.Widget _buildSection(
    String title,
    List<_InfoRow> rows,
    pw.TextDirection direction,
    pw.CrossAxisAlignment alignment, {
    pw.Widget? customContent,
  }) {
    return pw.Column(
      crossAxisAlignment: alignment,
      children: [
        _buildSectionTitle(title, direction, alignment),
        pw.SizedBox(height: 12),
        pw.Container(
          padding: const pw.EdgeInsets.all(16),
          decoration: pw.BoxDecoration(
            color: PdfColors.white,
            border: pw.Border.all(color: PdfColors.grey300),
            borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
          ),
          child: pw.Column(
            children: [
              ...rows.map((row) => pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 10),
                child: _buildInfoRow(row.label, row.value, direction, valueColor: row.valueColor),
              )),
              if (customContent != null) customContent,
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _buildInfoRow(String label, String value, pw.TextDirection direction, {PdfColor? valueColor}) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          label, // Already fixed if passed through _InfoRow
          style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: PdfColors.grey700),
          textDirection: direction,
        ),
        pw.SizedBox(width: 16),
        pw.Expanded(
          child: pw.Text(
            value, // Already fixed if passed through _InfoRow
            style: pw.TextStyle(fontSize: 11, color: valueColor ?? PdfColors.black),
            textDirection: direction,
            textAlign: direction == pw.TextDirection.rtl ? pw.TextAlign.right : pw.TextAlign.left,
          ),
        ),
      ],
    );
  }

  pw.Widget _buildStatBox(String label, String value, PdfColor color, pw.TextDirection direction, pw.CrossAxisAlignment alignment) {
    return pw.Container(
      width: 140,
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        border: pw.Border.all(color: color, width: 2),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
        boxShadow: [
          pw.BoxShadow(color: PdfColors.grey300, blurRadius: 4, offset: const PdfPoint(0, 2)),
        ],
      ),
      child: pw.Column(
        crossAxisAlignment: alignment,
        children: [
          pw.Text(
            _fix(value),
            style: pw.TextStyle(
              fontSize: 28,
              fontWeight: pw.FontWeight.bold,
              color: color,
            ),
            textDirection: direction,
          ),
          pw.SizedBox(height: 6),
          pw.Text(
            _fix(label),
            style: const pw.TextStyle(fontSize: 11, color: PdfColors.grey700),
            textDirection: direction,
          ),
        ],
      ),
    );
  }

  pw.Widget _buildRequestCard(MaintenanceRequestModel request, intl.DateFormat dateFormat, pw.TextDirection direction, pw.CrossAxisAlignment alignment) {
    final color = request.status == MaintenanceRequestStatus.completed
        ? PdfColor.fromInt(0xFF388E3C)
        : request.status == MaintenanceRequestStatus.inProgress
            ? PdfColor.fromInt(0xFF1976D2)
            : PdfColor.fromInt(0xFFF57C00);

    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 8),
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        border: pw.Border(left: pw.BorderSide(color: color, width: 4)),
        boxShadow: [
          pw.BoxShadow(color: PdfColors.grey200, blurRadius: 2, offset: const PdfPoint(0, 1)),
        ],
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: alignment,
              children: [
                pw.Text(
                  _fix(request.status.name.toUpperCase()),
                  style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: color),
                  textDirection: direction,
                ),
                if (request.notes != null)
                  pw.Padding(
                    padding: const pw.EdgeInsets.only(top: 4),
                    child: pw.Text(
                      _fix(request.notes!),
                      style: const pw.TextStyle(fontSize: 10),
                      textDirection: direction,
                    ),
                  ),
              ],
            ),
          ),
          pw.Text(
            dateFormat.format(request.createdAt),
            style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
            textDirection: direction,
          ),
        ],
      ),
    );
  }

  pw.Widget _buildTableCell(String text, {bool isHeader = false, bool isWhite = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        _fix(text),
        style: pw.TextStyle(
          fontSize: isHeader ? 11 : 10,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
          color: isWhite ? PdfColors.white : PdfColors.black,
        ),
        textAlign: pw.TextAlign.center,
      ),
    );
  }
}

class _InfoRow {
  final String label;
  final String value;
  final PdfColor? valueColor;

  _InfoRow(this.label, this.value, {this.valueColor});
}
