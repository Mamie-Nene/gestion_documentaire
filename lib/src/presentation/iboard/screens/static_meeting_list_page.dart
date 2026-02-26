import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '/src/data/remote/reunion_api.dart';
import '/src/utils/api/api_url.dart';
import '/src/domain/remote/Reunion.dart';
import '../../widgets/app_page_shell.dart';
import '/src/presentation/widgets/helper.dart';
import '/src/presentation/widgets/search_and_filter.dart';
import '/src/utils/consts/app_specifications/all_directories.dart';
import '/src/utils/consts/routes/app_routes_name.dart';

class MeetingListPage extends StatefulWidget {
  @override
  State<MeetingListPage> createState() => _MeetingListPageState();
}

class _MeetingListPageState extends State<MeetingListPage> {
  final TextEditingController _searchController = TextEditingController();
  // Pagination state
  int _currentPage = 1;
  int _itemsPerPage = 10;
  final List<int> _itemsPerPageOptions = [10, 20, 30, 50];

  List<Reunion> reunions = [
  Reunion("1", "Réunion Réorganisation Globale Gainde2000", "C'est le comité", "2025-11-24T08:00:00", "2025-11-24T08:00:00", "CICAD", "123", 5, "ACTIVE",["Comité Strategique"] ),
  Reunion("1", "Réunion post opération", "C'est le comité", "2025-12-05T08:00:00", "2025-11-05T08:00:00", "CICAD", "123", 5, "ACTIVE",["Comité Strategique"] ),
  Reunion("1", "Réunion Comité Strategique", "C'est le comité", "2025-10-03T08:00:00", "2025-11-24T08:00:00", "CICAD", "123", 5, "ACTIVE",["Comité Strategique"] ),
];

  @override
  Widget build(BuildContext context) {
    return AppPageShell(
      isForHomePage: false,
      title: "Liste Réunions AGO",
      whiteColorForMainCardIsHere:true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SearchAndFilter(
            searchController: _searchController, searchBgColor:AppColors.searchBgColor,
            onChangeFunction: (_)=> setState(() {_currentPage = 1;}),
            text: 'Rechercher une réunion....',
            isExpanded: false
          ),

      const SizedBox(height: AppDimensions.paddingMedium),

   //  Navigator.pushNamed(context, AppRoutesName.attendancePage);
      Container(
        child: Column(
          children: [
          ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: reunions.length,
          separatorBuilder: (context, index) {
            return const SizedBox(height: AppDimensions.paddingMedium);
          },
          itemBuilder: (context, index) {

            final reunion = reunions.elementAt(index);
            final DateTime reunionDate = Helper().parseEventDate(reunion.startDate);

            return InkWell(
              borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
              onTap: () => Navigator.pushNamed(context,AppRoutesName.feuillePresencePage,arguments: {"title": ""}),
              child: Container(
                padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: AppColors.cardBorderColor),
                  borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          flex: 0,
                          child: Container(
                            height: 55,
                            width:65,
                            padding: EdgeInsets.symmetric(vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.mainEventsBlueColor.withOpacity(0.1),
                              border: Border.all(color: AppColors.mainEventsBlueColor.withOpacity(0.1)),
                              borderRadius: BorderRadius.circular(11),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                //reunion date
                                Text(Helper().formatMonth(reunionDate),
                                    style: TextStyle( color: AppColors.mainEventsBlueColor, fontSize: 14,fontWeight: FontWeight.bold)),
                                Text(Helper().formatDay(reunionDate),
                                    style: TextStyle( color: AppColors.mainEventsBlueColor, fontSize: 16,fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                reunion.title,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: AppColors.textMainPageColor,
                                  fontFamily: "Roboto",
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Row(
                                spacing: 8,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  /*Row(
                                spacing: 5,
                                children: [
                                  SvgPicture.asset("asset/images/hour.svg"),
                                  Text(Helper().formatHour(reunionDate),//houre here
                                    style: TextStyle(color:AppColors.textMainPageColor, fontSize: 12,fontFamily: "Roboto",fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),*/
                                  Flexible(
                                    child: Row(
                                      spacing: 5,
                                      children: [
                                        SvgPicture.asset("asset/images/location.svg"),
                                        Flexible(
                                          child: Text(reunion.location,
                                            style: TextStyle(color: AppColors.textMainPageColor,fontSize: 12,fontFamily: "Roboto",fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                            ],
                          ),
                        ),
                      ],
                    ),
                    Divider(color: Color(0xffDEE8EE),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          spacing: 5,
                          children: [
                            SvgPicture.asset("asset/images/docs.svg"),
                            Text("${reunion.documentCount} document(s) lié(s) ",
                              style: TextStyle(color: AppColors.textMainPageColor,fontSize: 12,fontFamily: "Roboto",fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        Row(
                          spacing: 5,
                          children: [
                            Text("Voir les détails",
                              style: TextStyle(color: AppColors.mainEventsBlueColor,fontSize: 12,fontFamily: "Roboto",fontWeight: FontWeight.w500),
                            ),
                            SvgPicture.asset("asset/images/arrow_back.svg"),

                          ],
                        ),
                      ],
                    )

                  ],
                ),
              ),
            );
          },
        )

          //  _buildPaginationControls()
          ],
        ),
      ),
        ]
      ),
    );
  }
}


class TaskTimelinePage extends StatefulWidget {
  const TaskTimelinePage({super.key});

  @override
  State<TaskTimelinePage> createState() => _TaskTimelinePageState();
}

class _TaskTimelinePageState extends State<TaskTimelinePage> {
  final TextEditingController _searchController = TextEditingController();

  // Pagination state
  int _currentPage = 1;
  int _itemsPerPage = 10;
  final List<int> _itemsPerPageOptions = [10, 20, 30, 50];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:AppColors.newBackgroundColor,

     // backgroundColor: const Color(0xFFF5F6FA),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.mainAppColor,
        onPressed: () {},
        child: const Icon(Icons.add,color: Colors.white,),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(icon:Icon(Icons.arrow_back),onPressed: (){Navigator.of(context).pop();},),

              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   SearchAndFilter(
                       searchController: _searchController, searchBgColor:AppColors.searchBgColor,
                      onChangeFunction: (_)=> setState(() {_currentPage = 1;}),
                      text: 'Rechercher une réunion....',
                      isExpanded: false
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.mainAppColor,
                        border: Border.all(color: const Color(0xffF5F6F9)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add, color: Colors.white, size: 20),
                          SizedBox(width: 8),
                          Text(
                            "Ajouter une réunion",
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
             /* /// Days
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  DayChip("Mon", false),
                  DayChip("Tue", false),
                  DayChip("Wed", false),
                  DayChip("Thu", true),
                  DayChip("Fri", false),
                  DayChip("Sat", false),
                  DayChip("Sun", false),
                ],
              ),

              const SizedBox(height: 24),*/
              const SizedBox(height: 24),
              /// Timeline
              Expanded(
                child: ListView(
                  children:  [
                    TaskCard(context,
                      title: "Réunion Réorganisation Globale Gainde2000",
                      description: "Réunion de mise en point",
                      time: "12:00",
                      color: AppColors.mainAppColor,
                     // color: Color(0xFFFF6B6B),
                    ),
                    /*TaskCard(context,
                      title: "Réunion post opération",
                      description: "Réunion de mise en point",
                      time: "10:30",
                      color: Color(0xFF6C63FF),
                    ),*/
                    TaskCard(context,
                      title: "Réunion Comité Strategique",
                      description: "Réunion de mise en point",
                      time: "10:00",
                      color: Color(0xFFFFD166),
                    ),
                    TaskCard(context,
                      title: "Réunion mise en point",
                      description: "Réunion de mise en point",
                      time: "10:45",
                      color: Color(0xFF4ECDC4),
                    ),
                    TaskCard(context,
                      title: "Réunion mise en point",
                      description: "Réunion de mise en point",
                      time: "10:30",
                      color: Color(0xFF5F27CD),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
   DayChip(String day,  selected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? Colors.blue : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        day,
        style: TextStyle(
          color: selected ? Colors.white : Colors.black54,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
  TaskCard(BuildContext context,{
    required String title,
    required String description,
    required String time,
    required Color color,
  }) {
    return InkWell(
    onTap: (){Navigator.of(context).pushNamed(AppRoutesName.feuillePresencePage, arguments: {"title": title});},
    child: Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 60,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                ),
                const SizedBox(height: 4),
                Text(description,
                    style: const TextStyle(color: Colors.black54)
                ),
              ],
            ),
          ),
          Text(time, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    ),
  );
  }

}
