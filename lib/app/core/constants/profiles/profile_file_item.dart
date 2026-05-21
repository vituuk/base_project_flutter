import 'package:flutter/material.dart';

/// Model and seed data for the Files tab on the profile page.
class ProfileFileItem {
  final String fileName;
  final String fileSize;
  final String fileDate;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;

  const ProfileFileItem({
    required this.fileName,
    required this.fileSize,
    required this.fileDate,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
  });
}

const List<ProfileFileItem> kProfileFileItems = [
  ProfileFileItem(
    fileName: 'Project_Brief_v1.pdf',
    fileSize: '1.2 MB',
    fileDate: 'Jan 10',
    icon: Icons.description_rounded,
    iconColor: Color(0xFF2046E8),
    iconBgColor: Color(0xFFEFF6FF),
  ),
  ProfileFileItem(
    fileName: 'Q4_Budget_Final.xlsx',
    fileSize: '850 KB',
    fileDate: 'Jan 8',
    icon: Icons.table_chart_rounded,
    iconColor: Color(0xFF10B981),
    iconBgColor: Color(0xFFECFDF5),
  ),
  ProfileFileItem(
    fileName: 'Brand_Guidelines.zip',
    fileSize: '15.4 MB',
    fileDate: 'Jan 5',
    icon: Icons.folder_zip_rounded,
    iconColor: Color(0xFFF59E0B),
    iconBgColor: Color(0xFFFEF3C7),
  ),
  ProfileFileItem(
    fileName: 'Meeting_Notes.docx',
    fileSize: '45 KB',
    fileDate: 'Jan 3',
    icon: Icons.article_rounded,
    iconColor: Color(0xFF3B82F6),
    iconBgColor: Color(0xFFEFF6FF),
  ),
];
