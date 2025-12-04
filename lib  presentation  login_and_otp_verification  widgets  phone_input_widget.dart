import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Phone number input widget with country code
/// Accepts 10-digit Nepali mobile number with +977 pre-filled
class PhoneInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final String selectedLanguage;
  final ValueChanged<String>? onChanged;

  const PhoneInputWidget({
    super.key,
    required this.controller,
    required this.selectedLanguage,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          selectedLanguage == 'ne' ? 'मोबाइल नम्बर' : 'Mobile Number',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurface,
          ),
        ),

        SizedBox(height: 1.h),

        // Phone input field
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              // Country code
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      color: theme.colorScheme.outline.withValues(alpha: 0.3),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      '🇳🇵',
                      style: TextStyle(fontSize: 20.sp),
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      '+977',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),

              // Phone number input
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  onChanged: onChanged,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface,
                  ),
                  decoration: InputDecoration(
                    hintText:
                        selectedLanguage == 'ne' ? '९८XXXXXXXX' : '98XXXXXXXX',
                    hintStyle: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant
                          .withValues(alpha: 0.5),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 2.h,
                    ),
                    counterText: '',
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(left: 2.w, right: 1.w),
                      child: CustomIconWidget(
                        iconName: 'phone_android',
                        size: 20,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    prefixIconConstraints: BoxConstraints(
                      minWidth: 8.w,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 1.h),

        // Helper text
        Text(
          selectedLanguage == 'ne'
              ? 'तपाईंको दर्ता गरिएको मोबाइल नम्बर प्रविष्ट गर्नुहोस्'
              : 'Enter your registered mobile number',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
