import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/language_toggle_widget.dart';
import './widgets/otp_input_widget.dart';
import './widgets/phone_input_widget.dart';

/// Login and OTP Verification Screen
/// Enables secure citizen authentication through phone number and OTP verification
/// Optimized for rural users with biometric authentication support
class LoginAndOtpVerification extends StatefulWidget {
  const LoginAndOtpVerification({super.key});

  @override
  State<LoginAndOtpVerification> createState() =>
      _LoginAndOtpVerificationState();
}

class _LoginAndOtpVerificationState extends State<LoginAndOtpVerification> {
  // Controllers
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  // State variables
  bool _isOtpSent = false;
  bool _isLoading = false;
  bool _isResendEnabled = false;
  int _resendCountdown = 30;
  String _selectedLanguage = 'ne'; // 'ne' for Nepali, 'en' for English
  String? _errorMessage;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  /// Validates phone number format (10 digits)
  bool _isValidPhoneNumber(String phone) {
    return phone.length == 10 && RegExp(r'^[0-9]+$').hasMatch(phone);
  }

  /// Sends OTP to the provided phone number
  Future<void> _sendOtp() async {
    if (!_isValidPhoneNumber(_phoneController.text)) {
      setState(() {
        _errorMessage = _selectedLanguage == 'ne'
            ? 'कृपया मान्य फोन नम्बर प्रविष्ट गर्नुहोस्'
            : 'Please enter a valid phone number';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Simulate OTP sending
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
      _isOtpSent = true;
      _startResendCountdown();
    });

    HapticFeedback.lightImpact();
  }

  /// Starts countdown timer for OTP resend
  void _startResendCountdown() {
    setState(() {
      _resendCountdown = 30;
      _isResendEnabled = false;
    });

    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;

      setState(() {
        _resendCountdown--;
        if (_resendCountdown <= 0) {
          _isResendEnabled = true;
          HapticFeedback.lightImpact();
        }
      });

      return _resendCountdown > 0;
    });
  }

  /// Verifies OTP and navigates to dashboard
  Future<void> _verifyOtp() async {
    if (_otpController.text.length != 6) {
      setState(() {
        _errorMessage = _selectedLanguage == 'ne'
            ? 'कृपया ६ अंकको OTP प्रविष्ट गर्नुहोस्'
            : 'Please enter 6-digit OTP';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Simulate OTP verification
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Mock OTP verification (accept any 6-digit code for demo)
    setState(() {
      _isLoading = false;
    });

    HapticFeedback.mediumImpact();

    // Navigate to dashboard
    Navigator.pushReplacementNamed(context, '/dashboard');
  }

  /// Toggles between Nepali and English language
  void _toggleLanguage() {
    setState(() {
      _selectedLanguage = _selectedLanguage == 'ne' ? 'en' : 'ne';
    });
    HapticFeedback.selectionClick();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Language toggle
                Align(
                  alignment: Alignment.topRight,
                  child: LanguageToggleWidget(
                    selectedLanguage: _selectedLanguage,
                    onToggle: _toggleLanguage,
                  ),
                ),

                SizedBox(height: 4.h),

                // Municipality logo
                Center(
                  child: Container(
                    width: 30.w,
                    height: 30.w,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: 'account_balance',
                        size: 15.w,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 3.h),

                // Title
                Text(
                  _selectedLanguage == 'ne'
                      ? 'कचनकवल गाउँपालिका'
                      : 'Kachankawal Rural Municipality',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 1.h),

                // Subtitle
                Text(
                  _selectedLanguage == 'ne'
                      ? 'नागरिक सेवा पोर्टल'
                      : 'Citizen Service Portal',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 6.h),

                // Phone input or OTP input
                if (!_isOtpSent)
                  PhoneInputWidget(
                    controller: _phoneController,
                    selectedLanguage: _selectedLanguage,
                    onChanged: (value) {
                      setState(() {
                        _errorMessage = null;
                      });
                    },
                  )
                else
                  OtpInputWidget(
                    controller: _otpController,
                    selectedLanguage: _selectedLanguage,
                    phoneNumber: _phoneController.text,
                    resendCountdown: _resendCountdown,
                    isResendEnabled: _isResendEnabled,
                    onResend: _sendOtp,
                    onChanged: (value) {
                      setState(() {
                        _errorMessage = null;
                      });
                    },
                  ),

                // Error message
                if (_errorMessage != null) ...[
                  SizedBox(height: 2.h),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: theme.colorScheme.error.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'error_outline',
                          size: 20,
                          color: theme.colorScheme.error,
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                SizedBox(height: 4.h),

                // Action button
                SizedBox(
                  height: 6.h,
                  child: ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : (_isOtpSent ? _verifyOtp : _sendOtp),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 2,
                    ),
                    child: _isLoading
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                theme.colorScheme.onPrimary,
                              ),
                            ),
                          )
                        : Text(
                            _isOtpSent
                                ? (_selectedLanguage == 'ne'
                                    ? 'प्रमाणित गर्नुहोस्'
                                    : 'Verify OTP')
                                : (_selectedLanguage == 'ne'
                                    ? 'OTP पठाउनुहोस्'
                                    : 'Send OTP'),
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: theme.colorScheme.onPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),

                // Back button (only show in OTP screen)
                if (_isOtpSent) ...[
                  SizedBox(height: 2.h),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isOtpSent = false;
                        _otpController.clear();
                        _errorMessage = null;
                      });
                      HapticFeedback.lightImpact();
                    },
                    child: Text(
                      _selectedLanguage == 'ne'
                          ? 'फोन नम्बर परिवर्तन गर्नुहोस्'
                          : 'Change Phone Number',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],

                SizedBox(height: 4.h),

                // Help text
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: theme.colorScheme.outlineVariant
                          .withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'info_outline',
                        size: 20,
                        color: theme.colorScheme.primary,
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Text(
                          _selectedLanguage == 'ne'
                              ? 'तपाईंको दर्ता गरिएको मोबाइल नम्बर प्रयोग गर्नुहोस्। समस्या भएमा नगरपालिका कार्यालयमा सम्पर्क गर्नुहोस्।'
                              : 'Use your registered mobile number. Contact municipality office for any issues.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
