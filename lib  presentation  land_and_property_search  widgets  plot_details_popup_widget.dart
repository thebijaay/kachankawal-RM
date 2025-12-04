import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class PlotDetailsPopupWidget extends StatelessWidget {
  final Map<String, dynamic> plot;
  final VoidCallback onViewDetails;
  final VoidCallback onCalculateTax;
  final VoidCallback onPayOnline;
  final VoidCallback onClose;

  const PlotDetailsPopupWidget({
    super.key,
    required this.plot,
    required this.onViewDetails,
    required this.onCalculateTax,
    required this.onPayOnline,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Positioned(
      left: 4.w,
      right: 4.w,
      bottom: 12.h,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(3.w),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withValues(alpha: 0.16),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.vertical(top: Radius.circular(3.w)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          plot["plotNumber"] as String,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          plot["ownerName"] as String,
                          style: theme.textTheme.bodyMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: onClose,
                    icon: CustomIconWidget(
                      iconName: 'close',
                      color: theme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),

            // Details
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                children: [
                  _buildDetailRow(
                    context,
                    'ठेगाना:',
                    plot["address"] as String,
                  ),
                  SizedBox(height: 1.h),
                  _buildDetailRow(
                    context,
                    'क्षेत्रफल:',
                    '${plot["area"]} (${plot["areaSqm"]} वर्ग मिटर)',
                  ),
                  SizedBox(height: 1.h),
                  _buildDetailRow(
                    context,
                    'कर स्थिति:',
                    plot["taxStatus"] as String,
                    statusColor: (plot["taxStatus"] as String) == 'Paid'
                        ? theme.colorScheme.secondary
                        : theme.colorScheme.error,
                  ),
                  SizedBox(height: 1.h),
                  _buildDetailRow(
                    context,
                    'कर रकम:',
                    plot["taxAmount"] as String,
                  ),
                  SizedBox(height: 2.h),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: onViewDetails,
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 1.5.h),
                          ),
                          child: Text('विवरण हेर्नुहोस्'),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: onCalculateTax,
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 1.5.h),
                          ),
                          child: Text('कर गणना'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onPayOnline,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 1.5.h),
                      ),
                      child: Text('अनलाइन भुक्तानी'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value, {
    Color? statusColor,
  }) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 25.w,
          child: Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: statusColor,
            ),
          ),
        ),
      ],
    );
  }
}
