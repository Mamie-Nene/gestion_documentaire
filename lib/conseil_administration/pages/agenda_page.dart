
import 'package:flutter/material.dart';

import '/src/presentation/widgets/utils_widget.dart';
import '/src/utils/consts/app_specifications/all_directories.dart';
import '/src/utils/consts/routes/app_routes_name.dart';
import '/conseil_administration/models/agenda_item.dart';

class AgendaPage extends StatefulWidget {
  final String title;
  const AgendaPage({super.key, required this.title});

  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  bool isForAgenda=true;

  static const _choice = ['Ordre du jour', 'Documents'];

  List<AgendaItem> agenda = [
    AgendaItem("Présentation du projet"),
    AgendaItem("Budget"),
    AgendaItem("Réorganisation "),
  ];

  @override
  void initState() {
    isForAgenda=true;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
        length: _choice.length,
        child: Scaffold(
          backgroundColor: AppColors.newBackgroundColor,
          body:  Column(
              children: [
                Container(
                  width: double.infinity,
                  decoration:  const BoxDecoration(
                    color: Color(0xff305A9D),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 24, right: 24, top: 50, bottom: 100),
                    child: Row(
                      children: [
                        UtilsWidget().iconContainerCard(
                          isItWithBorder: true,
                          bgColor: null,
                          widget:IconButton(
                            icon:Icon(Icons.arrow_back, color: Colors.white, size: 20),
                            onPressed: (){Navigator.of(context).pushReplacementNamed(AppRoutesName.meetingListPage);},
                          ),
                        ),
                        SizedBox(width: 10,),
                        Expanded(
                          child: Text(
                              widget.title,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w700,
                                height: 1.40,
                              )
                            //theme.textTheme.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w600,),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},

                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: const Color(0xffF5F6F9)),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.add, color: Colors.white, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  "Générer un PV",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
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
                ),
                Flexible(
                    fit: FlexFit.loose,
                    child: Transform.translate(
                        offset: const Offset(0, -70),
                        child:Container(
                          padding: const EdgeInsets.only(left: 20,right: 20,top: 20,bottom: 5),
                          margin: const EdgeInsets.only(left: 20,right: 20,top: 0,bottom: 5),
                          width: double.infinity,
                          decoration:  BoxDecoration(
                              color:Colors.white,
                            borderRadius: BorderRadius.circular(12.0)
                          ),
                          child: Column(
                              children: [
                                _buildTabBar(),
                                Expanded(
                                child: TabBarView(
                                  children:[
                                    ListView.builder(
                                      itemCount: agenda.length,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          title: Text(agenda[index].title),
                                          trailing: const Icon(Icons.edit),
                                        );
                                      },
                                    ),
                                    _buildDocumentList(0),

                                  ]
                                ),
                              ),
                              ],
                            ),
                          ),
                        ),
                    )
              ],
            ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: AppColors.mainAppColor,
            child: const Icon(Icons.add,color: Colors.white,),
            onPressed: () {
              setState(() {
                agenda.add(AgendaItem("Nouveau point"));
              }
            );
          },
        ),
      )
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
      tabs: _choice.map((text) => Tab(text: text)).toList(),
    );
  }

  Widget _buildSearchField() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 5),
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

  Widget _buildDocumentList(int tabIndex) {
    final documents = _generateDocuments(tabIndex);
    return Column(
      children: [
        _buildSearchField(),
        Expanded(
          child: ListView.separated(
            itemCount: documents.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppDimensions.paddingMedium),
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
          ),
        ),
      ],
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
