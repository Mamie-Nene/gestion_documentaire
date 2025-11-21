import 'package:flutter/material.dart';
import 'package:gestion_documentaire/src/utils/consts/app_specifications/all_directories.dart';
import 'package:gestion_documentaire/src/utils/consts/routes/app_routes_name.dart';

class DocumentListScreen extends StatefulWidget {
  const DocumentListScreen({super.key});

  @override
  State<DocumentListScreen> createState() => _DocumentListScreenState();
}

class _DocumentListScreenState extends State<DocumentListScreen> {
  static const _tabs = ['Récents', 'Partagés', 'Favoris'];
  static const _filters = ["Aujourd'hui", 'Cette semaine', 'Ce mois'];
  int _activeFilter = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        backgroundColor: AppColors.mainBackgroundColor,
        floatingActionButton: _buildFloatingActionButton(),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingLarge,
                  vertical: AppDimensions.paddingMedium,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTopBar(context),
                    const SizedBox(height: AppDimensions.paddingMedium),
                    _buildSearchField(),
                    const SizedBox(height: AppDimensions.paddingMedium),
                    _buildFilterChips(),
                  ],
                ),
              ),
              _buildTabBar(),
              const Divider(height: 1, color: AppColors.dividerLight),
              Expanded(
                child: TabBarView(
                  children: List.generate(
                    _tabs.length,
                    (index) => _buildDocumentList(index),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.mainAppColor),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Documents',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.loginTitleColor,
              ),
            ),
            Text(
              'Gardez tout accessible',
              style: TextStyle(
                color: AppColors.textMainPageColor,
              ),
            ),
          ],
        ),
        IconButton(
          onPressed: () {},
          icon:
              Icon(Icons.more_horiz_rounded, color: AppColors.loginTitleColor),
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Rechercher ou filtrer par tags',
                prefixIcon: Icon(Icons.search_rounded, color: Colors.black54),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  vertical: AppDimensions.paddingMedium,
                  horizontal: AppDimensions.paddingMedium,
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
                  const Icon(Icons.sort_rounded, color: AppColors.mainAppColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (_, __) =>
            const SizedBox(width: AppDimensions.paddingSmall),
        itemBuilder: (context, index) {
          final selected = _activeFilter == index;
          return ChoiceChip(
            label: Text(_filters[index]),
            selected: selected,
            onSelected: (_) => setState(() => _activeFilter = index),
            backgroundColor: AppColors.cardSurfaceMuted,
            selectedColor: AppColors.mainAppColor.withOpacity(0.15),
            labelStyle: TextStyle(
              color: selected
                  ? AppColors.mainAppColor
                  : AppColors.textMainPageColor,
              fontWeight: FontWeight.w600,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999),
              side: BorderSide(
                color: selected ? AppColors.mainAppColor : Colors.transparent,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      labelColor: AppColors.mainAppColor,
      unselectedLabelColor: AppColors.textMainPageColor.withOpacity(0.6),
      indicator: UnderlineTabIndicator(
        borderSide: const BorderSide(color: AppColors.mainAppColor, width: 3),
        borderRadius: BorderRadius.circular(4),
      ),
      labelStyle: const TextStyle(fontWeight: FontWeight.w700),
      tabs: _tabs.map((text) => Tab(text: text)).toList(),
    );
  }

  Widget _buildDocumentList(int tabIndex) {
    final documents = _generateDocuments(tabIndex);
    return ListView.separated(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      itemCount: documents.length,
      separatorBuilder: (_, __) =>
          const SizedBox(height: AppDimensions.paddingMedium),
      itemBuilder: (context, index) {
        final doc = documents[index];
        return _DocumentTile(
          document: doc,
          onTap: () =>
              Navigator.of(context).pushNamed(AppRoutesName.viewDocumentPage,
                  arguments: {"titleDoc": doc.title}
              ),
        );
      },
    );
  }

  List<_DocumentListItem> _generateDocuments(int tabIndex) {
    final accentPalette = [
      AppColors.mainAppColor,
      AppColors.accentTeal,
      AppColors.accentPurple,
      AppColors.accentOrange,
      AppColors.accentPink,
    ];
    final baseTitles = [
      'Rapport trimestriel',
      'Accord juridique',
      'Spécifications design',
      'Audit sécurité',
      'Brief marketing',
      'Plan d\'approvisionnement',
    ];

    return List.generate(
      6 - tabIndex,
      (index) {
        final color = accentPalette[(index + tabIndex) % accentPalette.length];
        final title =
            '${baseTitles[index % baseTitles.length]} ${2025 - tabIndex}';
        final sizeValue =
            ((index + 2) * 1.2).toStringAsFixed(1).replaceFirst('.', ',');
        return _DocumentListItem(
          title: title,
          owner:
              tabIndex == 1 ? 'Partagé par Clara' : 'Vous en êtes propriétaire',
          size: '$sizeValue Mo',
          updatedAt: 'il y a ${index + 1} h',
          accent: color,
          icon: index.isEven
              ? Icons.picture_as_pdf_rounded
              : Icons.article_outlined,
        );
      },
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () {},
      backgroundColor: AppColors.mainAppColor,
      foregroundColor: Colors.white,
      icon: const Icon(Icons.add),
      label: const Text('Nouveau document'),
    );
  }
}

class _DocumentTile extends StatelessWidget {
  const _DocumentTile({
    required this.document,
    required this.onTap,
  });

  final _DocumentListItem document;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
        decoration: BoxDecoration(
          color: AppColors.cardSurface,
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppDimensions.paddingSmall),
              decoration: BoxDecoration(
                color: document.accent.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(document.icon, color: document.accent, size: 28),
            ),
            const SizedBox(width: AppDimensions.paddingMedium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    document.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.loginTitleColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    document.owner,
                    style: TextStyle(color: AppColors.textMainPageColor),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.schedule,
                          size: 14,
                          color: AppColors.textMainPageColor.withOpacity(0.7)),
                      const SizedBox(width: 4),
                      Text(
                        document.updatedAt,
                        style: TextStyle(
                            color:
                                AppColors.textMainPageColor.withOpacity(0.8)),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.dividerLight,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        document.size,
                        style: TextStyle(
                            color:
                                AppColors.textMainPageColor.withOpacity(0.8)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.more_vert_rounded,
                  color: AppColors.textMainPageColor),
            ),
          ],
        ),
      ),
    );
  }
}

class _DocumentListItem {
  const _DocumentListItem({
    required this.title,
    required this.owner,
    required this.size,
    required this.updatedAt,
    required this.accent,
    required this.icon,
  });

  final String title;
  final String owner;
  final String size;
  final String updatedAt;
  final Color accent;
  final IconData icon;
}
