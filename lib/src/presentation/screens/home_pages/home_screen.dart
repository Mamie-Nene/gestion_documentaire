import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gestion_documentaire/src/data/local/home_screen_data.dart';
import 'package:gestion_documentaire/src/data/remote/category_api.dart';
import 'package:gestion_documentaire/src/data/remote/document_api.dart';
import 'package:gestion_documentaire/src/data/remote/events_api.dart';
import 'package:gestion_documentaire/src/domain/local/Categorie.dart';
import 'package:gestion_documentaire/src/domain/local/Document.dart';
import 'package:gestion_documentaire/src/domain/local/QuickStats.dart';
import 'package:gestion_documentaire/src/domain/remote/Categorie.dart';
import 'package:gestion_documentaire/src/domain/remote/Document.dart';
import 'package:gestion_documentaire/src/domain/remote/Event.dart';
import 'package:gestion_documentaire/src/presentation/widgets/app_page_shell.dart';
import 'package:gestion_documentaire/src/presentation/widgets/utils_widget.dart';
import 'package:gestion_documentaire/src/utils/api/api_url.dart';
import 'package:gestion_documentaire/src/utils/consts/app_specifications/all_directories.dart';
import 'package:gestion_documentaire/src/utils/consts/routes/app_routes_name.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

/*
* thanks now I have card with events data (3 events data ) I want to add a card named "Tout" so we will have 4 card*/
class _HomeScreenState extends State<HomeScreen> {
  List<Event> last4Events = [];
  List<Categorie> last3CategoriesGetted = [];
  List<Document> last3DocumentsGetted = [];
  bool _isEventsLoading=false;
  bool _isCategoriesLoading=false;
  bool _isDocumentsLoading=false;

   List<QuickStat> quickStats = HomeScreenData().quickStats;
 /* List<CategoryCardData> categories  = HomeScreenData().categories;
  List<CategoryCardData> evenement = HomeScreenData().evenement;
  List<RecentDocument> recentDocuments = HomeScreenData().recentDocuments;
*/
   eventsGetted() async {
     await EventsApi().getLastEvents( ApiUrl().getEventsUrl).then((value) {
       setState(() {
         last4Events = value;
         _isEventsLoading=false;
       });
     }).catchError((error) {
       setState(() {
         _isEventsLoading=false;
       });
     });
     /*last3Events.insert(0, Event(
       "0",
      "Tout",
        "Voir tous les événements",
        DateTime.now().toString(),
     ));*/
   }

  getCategories() async {
    await CategoriesApi().getLastCategories( ApiUrl().getCategoriesUrl).then((value) {
      setState(() {
        last3CategoriesGetted = value;
        _isCategoriesLoading=false;
      });
    }).catchError((error) {
      setState(() {
        _isCategoriesLoading=false;
      });
    });
    last3CategoriesGetted.insert(0, Categorie(
      "0",
      "Tout","0","0",
      "Voir toutes les catégories",
      DateTime.now().toString(),last3CategoriesGetted.length
    ));
  }

  getRecentsDocs() async {
    await DocumentApi().getRecentsDocuments( ApiUrl().getDocumentsUrl).then((value) {
      setState(() {
        last3DocumentsGetted = value;
        _isDocumentsLoading=false;
      });
    }).catchError((error) {
      setState(() {
        _isDocumentsLoading=false;
      });
    });
  }

   @override
  void initState() {
    eventsGetted();
    getCategories();
    getRecentsDocs();

    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return AppPageShell(
      isForHomePage: true,
      title: "Votre espace de travail",
      subtitle: "Bon retour à",
      whiteColorForMainCardIsHere:false,
     actions: [
       Container(
         height: 48,
         width: 48,
         decoration: BoxDecoration(
           border: Border.all(color: Color(0xffF5F6F9)),
           borderRadius: BorderRadius.circular(12),
         ),
         child:
         IconButton(
           icon:Icon(Icons.person, color: Colors.white, size: 20),
           onPressed:() => Navigator.pushNamed(context, AppRoutesName.profilePage),
         ),
       ),
     ],
     // backgroundColor: Color(0xffEEF2F8),

      child: /*Stack(
        children: [
          _BackgroundDecor(),*/
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
                      /*  _buildHeroCard(),
                        const SizedBox(height: AppDimensions.paddingLarge),
                     _buildSearchBar(),
                        const SizedBox(height: AppDimensions.paddingLarge),
*/
                        _buildStats(last3DocumentsGetted.length,last4Events.length,last3CategoriesGetted.length,2),
                        _buildSectionTitle('Documents récents', 'Voir Tout ',(){Navigator.of(context).pushNamed(AppRoutesName.documentPage,arguments: {"subtitle":"Tous les documents"});}),
                        const SizedBox(height: AppDimensions.paddingMedium),
                        _isDocumentsLoading?CircularProgressIndicator():last3DocumentsGetted.isEmpty?Text("Pas de documents pour le moment !"): _buildRecentDocuments(context,last3DocumentsGetted),
                        const SizedBox(height: AppDimensions.paddingLarge),
                        _buildSectionTitle('Événements', 'Voir Tout ',(){Navigator.of(context).pushNamed(AppRoutesName.evenementListPage);}),
                        const SizedBox(height: AppDimensions.paddingMedium),
                        _isEventsLoading?CircularProgressIndicator():last4Events.isEmpty?Text("Pas d'évenement pour le moment !"):UtilsWidget().evenementGrid(context,last4Events,true),
                        //const SizedBox(height: AppDimensions.paddingLarge),
                       // _buildSectionTitle('Catégories', 'Gérer',(){Navigator.of(context).pushNamed(AppRoutesName.categoriePage);}),//AppRoutesName.categoryListPage
                        //const SizedBox(height: AppDimensions.paddingMedium),
                        //_isCategoriesLoading?CircularProgressIndicator():last3CategoriesGetted.isEmpty?Text("Pas de catégories pour le moment !"):UtilsWidget().categoryGrid(context,last3CategoriesGetted),
                      ],
                    ),
                  ),
                ),
              ],
            ),
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
                AppColors.mainBlueFirst.withOpacity(0.92),
                AppColors.secondAppColor.withOpacity(0.9),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius:
                BorderRadius.circular(AppDimensions.borderRadiusLarge + 12),
            boxShadow: [
              BoxShadow(
                color: AppColors.mainBlueFirst.withOpacity(0.24),
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
              color: AppColors.mainBlueFirst.withOpacity(0.12),
              borderRadius:
                  BorderRadius.circular(AppDimensions.borderRadiusLarge),
            ),
            child: IconButton(
              onPressed: () {},
              icon:
                  const Icon(Icons.tune_rounded, color: AppColors.mainBlueFirst),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Row(
      children: List.generate(quickStats.length, (index) {
        final stat = quickStats[index];
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: index == quickStats.length - 1
                  ? 0
                  : AppDimensions.paddingMedium / 2,
            ),
            child: _StatCard(stat: stat),
          ),
        );
      }),
    );
  }

  Widget _buildSectionTitle(String title, String? actionLabel, VoidCallback action) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: "Roboto",
            fontSize: 20,
            fontWeight: FontWeight.w700,
            //color: AppColors.loginTitleColor,
            color: Color(0xff292D32),
          ),
        ),
        if (actionLabel != null)
          TextButton(
            onPressed: action,
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

  Widget _buildRecentDocuments(BuildContext context, List<Document> recentDocsGetted,) {
    return  GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: AppDimensions.paddingLarge,
      mainAxisSpacing: AppDimensions.paddingLarge,
      childAspectRatio: 4.1,
      // childAspectRatio: 1.2,
      ),
      itemCount: recentDocsGetted.length,//evenement.length,
      itemBuilder: (context, index) {

        final doc = recentDocsGetted[index]; //recentDocuments[index];
          List<Color> colors= [ AppColors.mainAppColor,AppColors.accentTeal,AppColors.accentPurple];
          List<double> progress= [ 0.82,0.38,0.64];

          //colorGetted: colors[index],progress:progress[index]);
        return Container(
          padding: const EdgeInsets.all(AppDimensions.paddingLarge),
          decoration: BoxDecoration(
            color: AppColors.cardSurface,
            borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
          ),
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SvgPicture.asset("asset/images/pdf.svg"),
                  SizedBox(width: 10,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(
                          doc.title,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.loginTitleColor,
                          ),
                        ),
                        Row(
                          spacing: 8,
                          children: [
                            Text("DOCX",
                              //document.subtitle,
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xff979797),
                              ),
                            ),
                            SvgPicture.asset("asset/images/dots.svg"),

                            Text("2.4MB",
                              //document.subtitle,
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xff979797),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Container(
                      width: 40,
                      padding: const EdgeInsets.fromLTRB(5, 3, 5, 3),
                     // padding: const EdgeInsets.all(5.5),
                      decoration: BoxDecoration(
                        color: Color(0xffBC3618).withOpacity(0.1),
                        border: Border.all(color: Color(0xffBA3316)),
                        //color: colorGetted,
                        //  color: colorGetted.withOpacity(0.12),
                        borderRadius:
                        BorderRadius.circular(AppDimensions.borderRadiusSmall),
                      ),
                      // child: Icon(Icons.more_vert_rounded, color: colorGetted),
                      child: Text('PDF',style: TextStyle(color: Color(0xffBC3618),fontSize: 10),)
                  ),

                ],
              ),
            ],
          ),
        );
        },
    );
  }

  Widget _buildStats(int documentsLength,int eventsLength,int categoriesLength,int storageLength) {
    List<String> statTitles=["Documents enregistrés", "Évenements actifs","Catégories enregistrées","Stockage utilisé"];
    List<int> statNumbers=[documentsLength,eventsLength,categoriesLength,storageLength];
    List<String> statIcons=["Frame-6","Frame-4","Frame-5","Frame-7"];
    List<Color> statColors=[Color(0xffF97316),Color(0xff16A6E3),Color(0xff00897B),Color(0xffE11D48)];
    List<VoidCallback> statActions=[(){Navigator.of(context).pushNamed(AppRoutesName.documentPage,arguments: {"subtitle":"Tous les documents"});},(){Navigator.of(context).pushNamed(AppRoutesName.evenementListPage);},(){Navigator.of(context).pushNamed(AppRoutesName.categoriePage);},(){Navigator.of(context).pushNamed(AppRoutesName.homePage);}];


    return  GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: AppDimensions.paddingLarge,
      mainAxisSpacing: AppDimensions.paddingLarge,
      childAspectRatio: 2.9,
      // childAspectRatio: 1.2,
      ),
      itemCount: statTitles.length,
      itemBuilder: (context, index) {//recentDocuments[index];

          return InkWell(
            onTap: statActions[index],
            child: Container(
                padding: const EdgeInsets.all(AppDimensions.paddingLarge),
                decoration: BoxDecoration(
                  color: AppColors.cardSurface,
                  borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
                ),
                child:
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(statTitles[index],
                                style: TextStyle(
                                  fontFamily: "Roboto",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff6C757D),
                                ),
                              ),
                              Text(statNumbers[index].toString(),
                                style: TextStyle(
                                  fontFamily: "Roboto",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                  color: Color(0xff212529),
                                ),

                              ),
                            ],
                          ),
                        ),

                        Container(
                          height: 48,
                          width: 48,
                          padding: const EdgeInsets.all(AppDimensions.paddingSmall),
                          /* decoration: BoxDecoration(
                              border: Border.all(color: Color(0xffF5F6F9)),
                              borderRadius: BorderRadius.circular(12),
                            ),*/
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(11),
                              color: statColors[index].withOpacity(0.1),
                             // border: Border.all(color: Color(0xBA33164D)),
                            ),
                            // child: Icon(Icons.more_vert_rounded, color: colorGetted),
                            child: SvgPicture.asset("asset/images/${statIcons[index]}.svg"),
                        ),

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

  final QuickStat stat;

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
