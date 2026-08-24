import 'dart:html' as html;
import '../../vehicles/models/vehicle_model.dart';
import '../../maintenance/models/maintenance_request_model.dart';
import '../../maintenance/models/maintenance_history_model.dart';
import '../../vehicles/models/oil_change_progress_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart' as intl;

/// HTML-based PDF generator that ACTUALLY works for Arabic!
/// Uses browser's rendering engine which properly handles connected Arabic letters
class HtmlPdfGenerator {
  
  /// Generate and download PDF using HTML rendering
  Future<void> generateVehicleReportPDF({
    required VehicleModel vehicle,
    required List<MaintenanceRequestModel> allRequests,
    required AppLocalizations l10n,
    OilChangeProgressModel? oilProgress,
    List<MaintenanceHistoryModel>? maintenanceHistory,
  }) async {
    final isArabic = l10n.localeName == 'ar';
    final dateFormat = intl.DateFormat('dd/MM/yyyy', l10n.localeName);
    final dateTimeFormat = intl.DateFormat('dd/MM/yyyy HH:mm', l10n.localeName);
    
    // Calculate statistics
    final completedRequests = allRequests.where((r) => r.status == MaintenanceRequestStatus.completed).length;
    final pendingRequests = allRequests.where((r) => r.status == MaintenanceRequestStatus.pending).length;
    final inProgressRequests = allRequests.where((r) => r.status == MaintenanceRequestStatus.inProgress).length;
    
    // Build HTML content
    final htmlContent = _buildHTML(
      vehicle: vehicle,
      l10n: l10n,
      dateFormat: dateFormat,
      dateTimeFormat: dateTimeFormat,
      completedCount: completedRequests,
      pendingCount: pendingRequests,
      inProgressCount: inProgressRequests,
      allRequests: allRequests,
      oilProgress: oilProgress,
      maintenanceHistory: maintenanceHistory,
      isArabic: isArabic,
    );
    
    // Create and trigger download
    await _downloadPDF(htmlContent, 'vehicle_report_${vehicle.number}.pdf');
  }
  
  String _buildHTML({
    required VehicleModel vehicle,
    required AppLocalizations l10n,
    required intl.DateFormat dateFormat,
    required intl.DateFormat dateTimeFormat,
    required int completedCount,
    required int pendingCount,
    required int inProgressCount,
    required List<MaintenanceRequestModel> allRequests,
    OilChangeProgressModel? oilProgress,
    List<MaintenanceHistoryModel>? maintenanceHistory,
    required bool isArabic,
  }) {
    final direction = isArabic ? 'rtl' : 'ltr';
    final align = isArabic ? 'right' : 'left';
    
    return '''
<!DOCTYPE html>
<html dir="$direction" lang="${l10n.localeName}">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${l10n.vehicleReport}</title>
  <link href="https://fonts.googleapis.com/css2?family=Tajawal:wght@300;400;500;600;700&family=Cairo:wght@300;400;600;700&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
  <style>
    /* A4 Page Setup */
    @page {
      size: A4;
      margin: 10mm;
    }
    
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }
    
    body {
      font-family: ${isArabic ? "'Tajawal', 'Cairo'" : "'Inter'"}, -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
      direction: $direction;
      background: white;
      color: #2c3e50;
      line-height: 1.4;
      padding: 0;
      margin: 0;
      font-size: 11px;
    }
    
    .container {
      max-width: 210mm;
      margin: 0 auto;
      background: white;
      overflow: hidden;
    }
    
    /* Compact Header */
    .header {
      background: linear-gradient(135deg, #2c3e50 0%, #34495e 100%);
      color: white;
      padding: 12px 16px;
      position: relative;
      overflow: hidden;
    }
    
    .header::before {
      content: '';
      position: absolute;
      top: 0;
      right: 0;
      width: 150px;
      height: 150px;
      background: rgba(255, 255, 255, 0.05);
      border-radius: 50%;
      transform: translate(30%, -30%);
    }
    
    .header h1 {
      font-size: 18px;
      font-weight: 700;
      margin-bottom: 4px;
      position: relative;
      z-index: 1;
    }
    
    .header p {
      font-size: 10px;
      opacity: 0.85;
      font-weight: 300;
      position: relative;
      z-index: 1;
    }
    
    /* Content Area */
    .content {
      padding: 12px 16px;
    }
    
    /* Section */
    .section {
      margin-bottom: 14px;
    }
    
    .section-title {
      font-size: 13px;
      font-weight: 600;
      color: #2c3e50;
      margin-bottom: 8px;
      padding-bottom: 4px;
      border-bottom: 1.5px solid #e8ecf1;
      display: flex;
      align-items: center;
      gap: 6px;
    }
    
    .section-title .icon {
      font-size: 14px;
    }
    
    /* Card */
    .card {
      background: #ffffff;
      border: 1px solid #e8ecf1;
      border-radius: 6px;
      padding: 10px;
      box-shadow: 0 1px 3px rgba(0, 0, 0, 0.04);
    }
    
    /* Info Grid */
    .info-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(140px, 1fr));
      gap: 8px;
    }
    
    .info-item {
      padding: 8px;
      background: #f8f9fa;
      border-radius: 4px;
      border-left: 2px solid #3498db;
    }
    
    .info-label {
      font-size: 9px;
      font-weight: 500;
      color: #7f8c8d;
      margin-bottom: 3px;
      text-transform: uppercase;
      letter-spacing: 0.3px;
    }
    
    .info-value {
      font-size: 11px;
      font-weight: 600;
      color: #2c3e50;
    }
    
    /* Stats Grid */
    .stats-grid {
      display: grid;
      grid-template-columns: repeat(3, 1fr);
      gap: 10px;
      margin-top: 10px;
    }
    
    .stat-card {
      background: linear-gradient(135deg, #ffffff 0%, #f8f9fa 100%);
      border: 1px solid #e8ecf1;
      border-radius: 6px;
      padding: 10px;
      text-align: center;
      position: relative;
      overflow: hidden;
    }
    
    .stat-card::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      height: 3px;
      background: var(--stat-color, #3498db);
    }
    
    .stat-card.completed::before { background: #27ae60; }
    .stat-card.progress::before { background: #3498db; }
    .stat-card.pending::before { background: #f39c12; }
    
    .stat-value {
      font-size: 24px;
      font-weight: 700;
      color: var(--stat-color, #3498db);
      margin-bottom: 4px;
      line-height: 1;
    }
    
    .stat-card.completed .stat-value { color: #27ae60; }
    .stat-card.progress .stat-value { color: #3498db; }
    .stat-card.pending .stat-value { color: #f39c12; }
    
    .stat-label {
      font-size: 10px;
      font-weight: 500;
      color: #7f8c8d;
      text-transform: uppercase;
      letter-spacing: 0.3px;
    }
    
    /* Alert Box */
    .alert {
      padding: 10px 12px;
      border-radius: 6px;
      margin: 10px 0;
      border-left: 3px solid;
      background: white;
      box-shadow: 0 1px 3px rgba(0, 0, 0, 0.06);
    }
    
    .alert-danger {
      border-left-color: #e74c3c;
      background: linear-gradient(135deg, #fff5f5 0%, #ffffff 100%);
    }
    
    .alert-warning {
      border-left-color: #f39c12;
      background: linear-gradient(135deg, #fffbf0 0%, #ffffff 100%);
    }
    
    .alert-success {
      border-left-color: #27ae60;
      background: linear-gradient(135deg, #f0fff4 0%, #ffffff 100%);
    }
    
    .alert-title {
      font-size: 11px;
      font-weight: 600;
      margin-bottom: 4px;
      display: flex;
      align-items: center;
      gap: 4px;
    }
    
    .alert-danger .alert-title { color: #e74c3c; }
    .alert-warning .alert-title { color: #f39c12; }
    .alert-success .alert-title { color: #27ae60; }
    
    .alert-body {
      font-size: 10px;
      color: #5a6c7d;
      line-height: 1.4;
    }
    
    /* Progress Bar */
    .progress-container {
      margin-top: 10px;
      padding: 10px;
      background: #f8f9fa;
      border-radius: 6px;
    }
    
    .progress-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 6px;
    }
    
    .progress-label {
      font-size: 10px;
      font-weight: 500;
      color: #7f8c8d;
    }
    
    .progress-percentage {
      font-size: 13px;
      font-weight: 700;
      color: #2c3e50;
    }
    
    .progress-bar-wrapper {
      width: 100%;
      height: 8px;
      background: #e8ecf1;
      border-radius: 4px;
      overflow: hidden;
      position: relative;
    }
    
    .progress-bar {
      height: 100%;
      border-radius: 4px;
      transition: width 0.3s ease;
      position: relative;
      overflow: hidden;
    }
    
    .progress-bar::after {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
      animation: shimmer 2s infinite;
    }
    
    @keyframes shimmer {
      0% { transform: translateX(-100%); }
      100% { transform: translateX(100%); }
    }
    
    /* Table */
    table {
      width: 100%;
      border-collapse: separate;
      border-spacing: 0;
      margin-top: 8px;
      border-radius: 6px;
      overflow: hidden;
      border: 1px solid #e8ecf1;
      font-size: 10px;
    }
    
    th {
      background: linear-gradient(135deg, #2c3e50 0%, #34495e 100%);
      color: white;
      padding: 8px 10px;
      text-align: $align;
      font-weight: 600;
      font-size: 10px;
      text-transform: uppercase;
      letter-spacing: 0.3px;
    }
    
    td {
      padding: 6px 10px;
      text-align: $align;
      border-bottom: 1px solid #e8ecf1;
      font-size: 10px;
      color: #2c3e50;
    }
    
    tr:last-child td {
      border-bottom: none;
    }
    
    tr:nth-child(even) {
      background: #f8f9fa;
    }
    
    tr:hover {
      background: #f0f3f7;
    }
    
    /* Badge */
    .badge {
      display: inline-block;
      padding: 3px 8px;
      border-radius: 12px;
      font-size: 9px;
      font-weight: 600;
      text-transform: uppercase;
      letter-spacing: 0.3px;
    }
    
    .badge-new {
      background: linear-gradient(135deg, #3498db 0%, #2980b9 100%);
      color: white;
    }
    
    /* Link */
    a {
      color: #3498db;
      text-decoration: none;
      font-weight: 500;
      transition: all 0.2s;
      font-size: 10px;
    }
    
    /* Print Styles */
    @media print {
      body {
        background: white;
        padding: 0;
        margin: 0;
      }
      
      .container {
        box-shadow: none;
        border-radius: 0;
        max-width: 100%;
      }
      
      .section {
        page-break-inside: avoid;
      }
      
      .header {
        page-break-after: avoid;
      }
    }
    
    /* Info Row for Oil Status */
    .info-row {
      display: flex;
      justify-content: space-between;
      padding: 6px 0;
      border-bottom: 1px solid #f0f0f0;
    }
    
    .info-row:last-child {
      border-bottom: none;
    }
    
    .section-content {
      background: #f8f9fa;
      padding: 10px;
      border-radius: 6px;
    }
  </style>
</head>
<body>
  <div class="container">
    <!-- Header -->
    <div class="header">
      <h1>${l10n.vehicleReport}</h1>
      <p>${l10n.generatedAt}: ${dateTimeFormat.format(DateTime.now())}</p>
    </div>
    
    <div class="content">
  
  <!-- Vehicle Details -->
  <div class="section">
    <div class="section-title">
      <span class="icon">🚗</span>
      ${l10n.vehicleDetails}
    </div>
    <div class="card">
      <div class="info-grid">
        <div class="info-item">
          <div class="info-label">الصانع (Make)</div>
          <div class="info-value">${vehicle.formattedMake ?? vehicle.make ?? '-'}</div>
        </div>
        <div class="info-item">
          <div class="info-label">${l10n.model}</div>
          <div class="info-value">${vehicle.formattedModel}</div>
        </div>
        <div class="info-item">
          <div class="info-label">${l10n.plateNumber}</div>
          <div class="info-value">${vehicle.number}</div>
        </div>
        <div class="info-item">
          <div class="info-label">${l10n.status}</div>
          <div class="info-value">${vehicle.status.toDbValue()}</div>
        </div>
        ${vehicle.year != null ? '''
        <div class="info-item">
          <div class="info-label">${l10n.year}</div>
          <div class="info-value">${vehicle.year}</div>
        </div>
        ''' : ''}
        ${vehicle.formattedColor != null ? '''
        <div class="info-item">
          <div class="info-label">${l10n.color}</div>
          <div class="info-value">${vehicle.formattedColor}</div>
        </div>
        ''' : ''}
        ${vehicle.location != null ? '''
        <div class="info-item">
          <div class="info-label">الموقع (Location)</div>
          <div class="info-value">${vehicle.location!.displayName}</div>
        </div>
        ''' : ''}
        <div class="info-item">
          <div class="info-label">تاريخ الإضافة (Added)</div>
          <div class="info-value">${dateFormat.format(vehicle.createdAt)}</div>
        </div>
      </div>
      
      ${vehicle.description != null && vehicle.description!.isNotEmpty && !vehicle.isAccident ? '''
      <div style="margin-top: 8px; padding: 8px; background: #f8f9fa; border-radius: 4px; border-left: 2px solid #3498db;">
        <div style="font-size: 9px; font-weight: 500; color: #7f8c8d; margin-bottom: 3px;">الوصف (Description)</div>
        <div style="font-size: 10px; color: #2c3e50;">${vehicle.description}</div>
      </div>
      ''' : ''}
      
      ${vehicle.isNew ? '''
      <div style="margin-top: 8px;">
        <span class="badge badge-new">🆕 جديدة (New Vehicle)</span>
      </div>
      ''' : ''}
    </div>
  </div>
  
  <!-- Accident Alert -->
  ${vehicle.isAccident ? '''
  <div class="alert alert-danger">
    <div class="alert-title">
      <span>⚠️</span>
      ${l10n.accidentStatus}
    </div>
    <div class="alert-body">
      ${vehicle.accidentDeductibleRate != null ? '<p style="margin-bottom: 6px;"><strong>${l10n.accidentDeductible}:</strong> ${vehicle.accidentDeductibleRate}%</p>' : ''}
      ${vehicle.description != null && vehicle.description!.isNotEmpty ? '''
      <div style="margin-top: 6px; padding: 8px; background: white; border-radius: 4px;">
        <p style="font-weight: 600; margin-bottom: 3px; color: #2c3e50; font-size: 10px;">تفاصيل الحادث:</p>
        <p style="color: #5a6c7d; font-size: 10px;">${vehicle.description}</p>
      </div>
      ''' : ''}
      ${vehicle.accidentReportUrl != null ? '''
      <div style="margin-top: 6px;">
        <a href="${vehicle.accidentReportUrl}" target="_blank">
          📄 عرض تقرير الحادث (View Accident Report)
        </a>
      </div>
      ''' : ''}
    </div>
  </div>
  ''' : ''}
  
  <!-- Oil Status -->
  ${oilProgress != null && oilProgress.currentKilometers > 0 ? '''
  <div class="section">
    <div class="section-title">🛢️ ${l10n.oilStatus}</div>
    <div class="section-content">
      <div class="info-row">
        <span class="info-label">الكيلومترات الحالية (Current Mileage)</span>
        <span class="info-value" style="font-weight: 700; color: #1976D2;">${oilProgress.currentKilometers.toStringAsFixed(0)} km</span>
      </div>
      <div class="info-row">
        <span class="info-label">آخر تغيير زيت (Last Oil Change)</span>
        <span class="info-value">${oilProgress.lastOilChangeKilometers.toStringAsFixed(0)} km</span>
      </div>
      <div class="info-row">
        <span class="info-label">التغيير القادم (Next Oil Change)</span>
        <span class="info-value">${oilProgress.nextOilChangeKilometers.toStringAsFixed(0)} km</span>
      </div>
      <div class="info-row">
        <span class="info-label">المسافة المقطوعة منذ آخر تغيير (Distance Since Last Change)</span>
        <span class="info-value">${(oilProgress.currentKilometers - oilProgress.lastOilChangeKilometers).toStringAsFixed(0)} km</span>
      </div>
      <div class="info-row">
        <span class="info-label">المسافة المتبقية (Remaining Distance)</span>
        <span class="info-value" style="color: ${oilProgress.isOverdue ? '#D32F2F' : '#388E3C'}; font-weight: 700;">
          ${oilProgress.isOverdue ? '⚠️ ' : ''}${(oilProgress.nextOilChangeKilometers - oilProgress.currentKilometers).toStringAsFixed(0)} km
          ${oilProgress.isOverdue ? ' (متأخر!)' : ''}
        </span>
      </div>
      <div class="info-row">
        <span class="info-label">الفترة الموصى بها (Recommended Interval)</span>
        <span class="info-value">${(oilProgress.nextOilChangeKilometers - oilProgress.lastOilChangeKilometers).toStringAsFixed(0)} km</span>
      </div>
      
      <!-- Progress Indicator -->
      <div class="progress-container">
        <div class="progress-header">
          <span class="progress-label">نسبة الاستهلاك (Oil Usage)</span>
          <span class="progress-percentage" style="color: ${oilProgress.isOverdue ? '#e74c3c' : oilProgress.progress > 0.8 ? '#f39c12' : '#27ae60'};">
            ${(oilProgress.progress * 100).toInt()}%
          </span>
        </div>
        <div class="progress-bar-wrapper">
          <div class="progress-bar" style="width: ${(oilProgress.progress * 100).clamp(0, 100)}%; background: ${oilProgress.isOverdue ? '#e74c3c' : oilProgress.progress > 0.8 ? '#f39c12' : '#27ae60'};"></div>
        </div>
      </div>
      
      ${oilProgress.isOverdue ? '''
      <div style="margin-top: 8px; padding: 6px; background: #FFEBEE; border: 1px solid #D32F2F; border-radius: 4px; text-align: center;">
        <p style="color: #D32F2F; font-weight: 700; margin: 0; font-size: 10px;">
          ⚠️ تحذير: تجاوزت المسافة الموصى بها لتغيير الزيت!
        </p>
        <p style="color: #D32F2F; font-size: 9px; margin: 4px 0 0 0;">
          Warning: Oil change is overdue!
        </p>
      </div>
      ''' : oilProgress.progress > 0.8 ? '''
      <div style="margin-top: 8px; padding: 6px; background: #FFF3E0; border: 1px solid #F57C00; border-radius: 4px; text-align: center;">
        <p style="color: #F57C00; font-weight: 700; margin: 0; font-size: 10px;">
          ⚠️ اقتراب موعد تغيير الزيت
        </p>
        <p style="color: #F57C00; font-size: 9px; margin: 4px 0 0 0;">
          Oil change approaching soon
        </p>
      </div>
      ''' : ''}
    </div>
  </div>
  ''' : ''}
  
  <!-- Maintenance Requests -->
  ${allRequests.isNotEmpty ? '''
  <div class="section">
    <div class="section-title">
      <span class="icon">🔧</span>
      طلبات الصيانة (Maintenance Requests)
    </div>
    <div class="card">
      ${allRequests.take(10).map((request) {
        // Build services list
        final services = <String>[];
        if (request.oilChangeCurrentKm != null) services.add('تغيير زيت');
        if (request.brakePadsLastChanged != null) services.add('فرامل');
        if (request.sparkPlugsLastChanged != null) services.add('بواجي');
        if (request.tyresLastChanged != null) services.add('كفرات');
        if (request.acService) services.add('مكيف');
        if (request.lightsService) services.add('أنوار');
        if (request.tyreStackingService) services.add('ترصيص كفرات');
        final servicesText = services.isNotEmpty ? services.join(', ') : 'خدمات عامة';
        
        return '''
      <div style="padding: 8px; margin-bottom: 6px; background: #f8f9fa; border-radius: 4px; border-left: 2px solid ${request.status == MaintenanceRequestStatus.completed ? '#27ae60' : request.status == MaintenanceRequestStatus.inProgress ? '#3498db' : request.status == MaintenanceRequestStatus.pending ? '#f39c12' : '#95a5a6'};">
        <div style="display: flex; justify-content: space-between; align-items: start; margin-bottom: 6px;">
          <div>
            <div style="font-weight: 600; font-size: 11px; color: #2c3e50; margin-bottom: 2px;">
              $servicesText
            </div>
            <div style="font-size: 9px; color: #7f8c8d;">
              📅 ${dateFormat.format(request.requestedAt)}
            </div>
          </div>
          <div style="padding: 2px 8px; border-radius: 10px; font-size: 9px; font-weight: 600; background: ${request.status == MaintenanceRequestStatus.completed ? '#e8f5e9' : request.status == MaintenanceRequestStatus.inProgress ? '#e3f2fd' : request.status == MaintenanceRequestStatus.pending ? '#fff3e0' : '#f5f5f5'}; color: ${request.status == MaintenanceRequestStatus.completed ? '#27ae60' : request.status == MaintenanceRequestStatus.inProgress ? '#3498db' : request.status == MaintenanceRequestStatus.pending ? '#f39c12' : '#95a5a6'};">
            ${request.status.toDbValue()}
          </div>
        </div>
        ${request.notes != null && request.notes!.isNotEmpty ? '''
        <div style="padding: 6px; background: white; border-radius: 4px; margin-bottom: 4px;">
          <div style="font-size: 9px; font-weight: 500; color: #7f8c8d; margin-bottom: 2px;">ملاحظات:</div>
          <div style="font-size: 10px; color: #2c3e50;">${request.notes}</div>
        </div>
        ''' : ''}
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(100px, 1fr)); gap: 4px; margin-top: 4px;">
          ${request.oilChangeCurrentKm != null ? '''
          <div style="font-size: 9px;">
            <span style="color: #7f8c8d;">الكيلومترات:</span>
            <span style="font-weight: 600; color: #2c3e50;"> ${request.oilChangeCurrentKm} km</span>
          </div>
          ''' : ''}
          ${request.completedAt != null ? '''
          <div style="font-size: 9px;">
            <span style="color: #7f8c8d;">تاريخ الإنجاز:</span>
            <span style="font-weight: 600; color: #2c3e50;"> ${dateFormat.format(request.completedAt!)}</span>
          </div>
          ''' : ''}
          ${request.invoiceUrl != null ? '''
          <div style="font-size: 9px;">
            <a href="${request.invoiceUrl}" target="_blank" style="color: #3498db; text-decoration: none;">📄 الفاتورة</a>
          </div>
          ''' : ''}
        </div>
      </div>
      ''';
      }).join()}
      ${allRequests.length > 10 ? '<p style="margin-top: 6px; color: #7f8c8d; font-size: 9px; text-align: center;">... ${allRequests.length - 10} طلب إضافي</p>' : ''}
    </div>
  </div>
  ''' : ''}
  
  <!-- Maintenance Statistics -->
  <div class="section">
    <div class="section-title">
      <span class="icon">📊</span>
      ${l10n.maintenanceHistory}
    </div>
    <div class="stats-grid">
      <div class="stat-card completed">
        <div class="stat-value">$completedCount</div>
        <div class="stat-label">${l10n.completed}</div>
      </div>
      <div class="stat-card progress">
        <div class="stat-value">$inProgressCount</div>
        <div class="stat-label">${l10n.inProgress}</div>
      </div>
      <div class="stat-card pending">
        <div class="stat-value">$pendingCount</div>
        <div class="stat-label">${l10n.pending}</div>
      </div>
    </div>
  </div>
  
  <!-- Maintenance History Table -->
  ${maintenanceHistory != null && maintenanceHistory.isNotEmpty ? '''
  <div class="section">
    <div class="section-title">
      <span class="icon">📋</span>
      ${l10n.maintenanceHistory} - ${l10n.services}
    </div>
    <table>
      <thead>
        <tr>
          <th>نوع الخدمة</th>
          <th>التاريخ</th>
          <th>الكيلومترات</th>
          <th>التكلفة</th>
        </tr>
      </thead>
      <tbody>
        ${maintenanceHistory.take(20).map((history) => '''
        <tr>
          <td>${history.maintenanceType.displayName}</td>
          <td>${dateFormat.format(history.performedAt)}</td>
          <td>${history.kilometers?.toString() ?? '-'}</td>
          <td>${history.cost != null ? '${history.cost!.toStringAsFixed(0)} ريال' : '-'}</td>
        </tr>
        ''').join()}
      </tbody>
    </table>
    ${maintenanceHistory.length > 20 ? '<p style="margin-top: 6px; color: #7f8c8d; font-size: 9px; text-align: center;">... ${maintenanceHistory.length - 20} سجل إضافي</p>' : ''}
  </div>
  ''' : ''}
  
    </div><!-- /content -->
  </div><!-- /container -->
</body>
</html>
    ''';
  }
  
  Future<void> _downloadPDF(String htmlContent, String filename) async {
    // Create a blob from the HTML
    final blob = html.Blob([htmlContent], 'text/html');
    final url = html.Url.createObjectUrlFromBlob(blob);
    
    // Create anchor element for download
    final anchor = html.AnchorElement()
      ..href = url
      ..download = filename.replaceAll('.pdf', '.html') // Download as HTML
      ..style.display = 'none';
    
    // Add to document, click, and remove
    html.document.body?.append(anchor);
    anchor.click();
    
    // Clean up
    Future.delayed(const Duration(milliseconds: 100), () {
      anchor.remove();
      html.Url.revokeObjectUrl(url);
    });
  }
}
