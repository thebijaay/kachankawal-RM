import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class FilterOptionsWidget extends StatefulWidget {
  final String selectedPlotSize;
  final String selectedTaxStatus;
  final String selectedOwnershipType;
  final Function(String, String, String) onApplyFilters;
  final VoidCallback onClose;

  const FilterOptionsWidget({
    super.key,
    required this.selectedPlotSize,
    required this.selectedTaxStatus,
    required this.selectedOwnershipType,
    required this.onApplyFilters,
    required this.onClose,
  });

  @override
  State<FilterOptionsWidget> createState() => _FilterOptionsWidgetState();
}

class _FilterOptionsWidgetState extends State<FilterOptionsWidget> {
  late String _plotSize;
  late String _taxStatus;
  late String _ownershipType;

  @override
  void initState() {
    super.initState();
    _plotSize = widget.selectedPlotSize;
    _taxStatus = widget.selectedTaxStatus;
    _ownershipType = widget.selectedOwnershipType;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(4.w)),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withValues(alpha: 0.16),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Padding(
                padding: EdgeInsets.all(4.w),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'फिल्टर विकल्पहरू',
                        style: theme.textTheme.titleLarge,
                      ),
                    ),
                    IconButton(
                      onPressed: widget.onClose,
                      icon: CustomIconWidget(
                        iconName: 'close',
                        color: theme.colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 1,
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
              ),

              // Filter options
              Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Plot size filter
                    Text(
                      'प्लट आकार',
                      style: theme.textTheme.titleMedium,
                    ),
                    SizedBox(height: 1.h),
                    Wrap(
                      spacing: 2.w,
                      runSpacing: 1.h,
                      children: ['All', 'Small', 'Medium', 'Large'].map((size) {
                        return ChoiceChip(
                          label: Text(_getPlotSizeLabel(size)),
                          selected: _plotSize == size,
                          onSelected: (selected) {
                            setState(() {
                              _plotSize = size;
                            });
                          },
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 2.h),

                    // Tax status filter
                    Text(
                      'कर स्थिति',
                      style: theme.textTheme.titleMedium,
                    ),
                    SizedBox(height: 1.h),
                    Wrap(
                      spacing: 2.w,
                      runSpacing: 1.h,
                      children: ['All', 'Paid', 'Due'].map((status) {
                        return ChoiceChip(
                          label: Text(_getTaxStatusLabel(status)),
                          selected: _taxStatus == status,
                          onSelected: (selected) {
                            setState(() {
                              _taxStatus = status;
                            });
                          },
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 2.h),

                    // Ownership type filter
                    Text(
                      'स्वामित्व प्रकार',
                      style: theme.textTheme.titleMedium,
                    ),
                    SizedBox(height: 1.h),
                    Wrap(
                      spacing: 2.w,
                      runSpacing: 1.h,
                      children: ['All', 'Private', 'Agricultural', 'Commercial']
                          .map((type) {
                        return ChoiceChip(
                          label: Text(_getOwnershipTypeLabel(type)),
                          selected: _ownershipType == type,
                          onSelected: (selected) {
                            setState(() {
                              _ownershipType = type;
                            });
                          },
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 3.h),

                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                _plotSize = 'All';
                                _taxStatus = 'All';
                                _ownershipType = 'All';
                              });
                            },
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 1.5.h),
                            ),
                            child: Text('रिसेट गर्नुहोस्'),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: () {
                              widget.onApplyFilters(
                                  _plotSize, _taxStatus, _ownershipType);
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 1.5.h),
                            ),
                            child: Text('लागू गर्नुहोस्'),
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
      ),
    );
  }

  String _getPlotSizeLabel(String size) {
    switch (size) {
      case 'All':
        return 'सबै';
      case 'Small':
        return 'सानो (< 400 वर्ग मिटर)';
      case 'Medium':
        return 'मध्यम (400-600 वर्ग मिटर)';
      case 'Large':
        return 'ठूलो (> 600 वर्ग मिटर)';
      default:
        return size;
    }
  }

  String _getTaxStatusLabel(String status) {
    switch (status) {
      case 'All':
        return 'सबै';
      case 'Paid':
        return 'भुक्तानी भएको';
      case 'Due':
        return 'बाँकी';
      default:
        return status;
    }
  }

  String _getOwnershipTypeLabel(String type) {
    switch (type) {
      case 'All':
        return 'सबै';
      case 'Private':
        return 'निजी';
      case 'Agricultural':
        return 'कृषि';
      case 'Commercial':
        return 'व्यावसायिक';
      default:
        return type;
    }
  }
}
