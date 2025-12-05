
import 'package:flutter/material.dart';
import 'package:gestion_documentaire/src/domain/local/Categorie.dart';
import 'package:gestion_documentaire/src/domain/local/Document.dart';
import 'package:gestion_documentaire/src/domain/local/QuickStats.dart';
import '/src/presentation/screens/home_pages/home_screen.dart';
import '/src/utils/consts/app_specifications/all_directories.dart';
import '/src/utils/consts/routes/app_routes_name.dart';

class HomeScreenData{
    List<QuickStat> quickStats = [
    QuickStat(
      icon: Icons.insert_drive_file_rounded,
      label: 'Documents',
      value: '128',
      trend: '+12%',
      accent: AppColors.mainAppColor,
    ),
    QuickStat(
      icon: Icons.verified_user_rounded,
      label: 'Approbations',
      value: '8',
      trend: '2 en attente',
      accent: AppColors.accentTeal,
    ),
    QuickStat(
      icon: Icons.cloud_done_rounded,
      label: 'Stockage',
      value: '82%',
      trend: '18% libre',
      accent: AppColors.accentPurple,
    ),
  ];

   List<CategoryCardData> categories = [
    CategoryCardData(
      title: 'Tous les documents',
      icon: Icons.folder_open_rounded,
      route: AppRoutesName.documentPage,
      gradient: [AppColors.mainBlueFirst, AppColors.secondAppColor],
    ),
    CategoryCardData(
      title: 'Compte rendu',
      icon: Icons.task_alt_rounded,
      route: AppRoutesName.documentPage,
      gradient: [AppColors.accentTeal, Color(0xFF0BB6D9)],
    ),
    CategoryCardData(
      title: 'Rapport',
      icon: Icons.verified_rounded,
      route: AppRoutesName.documentPage,
      gradient: [AppColors.accentOrange, Color(0xFFFFD28C)],
    ),
   CategoryCardData(
      title: 'Présentation de projet',
      icon: Icons.archive_outlined,
      route: AppRoutesName.documentPage,
      gradient: [Color(0xFF4E65FF), Color(0xFF92EFFD)],
    ),
  ];
   List<CategoryCardData> evenement = [
    CategoryCardData(
      title: 'Tous les événements',
      icon: Icons.folder_open_rounded,
      route: AppRoutesName.documentPage,
      gradient: [AppColors.mainBlueFirst, AppColors.secondAppColor],
    ),
    CategoryCardData(
      title: 'Rentrée Numérique',
      icon: Icons.task_alt_rounded,
      route: AppRoutesName.documentPage,
      gradient: [Colors.purple, Color(0xFFC15BE3)],
    ),
    CategoryCardData(
      title: 'TRADE FACILITATION CONFERENCE',
      icon: Icons.verified_rounded,
      route: AppRoutesName.documentPage,
      gradient: [Colors.orange, Color(0xFFFFD28C)],
    ),
    CategoryCardData(
      title: 'Forum Invest in Sénégal',
      icon: Icons.archive_outlined,
      route: AppRoutesName.documentPage,
      gradient: [Colors.blue, Color(0xFF92EFFD)],
    ),
  ];

 List<RecentDocument> recentDocuments = [
    RecentDocument(
      title: 'Project charter.pdf',
      subtitle: 'Mis à jour il y a 2 h • 2,4 Mo',
      progress: 0.82,
      accentColor: AppColors.mainAppColor,
    ),
    RecentDocument(
      title: 'Legal contract.docx',
      subtitle: 'Marketing • 1,1 Mo',
      progress: 0.38,
      accentColor: AppColors.accentTeal,
    ),
    RecentDocument(
      title: 'Rapport annuel.ppt',
      subtitle: 'Finance • 34 Mo',
      progress: 0.64,
      accentColor: AppColors.accentPurple,
    ),
  ];

}