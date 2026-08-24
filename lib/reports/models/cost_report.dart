import 'package:freezed_annotation/freezed_annotation.dart';

part 'cost_report.freezed.dart';
part 'cost_report.g.dart';

@freezed
class CostReport with _$CostReport {
  const factory CostReport({
    required double totalCost,
    required Map<String, double> costsByCategory,
    required DateTime periodStart,
    required DateTime periodEnd,
  }) = _CostReport;

  factory CostReport.fromJson(Map<String, dynamic> json) =>
      _$CostReportFromJson(json);
}

