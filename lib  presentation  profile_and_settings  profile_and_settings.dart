import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/logout_section_widget.dart';
import './widgets/profile_header_widget.dart';
import './widgets/profile_info_section_widget.dart';
import './widgets/settings_section_widget.dart';

/// Profile and Settings screen for Kachankawal Rural Municipality
/// Enables account management and app customization
class ProfileAndSettings extends StatefulWidget {
  const ProfileAndSettings({super.key});

  @override
  State<ProfileAndSettings> createState() => _ProfileAndSettingsState();
}

class _ProfileAndSettingsState extends State<ProfileAndSettings> {
  int _currentBottomNavIndex = 3; // Profile tab active

  // Mock user data
  final Map<String, dynamic> _userData = {
    "name": "राम बहादुर श्रेष्ठ",
    "nameEnglish": "Ram Bahadur Shrestha",
    "ward": "वडा नं. ५",
    "wardEnglish": "Ward No. 5",
    "phone": "+977 9841234567",
    "email": "ram.shrestha@example.com",
    "address": "कचनकवल गाउँपालिका, वडा नं. ५",
    "addressEnglish": "Kachankawal Rural Municipality, Ward No. 5",
    "citizenshipNo": "१२-०१-७५-०१२३४",
    "isVerified": true,
    "profileImage":
        "https://img.rocket.new/generatedImages/rocket_gen_img_15778eacb-1763293996121.png",
    "profileImageSemanticLabel":
        "Profile photo of a Nepali man with short black hair wearing traditional daura suruwal",
    "familyMembers": [
      {"name": "सीता श्रेष्ठ", "relation": "पत्नी", "age": 35},
      {"name": "अनिल श्रेष्ठ", "relation": "छोरा", "age": 12},
      {"name": "अनिता श्रेष्ठ", "relation": "छोरी", "age": 8}
    ],
    "linkedServices": [
      {"name": "जग्गा रेकर्ड", "status": "सक्रिय"},
      {"name": "कर भुक्तानी", "status": "सक्रिय"},
      {"name": "स्वास्थ्य सेवा", "status": "सक्रिय"}
    ]
  };

  // Settings state
  bool _biometricEnabled = false;
  bool _notificationsEnabled = true;
  bool _serviceUpdatesEnabled = true;
  bool _paymentRemindersEnabled = true;
  bool _emergencyAlertsEnabled = true;
  String _selectedLanguage = 'ne'; // 'ne' for Nepali, 'en' for English
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    // In production, load from SharedPreferences
    setState(() {
      _biometricEnabled = false;
      _notificationsEnabled = true;
      _serviceUpdatesEnabled = true;
      _paymentRemindersEnabled = true;
      _emergencyAlertsEnabled = true;
      _selectedLanguage = 'ne';
      _isDarkMode = false;
    });
  }

  Future<void> _saveSettings() async {
    // In production, save to SharedPreferences
    // For now, just show confirmation
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_selectedLanguage == 'ne'
              ? 'सेटिङ सुरक्षित गरियो'
              : 'Settings saved'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _handleLanguageChange(String language) {
    setState(() {
      _selectedLanguage = language;
    });
    _saveSettings();
  }

  void _handleBiometricToggle(bool value) {
    setState(() {
      _biometricEnabled = value;
    });
    _saveSettings();
  }

  void _handleNotificationToggle(String type, bool value) {
    setState(() {
      switch (type) {
        case 'all':
          _notificationsEnabled = value;
          break;
        case 'service':
          _serviceUpdatesEnabled = value;
          break;
        case 'payment':
          _paymentRemindersEnabled = value;
          break;
        case 'emergency':
          _emergencyAlertsEnabled = value;
          break;
      }
    });
    _saveSettings();
  }

  void _handleDarkModeToggle(bool value) {
    setState(() {
      _isDarkMode = value;
    });
    _saveSettings();
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final theme = Theme.of(context);
        return AlertDialog(
          title: Text(
            _selectedLanguage == 'ne' ? 'लगआउट गर्नुहोस्' : 'Logout',
            style: theme.textTheme.titleLarge,
          ),
          content: Text(
            _selectedLanguage == 'ne'
                ? 'के तपाईं निश्चित हुनुहुन्छ कि तपाईं लगआउट गर्न चाहनुहुन्छ? तपाईंको डाटा सुरक्षित रहनेछ।'
                : 'Are you sure you want to logout? Your data will remain secure.',
            style: theme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child:
                  Text(_selectedLanguage == 'ne' ? 'रद्द गर्नुहोस्' : 'Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(
                    context, '/login-and-otp-verification');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.error,
              ),
              child: Text(_selectedLanguage == 'ne' ? 'लगआउट' : 'Logout'),
            ),
          ],
        );
      },
    );
  }

  void _handleBottomNavTap(int index) {
    setState(() {
      _currentBottomNavIndex = index;
    });

    // Navigate to respective screens
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/dashboard');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/ward-information');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/land-and-property-search');
        break;
      case 3:
        // Already on profile screen
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar.home(
        title: _selectedLanguage == 'ne'
            ? 'प्रोफाइल र सेटिङ'
            : 'Profile & Settings',
        actions: [
          CustomAppBarActions.settings(
            onPressed: () {
              // Settings action already on this screen
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Profile Header
              ProfileHeaderWidget(
                userData: _userData,
                selectedLanguage: _selectedLanguage,
              ),
              SizedBox(height: 2.h),

              // Profile Information Section
              ProfileInfoSectionWidget(
                userData: _userData,
                selectedLanguage: _selectedLanguage,
                onEdit: () {
                  // Navigate to edit profile screen (not implemented)
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(_selectedLanguage == 'ne'
                          ? 'प्रोफाइल सम्पादन सुविधा आउँदैछ'
                          : 'Profile edit feature coming soon'),
                    ),
                  );
                },
              ),
              SizedBox(height: 2.h),

              // Settings Section
              SettingsSectionWidget(
                selectedLanguage: _selectedLanguage,
                biometricEnabled: _biometricEnabled,
                notificationsEnabled: _notificationsEnabled,
                serviceUpdatesEnabled: _serviceUpdatesEnabled,
                paymentRemindersEnabled: _paymentRemindersEnabled,
                emergencyAlertsEnabled: _emergencyAlertsEnabled,
                isDarkMode: _isDarkMode,
                onLanguageChange: _handleLanguageChange,
                onBiometricToggle: _handleBiometricToggle,
                onNotificationToggle: _handleNotificationToggle,
                onDarkModeToggle: _handleDarkModeToggle,
                onPasswordChange: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(_selectedLanguage == 'ne'
                          ? 'पासवर्ड परिवर्तन सुविधा आउँदैछ'
                          : 'Password change feature coming soon'),
                    ),
                  );
                },
                onHelpCenter: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(_selectedLanguage == 'ne'
                          ? 'सहायता केन्द्र आउँदैछ'
                          : 'Help center coming soon'),
                    ),
                  );
                },
                onFeedback: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(_selectedLanguage == 'ne'
                          ? 'प्रतिक्रिया फारम आउँदैछ'
                          : 'Feedback form coming soon'),
                    ),
                  );
                },
                onContact: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(_selectedLanguage == 'ne'
                          ? 'सम्पर्क जानकारी आउँदैछ'
                          : 'Contact information coming soon'),
                    ),
                  );
                },
              ),
              SizedBox(height: 2.h),

              // Logout Section
              LogoutSectionWidget(
                selectedLanguage: _selectedLanguage,
                onLogout: _handleLogout,
              ),
              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentBottomNavIndex,
        onTap: _handleBottomNavTap,
        items: [
          CustomBottomBarItem(
            label: _selectedLanguage == 'ne' ? 'ड्यासबोर्ड' : 'Dashboard',
            icon: Icons.home_outlined,
            activeIcon: Icons.home,
            route: '/dashboard',
          ),
          CustomBottomBarItem(
            label: _selectedLanguage == 'ne' ? 'वडा जानकारी' : 'Ward Info',
            icon: Icons.location_city_outlined,
            activeIcon: Icons.location_city,
            route: '/ward-information',
          ),
          CustomBottomBarItem(
            label: _selectedLanguage == 'ne' ? 'जग्गा खोज' : 'Land Search',
            icon: Icons.map_outlined,
            activeIcon: Icons.map,
            route: '/land-and-property-search',
          ),
          CustomBottomBarItem(
            label: _selectedLanguage == 'ne' ? 'प्रोफाइल' : 'Profile',
            icon: Icons.person_outline,
            activeIcon: Icons.person,
            route: '/profile-and-settings',
          ),
        ],
      ),
    );
  }
}
