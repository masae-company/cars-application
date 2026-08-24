import 'package:freezed_annotation/freezed_annotation.dart';

part 'usage_report.freezed.dart';
part 'usage_report.g.dart';

@freezed
class UsageReport with _$UsageReport {
  const factory UsageReport({
    required String vehicleId,
    required String vehicleRegistration,
    required int totalAllocations,
    required int totalDays,
    required int totalMileage,
    required DateTime periodStart,
    required DateTime periodEnd,
  }) = _UsageReport;

  factory UsageReport.fromJson(Map<String, dynamic> json) =>
      _$UsageReportFromJson(json);
}


