import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gestion_documentaire/src/utils/consts/app_specifications/all_directories.dart';
import 'package:gestion_documentaire/src/utils/consts/routes/app_routes_name.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const List<_QuickStat> _quickStats = [
    _QuickStat(
      icon: Icons.insert_drive_file_rounded,
      label: 'Documents',
      value: '128',
      trend: '+12%',
      accent: AppColors.mainAppColor,
    ),
    _QuickStat(
      icon: Icons.verified_user_rounded,
      label: 'Approbations',
      value: '8',
      trend: '2 en attente',
      accent: AppColors.accentTeal,
    ),
    _QuickStat(
      icon: Icons.cloud_done_rounded,
      label: 'Stockage',
      value: '82%',
      trend: '18% libre',
      accent: AppColors.accentPurple,
    ),
  ];

  static const List<_CategoryCardData> _categories = [
    _CategoryCardData(
      title: 'Tous les documents',
      icon: Icons.folder_open_rounded,
      route: AppRoutesName.documentPage,
      gradient: [AppColors.mainAppColor, AppColors.secondAppColor],
    ),
    _CategoryCardData(
      title: 'Compte rendu',
      icon: Icons.task_alt_rounded,
      route: AppRoutesName.documentPage,
      gradient: [AppColors.accentTeal, Color(0xFF0BB6D9)],
    ),
    _CategoryCardData(
      title: 'Rapport',
      icon: Icons.verified_rounded,
      route: AppRoutesName.documentPage,
      gradient: [AppColors.accentOrange, Color(0xFFFFD28C)],
    ),
    _CategoryCardData(
      title: 'Présentation de projet',
      icon: Icons.archive_outlined,
      route: AppRoutesName.documentPage,
      gradient: [Color(0xFF4E65FF), Color(0xFF92EFFD)],
    ),
  ];
  static const List<_CategoryCardData> _evenement = [
    _CategoryCardData(
      title: 'Tous les événements',
      icon: Icons.folder_open_rounded,
      route: AppRoutesName.documentPage,
      gradient: [AppColors.mainAppColor, AppColors.secondAppColor],
    ),
    _CategoryCardData(
      title: 'Rentrée Numérique',
      icon: Icons.task_alt_rounded,
      route: AppRoutesName.documentPage,
      gradient: [Colors.purple, Color(0xFFC15BE3)],
    ),
    _CategoryCardData(
      title: 'TRADE FACILITATION CONFERENCE',
      icon: Icons.verified_rounded,
      route: AppRoutesName.documentPage,
      gradient: [Colors.orange, Color(0xFFFFD28C)],
    ),
    _CategoryCardData(
      title: 'Forum Invest in Sénégal',
      icon: Icons.archive_outlined,
      route: AppRoutesName.documentPage,
      gradient: [Colors.blue, Color(0xFF92EFFD)],
    ),
  ];

  static const List<_RecentDocument> _recentDocuments = [
    _RecentDocument(
      title: 'Project charter.pdf',
      subtitle: 'Mis à jour il y a 2 h • 2,4 Mo',
      progress: 0.82,
      accentColor: AppColors.mainAppColor,
    ),
    _RecentDocument(
      title: 'Legal contract.docx',
      subtitle: 'Marketing • 1,1 Mo',
      progress: 0.38,
      accentColor: AppColors.accentTeal,
    ),
    _RecentDocument(
      title: 'Rapport annuel.ppt',
      subtitle: 'Finance • 34 Mo',
      progress: 0.64,
      accentColor: AppColors.accentPurple,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBackgroundColor,
      body: Stack(
        children: [
          _BackgroundDecor(),
          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimensions.paddingLarge),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(context),
                        const SizedBox(height: AppDimensions.paddingLarge),
                        _buildHeroCard(),
                        const SizedBox(height: AppDimensions.paddingLarge),
                        _buildSearchBar(),
                        const SizedBox(height: AppDimensions.paddingLarge),
                        _buildQuickStats(),
                        const SizedBox(height: AppDimensions.paddingLarge),
                        _buildSectionTitle('Documents récents',
                            actionLabel: 'Tout voir'),
                        const SizedBox(height: AppDimensions.paddingMedium),
                        _buildRecentDocuments(),
                        const SizedBox(height: AppDimensions.paddingLarge),
                        _buildSectionTitle('Événement', actionLabel: 'Gérer'),
                        const SizedBox(height: AppDimensions.paddingMedium),
                        _buildEvenementGrid(context),
                        const SizedBox(height: AppDimensions.paddingLarge),
                        _buildSectionTitle('Catégories', actionLabel: 'Gérer'),
                        const SizedBox(height: AppDimensions.paddingMedium),
                        _buildCategoryGrid(context),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bon retour,',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textMainPageColor,
              ),
            ),
            Text(
              'Votre espace de travail',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.loginTitleColor,
              ),
            ),
          ],
        ),
        InkWell(
          onTap: () => Navigator.pushNamed(context, AppRoutesName.profilePage),
          borderRadius: BorderRadius.circular(30),
          child: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            foregroundImage: AssetImage(AppImages.PROFIL_IMAGES),
          ),
        ),
      ],
    );
  }

  Widget _buildHeroCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge + 12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppDimensions.paddingLarge),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.mainAppColor.withOpacity(0.92),
                AppColors.secondAppColor.withOpacity(0.9),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius:
                BorderRadius.circular(AppDimensions.borderRadiusLarge + 12),
            boxShadow: [
              BoxShadow(
                color: AppColors.mainAppColor.withOpacity(0.24),
                blurRadius: 28,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Automatisation documentaire',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.paddingSmall / 2),
                    const Text(
                      'Gardez tout organisé',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.paddingMedium),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingMedium,
                        vertical: AppDimensions.paddingSmall / 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.14),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.bolt, color: Colors.white, size: 16),
                          SizedBox(width: 6),
                          Text(
                            '4 flux actifs',
                            style: TextStyle(color: Colors.white, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppDimensions.paddingMedium),
              Container(
                padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.analytics_outlined,
                    color: Colors.white, size: 34),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 14,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Rechercher fichiers, tags ou collègues',
                hintStyle: TextStyle(color: Colors.black38),
                prefixIcon: Icon(Icons.search_rounded, color: Colors.black54),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingMedium,
                  vertical: AppDimensions.paddingMedium,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: AppDimensions.paddingSmall),
            decoration: BoxDecoration(
              color: AppColors.mainAppColor.withOpacity(0.12),
              borderRadius:
                  BorderRadius.circular(AppDimensions.borderRadiusLarge),
            ),
            child: IconButton(
              onPressed: () {},
              icon:
                  const Icon(Icons.tune_rounded, color: AppColors.mainAppColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Row(
      children: List.generate(_quickStats.length, (index) {
        final stat = _quickStats[index];
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: index == _quickStats.length - 1
                  ? 0
                  : AppDimensions.paddingMedium / 2,
            ),
            child: _StatCard(stat: stat),
          ),
        );
      }),
    );
  }

  Widget _buildSectionTitle(String title, {String? actionLabel}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.loginTitleColor,
          ),
        ),
        if (actionLabel != null)
          TextButton(
            onPressed: () {},
            child: Text(
              actionLabel,
              style: TextStyle(
                color: AppColors.mainAppColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildRecentDocuments() {
    return SizedBox(
      height: 190,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _recentDocuments.length,
        separatorBuilder: (_, __) =>
            const SizedBox(width: AppDimensions.paddingMedium),
        itemBuilder: (context, index) {
          final doc = _recentDocuments[index];
          return _RecentDocumentCard(document: doc);
        },
      ),
    );
  }

  Widget _buildCategoryGrid(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppDimensions.paddingMedium,
        mainAxisSpacing: AppDimensions.paddingMedium,
        childAspectRatio: 2.1,
        // childAspectRatio: 1.2,
      ),
      itemCount: _categories.length,
      itemBuilder: (context, index) {
        final category = _categories[index];
        return InkWell(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
          onTap: () => Navigator.pushNamed(context, category.route),
          child: Container(
            padding: const EdgeInsets.all(AppDimensions.paddingLarge),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: category.gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius:
                  BorderRadius.circular(AppDimensions.borderRadiusLarge),
              boxShadow: [
                BoxShadow(
                  color: category.gradient.last.withOpacity(0.25),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(AppDimensions.paddingSmall),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(category.icon, color: Colors.white, size: 26),
                ),
                Text(
                  category.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Icon(Icons.arrow_outward_rounded,
                    color: Colors.white70, size: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEvenementGrid(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppDimensions.paddingMedium,
        mainAxisSpacing: AppDimensions.paddingMedium,
        childAspectRatio: 2.1,
        // childAspectRatio: 1.2,
      ),
      itemCount: _evenement.length,
      itemBuilder: (context, index) {
        final evenement = _evenement[index];
        return InkWell(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
          onTap: () => Navigator.pushNamed(context, evenement.route),
          child: Container(
            padding: const EdgeInsets.all(AppDimensions.paddingLarge),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: evenement.gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius:
                  BorderRadius.circular(AppDimensions.borderRadiusLarge),
              boxShadow: [
                BoxShadow(
                  color: evenement.gradient.last.withOpacity(0.25),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(AppDimensions.paddingSmall),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(evenement.icon, color: Colors.white, size: 26),
                ),
                Text(
                  evenement.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Icon(Icons.arrow_outward_rounded,
                    color: Colors.white70, size: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.stat});

  final _QuickStat stat;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: stat.accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(stat.icon, color: stat.accent),
          ),
          const SizedBox(height: AppDimensions.paddingMedium),
          Text(
            stat.value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.loginTitleColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            stat.label,
            style: TextStyle(
              color: AppColors.textMainPageColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            stat.trend,
            style: TextStyle(
              color: stat.accent,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentDocumentCard extends StatelessWidget {
  const _RecentDocumentCard({required this.document});

  final _RecentDocument document;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 18,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppDimensions.paddingSmall),
            decoration: BoxDecoration(
              color: document.accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child:
                Icon(Icons.picture_as_pdf_rounded, color: document.accentColor),
          ),
          const SizedBox(height: AppDimensions.paddingMedium),
          Text(
            document.title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.loginTitleColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            document.subtitle,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textMainPageColor,
            ),
          ),
          const Spacer(),
          LinearProgressIndicator(
            value: document.progress,
            backgroundColor: document.accentColor.withOpacity(0.15),
            valueColor: AlwaysStoppedAnimation<Color>(document.accentColor),
            minHeight: 6,
            borderRadius: BorderRadius.circular(999),
          ),
          const SizedBox(height: 6),
          Text(
            '${(document.progress * 100).round()} % vérifié',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textMainPageColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickStat {
  const _QuickStat({
    required this.icon,
    required this.label,
    required this.value,
    required this.trend,
    required this.accent,
  });

  final IconData icon;
  final String label;
  final String value;
  final String trend;
  final Color accent;
}

class _RecentDocument {
  const _RecentDocument({
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.accentColor,
  });

  final String title;
  final String subtitle;
  final double progress;
  final Color accentColor;
}

class _CategoryCardData {
  const _CategoryCardData({
    required this.title,
    required this.icon,
    required this.route,
    required this.gradient,
  });

  final String title;
  final IconData icon;
  final String route;
  final List<Color> gradient;
}

class _BackgroundDecor extends StatelessWidget {
  const _BackgroundDecor({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: true,
      child: Stack(
        children: [
          Positioned(
            top: -120,
            right: -60,
            child: _circle(220, AppColors.mainAppColor.withOpacity(0.12)),
          ),
          Positioned(
            top: 140,
            left: -80,
            child: _circle(180, AppColors.accentPurple.withOpacity(0.08)),
          ),
        ],
      ),
    );
  }

  Widget _circle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}
