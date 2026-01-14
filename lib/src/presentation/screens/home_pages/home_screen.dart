import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '/src/data/remote/dashboard.dart';
import '/src/domain/remote/Dashboard.dart';

import '/src/data/remote/document_api.dart';
import '/src/data/remote/events_api.dart';

import '/src/domain/remote/Categorie.dart';
import '/src/domain/remote/Document.dart';
import '/src/domain/remote/Event.dart';
import '/src/presentation/widgets/app_page_shell.dart';
import '/src/presentation/widgets/utils_widget.dart';

import '/src/utils/api/api_url.dart';
import '/src/utils/consts/app_specifications/all_directories.dart';
import '/src/utils/consts/routes/app_routes_name.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Event> last4Events = [];
  List<Categorie> last3CategoriesGetted = [];
  List<Document> last3DocumentsGetted = [];

  Dashboard? dashboardGetted;
  bool _isEventsLoading=false;
  bool _isDashboardLoading=false;
  bool _isDocumentsLoading=false;


   eventsGetted() async {
     await EventsApi().getLastEvents(ApiUrl().getRecentsEventsUrl).then((value) {
       setState(() {
         last4Events = value;
         _isEventsLoading=false;
       });
     }).catchError((error) {
       setState(() {
         _isEventsLoading=false;
       });
     });
   }

  getRecentsDocs() async {
    await DocumentApi().getRecentsDocuments( ApiUrl().getRecentsDocumentsUrl).then((value) {
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

  getDashboard() async {
    await DashboardApi().getDashboard(ApiUrl().getDashboardUrl).then((value) {
      setState(() {
        dashboardGetted = value;
        _isDashboardLoading=false;
      });
    }).catchError((error) {
      setState(() {
        _isDashboardLoading=false;
      });
    });
  }

   @override
  void initState() {
   eventsGetted();
    getDashboard();
    getRecentsDocs();

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // backgroundColor: Color(0xffEEF2F8),
    return AppPageShell(
      isForHomePage: true,
      title: "Votre espace de travail",
      subtitle: "Bon retour à",
      whiteColorForMainCardIsHere:false,
      actions: [
        UtilsWidget().iconContainerCard(
          isItWithBorder: true,
          bgColor: null,
          widget: IconButton(
            icon:Icon(Icons.person, color: Colors.white, size: 20),
            onPressed:() => Navigator.pushNamed(context, AppRoutesName.profilePage),
          ),
        ),
     ],
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //  _buildHeroCard(),
           _isDashboardLoading?
           Center(
               child: CircularProgressIndicator()
           )
              :
           _buildStats(context,dashboardGetted),

            const SizedBox(height: AppDimensions.paddingSmall),

            _buildSectionTitle('Documents récents', 'Voir Tout ',(){Navigator.of(context).pushNamed(AppRoutesName.documentPage,arguments: {"subtitle":"Tous les documents"});}),

            const SizedBox(height: AppDimensions.paddingSmall),

            _isDocumentsLoading
                ?Center(
                  child: CircularProgressIndicator()
                )
                : last3DocumentsGetted.isEmpty
                ? Center(
                  child: Text("Pas de documents pour le moment !")
            )
                : _buildRecentDocuments(context,last3DocumentsGetted),

            const SizedBox(height: AppDimensions.paddingSmall),

            _buildSectionTitle('Événements à venir', 'Voir Tout ',(){Navigator.of(context).pushNamed(AppRoutesName.evenementListPage);}),

            const SizedBox(height: AppDimensions.paddingSmall),

            _isEventsLoading
                ? Center(
                  child: CircularProgressIndicator()
                )
                :last4Events.isEmpty
                ?Center(
                  child: Text("Pas d'évenement pour le moment !")
                )
                :UtilsWidget().evenementGridForViewList(context,last4Events,true),
         ],
        ),
      ),
    );
  }

  Widget _buildHeroCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge + 12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18)
      ),
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
      childAspectRatio: 3.9,
      ),
      itemCount: recentDocsGetted.length,
      itemBuilder: (context, index) {

        final doc = recentDocsGetted[index];
        return UtilsWidget().documentGrid(context, doc);
        },
    );
  }

  Widget _buildStats(BuildContext context,Dashboard? dashboardGetted){
    List<String> statTitles=["Documents enregistrés", "Évenements actifs","Catégories enregistrées","Stockage utilisé"];
    List<String> statNumbers=["0","0","0","0"];
    List<String> statIcons=["Frame-6","Frame-4","Frame-5","Frame-7"];
    List<Color> statColors=[Color(0xffF97316),Color(0xff16A6E3),Color(0xff00897B),Color(0xffE11D48)];
    List<VoidCallback> statActions=[(){Navigator.of(context).pushNamed(AppRoutesName.documentPage,arguments: {"subtitle":"Tous les documents"});},(){Navigator.of(context).pushNamed(AppRoutesName.evenementListPage);},(){Navigator.of(context).pushNamed(AppRoutesName.categoriePage);},(){}];

    return  GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: AppDimensions.paddingMedium,
      mainAxisSpacing: AppDimensions.paddingMedium,
      childAspectRatio: 2.9,
      ),
      itemCount: statTitles.length,
      itemBuilder: (context, index) {//recentDocuments[index];
        if(dashboardGetted!=null)
          statNumbers = [dashboardGetted.totalDocuments.toString(),dashboardGetted.totalEvents.toString(),dashboardGetted.totalCategories.toString(),dashboardGetted.totalStorage.formatted];
          return InkWell(
            onTap: statActions[index],
            child: Container(
                padding: const EdgeInsets.all(AppDimensions.paddingLarge),
                decoration: BoxDecoration(
                  color: AppColors.cardSurface,
                  borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
                ),
                child: dashboardGetted==null ?
                Center(child: Text("Pas de données pour le moment !"))
                  :
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(statTitles[index],
                            style: TextStyle(
                              fontFamily: "Roboto",
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff6C757D),
                            ),
                          ),
                          Text(statNumbers[index],
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
                    UtilsWidget().iconContainerCard(
                      isItWithBorder: false,
                      bgColor:  statColors[index].withOpacity(0.1),
                     widget: SvgPicture.asset("asset/images/${statIcons[index]}.svg",),) ,
                  ],
                ),
            )
          );
        },
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
