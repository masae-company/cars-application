import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/monthly_checkup_provider.dart';
import '../widgets/monthly_checkup_card.dart';
import '../../core/widgets/loading_indicator.dart';
import '../../core/utils/date_formatters.dart' as date_utils;
import '../../core/theme/app_colors.dart';
import '../../core/constants/route_names.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MonthlyCheckupListScreen extends ConsumerStatefulWidget {
  const MonthlyCheckupListScreen({super.key});

  @override
  ConsumerState<MonthlyCheckupListScreen> createState() =>
      _MonthlyCheckupListScreenState();
}

class _MonthlyCheckupListScreenState
    extends ConsumerState<MonthlyCheckupListScreen> {
  bool? _completedOnly;
  DateTime? _startDate;
  DateTime? _endDate;
  String? _performedBy;
  bool _filtersExpanded = false;

  Future<void> _selectStartDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: _startDate ?? DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  void _clearFilters() {
    setState(() {
      _completedOnly = null;
      _startDate = null;
      _endDate = null;
      _performedBy = null;
    });
  }

  bool get _hasActiveFilters {
    return _completedOnly != null ||
        _startDate != null ||
        _endDate != null ||
        _performedBy != null;
  }

  @override
  Widget build(BuildContext context) {
    final params = MonthlyCheckupListParams(
      completedOnly: _completedOnly,
      startDate: _startDate,
      endDate: _endDate,
      performedBy: _performedBy,
    );

    final checkupsAsync = ref.watch(monthlyCheckupListProvider(params));

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Modern Compact Filters Section
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
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
            child: Column(
              children: [
                // Filter Header - Always Visible
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _filtersExpanded = !_filtersExpanded;
                      });
                    },
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.tune,
                            size: 20,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            AppLocalizations.of(context)!.filters,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          if (_hasActiveFilters) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '${(_completedOnly != null ? 1 : 0) + (_startDate != null ? 1 : 0) + (_endDate != null ? 1 : 0) + (_performedBy != null ? 1 : 0)}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                          const Spacer(),
                          if (_hasActiveFilters)
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  _clearFilters();
                                },
                                borderRadius: BorderRadius.circular(8),
                                child: Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Icon(
                                    Icons.close,
                                    size: 18,
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            ),
                          const SizedBox(width: 4),
                          Icon(
                            _filtersExpanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            size: 20,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Active Filters Chips - Always Visible
                if (_hasActiveFilters && !_filtersExpanded)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        if (_completedOnly != null)
                          _FilterChip(
                            label: _completedOnly!
                                ? AppLocalizations.of(context)!.completedOnly
                                : AppLocalizations.of(context)!.pendingOnly,
                            onRemove: () {
                              setState(() {
                                _completedOnly = null;
                              });
                            },
                          ),
                        if (_startDate != null)
                          _FilterChip(
                            label: AppLocalizations.of(context)!.dateFrom(
                              date_utils.DateFormatters.formatDisplayDate(_startDate!),
                            ),
                            onRemove: () {
                              setState(() {
                                _startDate = null;
                              });
                            },
                          ),
                        if (_endDate != null)
                          _FilterChip(
                            label: AppLocalizations.of(context)!.dateTo(
                              date_utils.DateFormatters.formatDisplayDate(_endDate!),
                            ),
                            onRemove: () {
                              setState(() {
                                _endDate = null;
                              });
                            },
                          ),
                        if (_performedBy != null)
                          _FilterChip(
                            label: AppLocalizations.of(context)!.performedBy(_performedBy!),
                            onRemove: () {
                              setState(() {
                                _performedBy = null;
                              });
                            },
                          ),
                      ],
                    ),
                  ),
                // Expanded Filter Controls
                if (_filtersExpanded)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Column(
                      children: [
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _CompactDropdown<bool?>(
                                value: _completedOnly,
                                hint: AppLocalizations.of(context)!.status,
                                items: [
                                  DropdownMenuItem<bool?>(
                                    value: null,
                                    child: Text(AppLocalizations.of(context)!.all),
                                  ),
                                  DropdownMenuItem<bool?>(
                                    value: true,
                                    child: Text(AppLocalizations.of(context)!.completedOnly),
                                  ),
                                  DropdownMenuItem<bool?>(
                                    value: false,
                                    child: Text(AppLocalizations.of(context)!.pendingOnly),
                                  ),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    _completedOnly = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _CompactDateButton(
                                label: AppLocalizations.of(context)!.startDate,
                                date: _startDate,
                                onTap: () => _selectStartDate(context),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _CompactDateButton(
                                label: AppLocalizations.of(context)!.endDate,
                                date: _endDate,
                                onTap: () => _selectEndDate(context),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  context.push(RouteNames.monthlyCheckupCreate);
                },
                icon: const Icon(Icons.add),
                label: Text(AppLocalizations.of(context)!.createCheckup),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: checkupsAsync.when(
              data: (checkups) {
                if (checkups.isEmpty) {
                  return Center(
                    child: Text(
                      AppLocalizations.of(context)!.noMonthlyCheckupsFound,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: checkups.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: MonthlyCheckupCard(
                        checkup: checkups[index],
                      ),
                    );
                  },
                );
              },
              loading: () => LoadingIndicator(
                message: AppLocalizations.of(context)!.loadingMonthlyCheckups,
              ),
              error: (error, stack) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Error: $error'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          ref.invalidate(monthlyCheckupListProvider(params));
                        },
                        child: Text(AppLocalizations.of(context)!.retry),
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
}

// Compact Dropdown Widget
class _CompactDropdown<T> extends StatelessWidget {
  final T? value;
  final String hint;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;

  const _CompactDropdown({
    required this.value,
    required this.hint,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: DropdownButtonFormField<T>(
        value: value,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: AppColors.onSurfaceVariant.withOpacity(0.6),
            fontSize: 13,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
          isDense: true,
        ),
        items: items,
        onChanged: onChanged,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 13,
            ),
        icon: Icon(
          Icons.keyboard_arrow_down,
          size: 18,
          color: AppColors.onSurfaceVariant,
        ),
        dropdownColor: Theme.of(context).colorScheme.surface,
      ),
    );
  }
}

// Compact Date Button Widget
class _CompactDateButton extends StatelessWidget {
  final String label;
  final DateTime? date;
  final VoidCallback onTap;

  const _CompactDateButton({
    required this.label,
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 16,
                color: date != null
                    ? Theme.of(context).colorScheme.primary
                    : AppColors.onSurfaceVariant.withOpacity(0.6),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  date != null
                      ? date_utils.DateFormatters.formatDisplayDate(date!)
                      : label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 13,
                        color: date != null
                            ? Theme.of(context).colorScheme.onSurface
                            : AppColors.onSurfaceVariant.withOpacity(0.6),
                        fontWeight: date != null ? FontWeight.w500 : FontWeight.normal,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Filter Chip Widget
class _FilterChip extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;

  const _FilterChip({
    required this.label,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onRemove,
            child: Icon(
              Icons.close,
              size: 14,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
