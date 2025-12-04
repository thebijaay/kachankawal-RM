import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Settings section with grouped options
class SettingsSectionWidget extends StatelessWidget {
  final String selectedLanguage;
  final bool biometricEnabled;
  final bool notificationsEnabled;
  final bool serviceUpdatesEnabled;
  final bool paymentRemindersEnabled;
  final bool emergencyAlertsEnabled;
  final bool isDarkMode;
  final Function(String) onLanguageChange;
  final Function(bool) onBiometricToggle;
  final Function(String, bool) onNotificationToggle;
  final Function(bool) onDarkModeToggle;
  final VoidCallback onPasswordChange;
  final VoidCallback onHelpCenter;
  final VoidCallback onFeedback;
  final VoidCallback onContact;

  const SettingsSectionWidget({
    super.key,
    required this.selectedLanguage,
    required this.biometricEnabled,
    required this.notificationsEnabled,
    required this.serviceUpdatesEnabled,
    required this.paymentRemindersEnabled,
    required this.emergencyAlertsEnabled,
    required this.isDarkMode,
    required this.onLanguageChange,
    required this.onBiometricToggle,
    required this.onNotificationToggle,
    required this.onDarkModeToggle,
    required this.onPasswordChange,
    required this.onHelpCenter,
    required this.onFeedback,
    required this.onContact,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Account Settings
        _buildSettingsGroup(
          context,
          title: selectedLanguage == 'ne' ? 'खाता' : 'Account',
          items: [
            _buildSettingItem(
              context,
              icon: 'lock',
              title: selectedLanguage == 'ne'
                  ? 'पासवर्ड परिवर्तन गर्नुहोस्'
                  : 'Change Password',
              trailing: CustomIconWidget(
                iconName: 'chevron_right',
                color: theme.colorScheme.onSurfaceVariant,
                size: 5.w,
              ),
              onTap: onPasswordChange,
            ),
            _buildSettingItem(
              context,
              icon: 'fingerprint',
              title: selectedLanguage == 'ne'
                  ? 'बायोमेट्रिक प्रमाणीकरण'
                  : 'Biometric Authentication',
              trailing: Switch(
                value: biometricEnabled,
                onChanged: onBiometricToggle,
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),

        // Preferences
        _buildSettingsGroup(
          context,
          title: selectedLanguage == 'ne' ? 'प्राथमिकताहरू' : 'Preferences',
          items: [
            _buildSettingItem(
              context,
              icon: 'language',
              title: selectedLanguage == 'ne' ? 'भाषा' : 'Language',
              subtitle: selectedLanguage == 'ne' ? 'नेपाली' : 'English',
              trailing: CustomIconWidget(
                iconName: 'chevron_right',
                color: theme.colorScheme.onSurfaceVariant,
                size: 5.w,
              ),
              onTap: () => _showLanguageDialog(context),
            ),
            _buildSettingItem(
              context,
              icon: 'dark_mode',
              title: selectedLanguage == 'ne' ? 'डार्क मोड' : 'Dark Mode',
              trailing: Switch(
                value: isDarkMode,
                onChanged: onDarkModeToggle,
              ),
            ),
            _buildSettingItem(
              context,
              icon: 'notifications',
              title: selectedLanguage == 'ne' ? 'सूचनाहरू' : 'Notifications',
              trailing: CustomIconWidget(
                iconName: 'chevron_right',
                color: theme.colorScheme.onSurfaceVariant,
                size: 5.w,
              ),
              onTap: () => _showNotificationSettings(context),
            ),
          ],
        ),
        SizedBox(height: 2.h),

        // Support
        _buildSettingsGroup(
          context,
          title: selectedLanguage == 'ne' ? 'समर्थन' : 'Support',
          items: [
            _buildSettingItem(
              context,
              icon: 'help',
              title:
                  selectedLanguage == 'ne' ? 'सहायता केन्द्र' : 'Help Center',
              trailing: CustomIconWidget(
                iconName: 'chevron_right',
                color: theme.colorScheme.onSurfaceVariant,
                size: 5.w,
              ),
              onTap: onHelpCenter,
            ),
            _buildSettingItem(
              context,
              icon: 'feedback',
              title: selectedLanguage == 'ne' ? 'प्रतिक्रिया' : 'Feedback',
              trailing: CustomIconWidget(
                iconName: 'chevron_right',
                color: theme.colorScheme.onSurfaceVariant,
                size: 5.w,
              ),
              onTap: onFeedback,
            ),
            _buildSettingItem(
              context,
              icon: 'contact_support',
              title:
                  selectedLanguage == 'ne' ? 'सम्पर्क गर्नुहोस्' : 'Contact Us',
              trailing: CustomIconWidget(
                iconName: 'chevron_right',
                color: theme.colorScheme.onSurfaceVariant,
                size: 5.w,
              ),
              onTap: onContact,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSettingsGroup(
    BuildContext context, {
    required String title,
    required List<Widget> items,
  }) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          ...items,
        ],
      ),
    );
  }

  Widget _buildSettingItem(
    BuildContext context, {
    required String icon,
    required String title,
    String? subtitle,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 10.w,
              height: 10.w,
              decoration: BoxDecoration(
                color:
                    theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: icon,
                  color: theme.colorScheme.primary,
                  size: 5.w,
                ),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: 0.5.h),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            selectedLanguage == 'ne' ? 'भाषा छान्नुहोस्' : 'Select Language',
            style: theme.textTheme.titleLarge,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: const Text('नेपाली'),
                value: 'ne',
                groupValue: selectedLanguage,
                onChanged: (value) {
                  if (value != null) {
                    onLanguageChange(value);
                    Navigator.of(context).pop();
                  }
                },
              ),
              RadioListTile<String>(
                title: const Text('English'),
                value: 'en',
                groupValue: selectedLanguage,
                onChanged: (value) {
                  if (value != null) {
                    onLanguageChange(value);
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showNotificationSettings(BuildContext context) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: EdgeInsets.all(4.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedLanguage == 'ne'
                        ? 'सूचना सेटिङ'
                        : 'Notification Settings',
                    style: theme.textTheme.titleLarge,
                  ),
                  SizedBox(height: 2.h),
                  SwitchListTile(
                    title: Text(selectedLanguage == 'ne'
                        ? 'सबै सूचनाहरू'
                        : 'All Notifications'),
                    value: notificationsEnabled,
                    onChanged: (value) {
                      setModalState(() {
                        onNotificationToggle('all', value);
                      });
                    },
                  ),
                  SwitchListTile(
                    title: Text(selectedLanguage == 'ne'
                        ? 'सेवा अपडेटहरू'
                        : 'Service Updates'),
                    value: serviceUpdatesEnabled,
                    onChanged: notificationsEnabled
                        ? (value) {
                            setModalState(() {
                              onNotificationToggle('service', value);
                            });
                          }
                        : null,
                  ),
                  SwitchListTile(
                    title: Text(selectedLanguage == 'ne'
                        ? 'भुक्तानी रिमाइन्डर'
                        : 'Payment Reminders'),
                    value: paymentRemindersEnabled,
                    onChanged: notificationsEnabled
                        ? (value) {
                            setModalState(() {
                              onNotificationToggle('payment', value);
                            });
                          }
                        : null,
                  ),
                  SwitchListTile(
                    title: Text(selectedLanguage == 'ne'
                        ? 'आपतकालीन अलर्ट'
                        : 'Emergency Alerts'),
                    value: emergencyAlertsEnabled,
                    onChanged: notificationsEnabled
                        ? (value) {
                            setModalState(() {
                              onNotificationToggle('emergency', value);
                            });
                          }
                        : null,
                  ),
                  SizedBox(height: 2.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(selectedLanguage == 'ne'
                          ? 'बन्द गर्नुहोस्'
                          : 'Close'),
                    ),
                  ),
                  SizedBox(height: 2.h),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
