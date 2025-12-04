import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Logout section widget with confirmation dialog
class LogoutSectionWidget extends StatelessWidget {
  final String selectedLanguage;
  final VoidCallback onLogout;

  const LogoutSectionWidget({
    super.key,
    required this.selectedLanguage,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: ElevatedButton(
        onPressed: onLogout,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.error,
          foregroundColor: theme.colorScheme.onError,
          minimumSize: Size(double.infinity, 6.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'logout',
              color: theme.colorScheme.onError,
              size: 5.w,
            ),
            SizedBox(width: 2.w),
            Text(
              selectedLanguage == 'ne' ? 'लगआउट गर्नुहोस्' : 'Logout',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onError,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
