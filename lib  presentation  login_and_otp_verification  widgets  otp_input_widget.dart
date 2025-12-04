import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// OTP input widget with 6-digit verification
/// Includes auto-focus progression and paste functionality
class OtpInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final String selectedLanguage;
  final String phoneNumber;
  final int resendCountdown;
  final bool isResendEnabled;
  final VoidCallback onResend;
  final ValueChanged<String>? onChanged;

  const OtpInputWidget({
    super.key,
    required this.controller,
    required this.selectedLanguage,
    required this.phoneNumber,
    required this.resendCountdown,
    required this.isResendEnabled,
    required this.onResend,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final defaultPinTheme = PinTheme(
      width: 12.w,
      height: 6.h,
      textStyle: theme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w600,
        color: theme.colorScheme.onSurface,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        border: Border.all(
          color: theme.colorScheme.primary,
          width: 2,
        ),
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: theme.colorScheme.primary.withValues(alpha: 0.1),
        border: Border.all(
          color: theme.colorScheme.primary,
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          selectedLanguage == 'ne' ? 'OTP प्रमाणीकरण' : 'OTP Verification',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurface,
          ),
        ),

        SizedBox(height: 1.h),

        // Instruction text
        RichText(
          text: TextSpan(
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            children: [
              TextSpan(
                text: selectedLanguage == 'ne'
                    ? 'हामीले '
                    : 'We have sent a 6-digit code to ',
              ),
              TextSpan(
                text: '+977 $phoneNumber',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 3.h),

        // OTP input
        Center(
          child: Pinput(
            controller: controller,
            length: 6,
            defaultPinTheme: defaultPinTheme,
            focusedPinTheme: focusedPinTheme,
            submittedPinTheme: submittedPinTheme,
            onChanged: onChanged,
            hapticFeedbackType: HapticFeedbackType.lightImpact,
            keyboardType: TextInputType.number,
            autofocus: true,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
          ),
        ),

        SizedBox(height: 3.h),

        // Resend OTP section
        Center(
          child: isResendEnabled
              ? TextButton.icon(
                  onPressed: onResend,
                  icon: CustomIconWidget(
                    iconName: 'refresh',
                    size: 18,
                    color: theme.colorScheme.primary,
                  ),
                  label: Text(
                    selectedLanguage == 'ne'
                        ? 'OTP पुन: पठाउनुहोस्'
                        : 'Resend OTP',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'schedule',
                      size: 18,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      selectedLanguage == 'ne'
                          ? 'पुन: पठाउनुहोस् $resendCountdown सेकेन्डमा'
                          : 'Resend in $resendCountdown seconds',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}
