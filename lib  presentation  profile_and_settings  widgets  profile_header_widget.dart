import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Profile header widget displaying user photo, name, ward, and verification status
class ProfileHeaderWidget extends StatelessWidget {
  final Map<String, dynamic> userData;
  final String selectedLanguage;

  const ProfileHeaderWidget({
    super.key,
    required this.userData,
    required this.selectedLanguage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primaryContainer,
          ],
        ),
      ),
      child: Column(
        children: [
          // Profile Image
          Stack(
            children: [
              Container(
                width: 25.w,
                height: 25.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: theme.colorScheme.onPrimary,
                    width: 3,
                  ),
                ),
                child: ClipOval(
                  child: CustomImageWidget(
                    imageUrl: userData["profileImage"] as String? ?? "",
                    width: 25.w,
                    height: 25.w,
                    fit: BoxFit.cover,
                    semanticLabel:
                        userData["profileImageSemanticLabel"] as String? ??
                            "User profile photo",
                  ),
                ),
              ),
              if (userData["isVerified"] == true)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(1.w),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.colorScheme.onPrimary,
                        width: 2,
                      ),
                    ),
                    child: CustomIconWidget(
                      iconName: 'verified',
                      color: theme.colorScheme.onSecondary,
                      size: 4.w,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 2.h),

          // User Name
          Text(
            selectedLanguage == 'ne'
                ? (userData["name"] as String? ?? "")
                : (userData["nameEnglish"] as String? ?? ""),
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onPrimary,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 0.5.h),

          // Ward Information
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: 'location_on',
                color: theme.colorScheme.onPrimary.withValues(alpha: 0.8),
                size: 4.w,
              ),
              SizedBox(width: 1.w),
              Text(
                selectedLanguage == 'ne'
                    ? (userData["ward"] as String? ?? "")
                    : (userData["wardEnglish"] as String? ?? ""),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onPrimary.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),

          // Verification Badge
          if (userData["isVerified"] == true)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: theme.colorScheme.onPrimary.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: 'check_circle',
                    color: theme.colorScheme.onPrimary,
                    size: 4.w,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    selectedLanguage == 'ne'
                        ? 'प्रमाणित नागरिक'
                        : 'Verified Citizen',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onPrimary,
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
