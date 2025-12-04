import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Profile information section with editable fields
class ProfileInfoSectionWidget extends StatelessWidget {
  final Map<String, dynamic> userData;
  final String selectedLanguage;
  final VoidCallback onEdit;

  const ProfileInfoSectionWidget({
    super.key,
    required this.userData,
    required this.selectedLanguage,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
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
          // Section Header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedLanguage == 'ne'
                      ? 'व्यक्तिगत जानकारी'
                      : 'Personal Information',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                InkWell(
                  onTap: onEdit,
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: EdgeInsets.all(2.w),
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'edit',
                          color: theme.colorScheme.primary,
                          size: 4.w,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          selectedLanguage == 'ne' ? 'सम्पादन' : 'Edit',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
              height: 1,
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3)),

          // Contact Details
          _buildInfoItem(
            context,
            icon: 'phone',
            label: selectedLanguage == 'ne' ? 'फोन नम्बर' : 'Phone Number',
            value: userData["phone"] as String? ?? "",
          ),
          _buildInfoItem(
            context,
            icon: 'email',
            label: selectedLanguage == 'ne' ? 'इमेल' : 'Email',
            value: userData["email"] as String? ?? "",
          ),
          _buildInfoItem(
            context,
            icon: 'home',
            label: selectedLanguage == 'ne' ? 'ठेगाना' : 'Address',
            value: selectedLanguage == 'ne'
                ? (userData["address"] as String? ?? "")
                : (userData["addressEnglish"] as String? ?? ""),
          ),
          _buildInfoItem(
            context,
            icon: 'badge',
            label:
                selectedLanguage == 'ne' ? 'नागरिकता नं.' : 'Citizenship No.',
            value: userData["citizenshipNo"] as String? ?? "",
          ),

          // Family Members
          if (userData["familyMembers"] != null &&
              (userData["familyMembers"] as List).isNotEmpty) ...[
            Divider(
                height: 1,
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3)),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedLanguage == 'ne'
                        ? 'परिवारका सदस्यहरू'
                        : 'Family Members',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  ...(userData["familyMembers"] as List).map((member) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 1.h),
                      child: Row(
                        children: [
                          Container(
                            width: 8.w,
                            height: 8.w,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primaryContainer
                                  .withValues(alpha: 0.3),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: CustomIconWidget(
                                iconName: 'person',
                                color: theme.colorScheme.primary,
                                size: 4.w,
                              ),
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  member["name"] as String? ?? "",
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  "${member["relation"] as String? ?? ""} • ${member["age"]} ${selectedLanguage == 'ne' ? 'वर्ष' : 'years'}",
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ],

          // Linked Services
          if (userData["linkedServices"] != null &&
              (userData["linkedServices"] as List).isNotEmpty) ...[
            Divider(
                height: 1,
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3)),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedLanguage == 'ne'
                        ? 'जडान गरिएका सेवाहरू'
                        : 'Linked Services',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  ...(userData["linkedServices"] as List).map((service) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 1.h),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'check_circle',
                            color: theme.colorScheme.secondary,
                            size: 4.w,
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: Text(
                              service["name"] as String? ?? "",
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 0.5.h),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.secondary
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              service["status"] as String? ?? "",
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.secondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoItem(
    BuildContext context, {
    required String icon,
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8.w,
            height: 8.w,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: icon,
                color: theme.colorScheme.primary,
                size: 4.w,
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
