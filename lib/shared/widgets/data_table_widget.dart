import 'package:flutter/material.dart';

class DataTableWidget<T> extends StatelessWidget {
  final List<T> data;
  final List<DataColumn> columns;
  final DataRow Function(T item) buildRow;
  final bool isLoading;
  final String? emptyMessage;

  const DataTableWidget({
    super.key,
    required this.data,
    required this.columns,
    required this.buildRow,
    this.isLoading = false,
    this.emptyMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (data.isEmpty) {
      return Center(
        child: Text(emptyMessage ?? 'No data available'),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: columns,
        rows: data.map((item) => buildRow(item)).toList(),
      ),
    );
  }
}

