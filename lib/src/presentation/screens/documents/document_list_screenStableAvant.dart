import 'dart:math';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import '/src/data/remote/document_api.dart';
import '/src/domain/remote/Document.dart';
import '/src/utils/api/api_url.dart';
import '/src/utils/consts/app_specifications/all_directories.dart';
import '/src/utils/consts/routes/app_routes_name.dart';

class DocumentListScreen extends StatefulWidget {
  final String? categorie;
  final String? event;
  final String subtitle;
  const DocumentListScreen({super.key, this.categorie, this.event, required this.subtitle});

  @override
  State<DocumentListScreen> createState() => _DocumentListScreenState();
}

class _DocumentListScreenState extends State<DocumentListScreen> {
  static const _tabs = ['Récents', 'Partagés', 'Favoris'];
  static const _filters = ["Aujourd'hui", 'Cette semaine', 'Ce mois'];
  int _activeFilter = 0;

  final TextEditingController _searchController = TextEditingController();
  List<Document> documentsGetted = [];
  List<Document> documentsFiltered = [];
  bool _isDocumentsLoading=false;

  getDocs() async {
    await DocumentApi().getDocumentsByCritera( ApiUrl().getDocumentsUrl, widget.categorie,widget.event).then((value) {
      setState(() {
        documentsGetted = value;
        documentsFiltered = documentsGetted;
        _isDocumentsLoading=false;
      });
    }).catchError((error) {
      setState(() {
        _isDocumentsLoading=false;
      });
    });
  }
  List<Document> get _visibleDocs {
    return documentsGetted.where((document) {
      final bool matchesSearch = document.title
          .toLowerCase()
          .contains(_searchController.text.toLowerCase());

      return matchesSearch ;
    }).toList();
  }


  @override
  void initState() {
    getDocs();
    super.initState();
  }

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
                   // _buildSearchField(),
                    Container(
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
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              onChanged: (_) => setState(() {}),
                              decoration: const InputDecoration(
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
                    ),
                    const SizedBox(height: AppDimensions.paddingMedium),
                   // _buildFilterChips(),
                  ],
                ),
              ),
              _buildTabBar(),
              const Divider(height: 1, color: AppColors.dividerLight),
              _isDocumentsLoading?
                  CircularProgressIndicator()
              :
              _visibleDocs.isEmpty?

              Text('La liste ets vide !')
                  :
              Expanded(
                child: TabBarView(
                  children: List.generate(
                    _tabs.length,
                    (index) => _buildDocumentList(index,_visibleDocs),
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
          crossAxisAlignment: CrossAxisAlignment.center,
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
              widget.subtitle,
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

  Widget _buildDocumentList(int tabIndex, List<Document>docsGetted) {
    final documents = docsGetted;
   // final documents = _generateDocuments(tabIndex);
    return
    ListView.separated(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      itemCount: documents.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppDimensions.paddingMedium),
      itemBuilder: (context, index) {
        final doc = documents[index];;
        final Random random = Random();
        return documentWidget(context,
          document: doc,
          accentPalette:AppColors.mainAppColor,
          /*accentPalette:Color.fromARGB(
            255, // Alpha (opacity)
            random.nextInt(256), // Red
            random.nextInt(256), // Green
            random.nextInt(256), // Blue
          ),*/
          iconData: doc.mimeType.contains("pdf")? Icons.picture_as_pdf_rounded
            : Icons.article_outlined,
          onTap: () =>
              Navigator.of(context).pushNamed(AppRoutesName.viewDocumentPage,
                  arguments: {"document": doc}
              ),
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

  Widget documentWidget(BuildContext context, {
        required Document document,
      required Color accentPalette,
      required IconData iconData,
      required VoidCallback onTap
      }) {
    DateTime dateCreation = DateTime.parse(document.createdAt);
    String formatted = DateFormat("yyyy-MM-dd HH:mm:ss").format(dateCreation);

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
                color: accentPalette.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(iconData, color: accentPalette, size: 28),
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
                  Text("Partagé par Mame Néné BA",
                    style: TextStyle(color: AppColors.textMainPageColor),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.schedule,
                          size: 14,
                          color: AppColors.textMainPageColor.withOpacity(0.7)),
                      const SizedBox(width: 4),
                      Text(formatted,//updated
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
                        document.status,
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




