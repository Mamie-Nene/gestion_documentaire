import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/src/domain/remote/IboardMeetingData.dart';
import '/src/presentation/widgets/utils_widget.dart';
import 'package:intl/intl.dart';

import '/src/data/remote/reunion_api.dart';
import '/src/utils/api/api_url.dart';
import '/src/presentation/widgets/search_and_filter.dart';
import '/src/utils/consts/app_specifications/all_directories.dart';
import '/src/utils/consts/routes/app_routes_name.dart';

class ListReunionPage extends StatefulWidget {
  const ListReunionPage({super.key});

  @override
  State<ListReunionPage> createState() => _ListReunionPageState();
}

class _ListReunionPageState extends State<ListReunionPage> {
  final TextEditingController _searchController = TextEditingController();

  // Pagination state
  int _currentPage = 1;
  int _itemsPerPage = 10;
  final List<int> _itemsPerPageOptions = [10, 20, 30, 50];

  DateTime _currentMonth = DateTime.now();
  final DateTime _today = DateTime.now();

  bool listView=true;
  List<IboardMeetingData> reunions = [];
  bool _isMeetingsLoading=false;

  reunionsGetted() async {
    setState(() {
      _isMeetingsLoading = true;
    });
    await ReunionApi().getListMeetings( ApiUrl().getMeetingsUrl).then((value) {
      setState(() {
        reunions = value ?? [];
        // reunions = value;
        _isMeetingsLoading=false;

        debugPrint('Loaded ${reunions.length} meetings from API');
      });
    }).catchError((error) {
      setState(() {
        _isMeetingsLoading=false;
      });
      debugPrint('Error loading reunions: $error');
    });
  }

  @override
  void initState() {
    reunionsGetted();
    listView =true;
    super.initState();
  }

  List<IboardMeetingData> get _visibleReunions {
    return reunions.where((meeting) {
      final bool matchesSearch = meeting.title
          .toLowerCase()
          .contains(_searchController.text.toLowerCase());

      return matchesSearch ;
    }).toList();
  }

  String _formatDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Map<String, List<IboardMeetingData>> get _reunionsByDate {
    final Map<String, List<IboardMeetingData>> map = {};
    debugPrint('=== Mapping reunions by date ===');
    debugPrint('Total visible reunions: ${_visibleReunions.length}');

    for (var meeting in _visibleReunions) {
      try {
        // Parse the date string - API returns ISO 8601 format: "2025-11-24T08:00:00"
        DateTime eventDate;
        String dateStr = meeting.meetingDate.trim();

        // Remove timezone info if present (Z, +HH:MM, etc.)
        if (dateStr.contains('Z')) {
          dateStr = dateStr.replaceAll('Z', '');
        }
        if (dateStr.contains('+')) {
          dateStr = dateStr.split('+')[0].trim();
        }
        if (dateStr.contains('-') && dateStr.split('-').length > 4) {
          // Remove timezone offset like "-05:00"
          final parts = dateStr.split('-');
          if (parts.length > 4) {
            dateStr = '${parts[0]}-${parts[1]}-${parts[2]}T${parts[3]}';
            if (parts[3].contains(':')) {
              final timeParts = parts[3].split(':');
              if (timeParts.length >= 3) {
                dateStr = '${parts[0]}-${parts[1]}-${parts[2]}T${timeParts[0]}:${timeParts[1]}:${timeParts[2].split('+')[0].split('-')[0]}';
              }
            }
          }
        }

        // Remove milliseconds if present
        if (dateStr.contains('.')) {
          final parts = dateStr.split('.');
          dateStr = parts[0];
        }

        // Parse the date - should work for "2025-11-24T08:00:00"
        eventDate = DateTime.parse(dateStr);

        final key = _formatDateKey(eventDate);
        //  debugPrint('✓ Reunion: "${meeting.title}" | Date: "${meeting.eventDate}" → Parsed: $eventDate → Key: $key');

        if (map[key] == null) {
          map[key] = [];
        }
        map[key]!.add(meeting);
      } catch (e) {
        debugPrint('Erreur de transformation de date reunions de "${meeting.title}": "${meeting.meetingDate}" - Erreur: $e');
        // Skip invalid dates
      }
    }

    /* debugPrint('Reunions mapped to ${map.keys.length} unique dates');
    debugPrint('All date keys: ${map.keys.toList()}');
    debugPrint('Looking for November 24: ${map.keys.where((k) => k.contains('11-24')).toList()}');
    debugPrint('==============================');*/
    return map;
  }

  List<IboardMeetingData> _getReunionsForDate(DateTime date) {
    final key = _formatDateKey(date);
    return _reunionsByDate[key] ?? [];
  }

  int get _totalPages {
    return (_visibleReunions.length / _itemsPerPage).ceil();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:AppColors.mainWebBackgroundColor,
      // backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(icon:Icon(Icons.arrow_back),onPressed: (){Navigator.of(context).pop();},),
                  dashboardHeader(),
                ],
              ),
              const SizedBox(height: 32),
              _buildStats(context),

              const SizedBox(height: 32),
              _buildSearchAndFilter(),

              const SizedBox(height: 32),
              const Text(
                "Prochaines reunions",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
            /*  meetingsSection(),
              const SizedBox(height: 32),*/


             _isMeetingsLoading
                  ? Center(
                  child: CircularProgressIndicator()
              )
                  : _visibleReunions.isEmpty
                  ? Center(
                  child: Text('La liste est vide !')
              )
                  :
              listView?
              Container(
                child: Column(

                  children: [
                     UtilsWidget().meetingGridForViewList(context,_visibleReunions.reversed),
                     SizedBox(height: 12,),
                     UtilsWidget().meetingGridForViewList(context,_visibleReunions.reversed),
                    _buildPaginationControls()
                  ],
                ),
              )
              :
              SizedBox(
                  height: MediaQuery.of(context).size.height/1.7,
                  child: _buildCalendarView()
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStats(BuildContext context){
    List<String> statTitles=["Total Réunions","Résolutions adoptées","Membre du conseil",];
    List<IconData> statIcons=[Icons.calendar_today_outlined,Icons.playlist_add_check_outlined,Icons.group,];
    List<Color> statColors=[AppColors.mainWebAppColor,AppColors.secondWebAppColor,Colors.grey];
    List<VoidCallback> statActions=[(){Navigator.of(context).pushNamed(AppRoutesName.documentPage,arguments: {"subtitle":"Tous les documents"});},(){Navigator.of(context).pushNamed(AppRoutesName.evenementListPage);},(){Navigator.of(context).pushNamed(AppRoutesName.categoriePage);},(){}];

    return  GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        //crossAxisCount: MediaQuery.of(context).size.width > 900 ? 4 : MediaQuery.of(context).size.width > 600 ? 2 : 1,
        //
        crossAxisSpacing: AppDimensions.paddingMedium,
        mainAxisSpacing: AppDimensions.paddingMedium,
        childAspectRatio: 2.5,
      ),
      itemCount: statTitles.length,
      itemBuilder: (context, index) {//recentDocuments[index];

        final  statNumbers = ["1","1","1","1"];
        return InkWell(
            onTap: statActions[index],
            child: Container(
              padding: const EdgeInsets.all(AppDimensions.paddingMedium),
              decoration: BoxDecoration(
                color: AppColors.cardSurface,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
                //borderRadius: BorderRadius.circular(16),
                //border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  UtilsWidget().iconContainerCard(
                    isItWithBorder: false,
                    bgColor:  statColors[index],//.withOpacity(0.1),
                    widget: Icon(statIcons[index],color:Colors.white)
                  ) ,
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(statNumbers[index],
                          style: TextStyle(
                           // fontFamily: "Roboto",
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Color(0xff212529),
                          ),
                        ),
                        Text(statTitles[index],
                          style: TextStyle(
                           // fontFamily: "Roboto",
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff6C757D),
                          ),
                        ),

                      ],
                    ),
                  ),

                ],
              ),
            )
        );
      },
    );
  }


  Widget meetingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        meetingCard(
          type: "AGO",
          status: "Brouillon",
          title: "AGO - Assemblee Annuelle 2026",
          date: "20 avril 2026",
          time: "10:00",
          location: "King Fahd Palace, Dakar",
          onTap: () {},
        ),
        const SizedBox(height: 12),
        meetingCard(
          type: "CA",
          status: "Convoquee",
          title: "CA - Approbation des comptes Q4 2025",
          date: "15 février 2026",
          time: "09:00",
          location: "Siege Social, Dakar",
          onTap: () {},
        ),
      ],
    );
  }
  Widget meetingCard({
    required String type,
    required String status,
    required String title,
    required String date,
    required String time,
    required String location,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        type,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          status,
                          style: const TextStyle(fontSize: 11),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 16,
                    runSpacing: 8,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.calendar_today, size: 14),
                          const SizedBox(width: 4),
                          Text(date, style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.access_time, size: 14),
                          const SizedBox(width: 4),
                          Text(time, style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.location_on, size: 14),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              location,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
  Widget dashboardHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          "Tableau de bord",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            fontFamily: 'Serif',
          ),
        ),
        SizedBox(height: 4),
        Text(
          "Vue d'ensemble de la gouvernance et des reunions",
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchAndFilter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SearchAndFilter(
            searchController: _searchController,
            searchBgColor:Colors.white,
            onChangeFunction: (_)=> setState(() {_currentPage = 1;}),
            text: 'Recherche avancée....',
            isExpanded: false
        ),

        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingMedium,
            vertical: AppDimensions.paddingSmall,
          ),

          child: Row(
            spacing: 8,
            children: [
              InkWell(
                onTap: (){
                  setState(() {
                    listView=true;
                  });
                },
                child: Container(
                    padding: EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: listView?AppColors.mainWebAppColor:Colors.transparent,
                      borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium),
                    ),
                    child: Text("Vu liste",
                      style: TextStyle(
                          color: listView? Colors.white:Color(0xff2D3748),
                          fontFamily: "Chivo",
                          fontSize: 14
                      ),)),
              ),

              InkWell(
                onTap: (){
                  setState(() {
                    listView=false;
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: listView?Colors.transparent:AppColors.mainWebAppColor,
                    borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
                  ),
                  child: Text("Vu calendrier",
                    style: TextStyle(
                        color: listView? Color(0xff2D3748):Colors.white,
                        fontFamily: "Chivo",
                        fontSize: 14
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildPaginationControls() {
    final totalItems = _visibleReunions.length;
    final startItem = totalItems == 0 ? 0 : ((_currentPage - 1) * _itemsPerPage) + 1;
    final endItem = totalItems == 0
        ? 0
        : (_currentPage * _itemsPerPage > totalItems
        ? totalItems
        : _currentPage * _itemsPerPage);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingLarge,
        vertical: AppDimensions.paddingMedium,
      ),
     /* decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.grey.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),*/
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Text(
                'éléments par page:',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.mainWebAppColor,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.mainWebAppColor.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: DropdownButton<int>(
                  value: _itemsPerPage,
                  underline: const SizedBox(),
                  isDense: true,
                  items: _itemsPerPageOptions.map((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text(value.toString()),
                    );
                  }).toList(),
                  onChanged: (int? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _itemsPerPage = newValue;
                        _currentPage = 1;
                      });
                    }
                  },
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                '$startItem - $endItem sur $totalItems',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 16),
              IconButton(
                onPressed: _currentPage > 1
                    ? () {
                  setState(() {
                    _currentPage--;
                  });
                }
                    : null,
                icon: const Icon(Icons.arrow_back_ios, size: 16,color: AppColors.mainWebAppColor,),
                color: _currentPage > 1 ? AppColors.mainAppColor : Colors.grey,
              ),
              IconButton(
                onPressed: _currentPage < _totalPages
                    ? () {
                  setState(() {
                    _currentPage++;
                  });
                }
                    : null,
                icon: const Icon(Icons.arrow_forward_ios, size: 16,color: AppColors.mainWebAppColor,),
                color: _currentPage < _totalPages ? AppColors.mainAppColor : Colors.grey,
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildCalendarView() {
    final DateTime firstDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final int firstWeekday = (firstDayOfMonth.weekday + 6) % 7; // 0 = Monday
    final DateTime gridStart = firstDayOfMonth.subtract(Duration(days: firstWeekday));
    final DateTime nextMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
    final DateTime lastDayOfMonth = nextMonth.subtract(const Duration(days: 1));
    final int daysInMonth = lastDayOfMonth.day;
    final int totalCells = ((firstWeekday + daysInMonth) / 7).ceil() * 7;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingSmall),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ----------- Month navigation --------------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
                  });
                },
                icon: const Icon(Icons.chevron_left),
              ),
              Text(
                DateFormat('MMMM yyyy', 'fr_FR').format(_currentMonth),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.loginTitleColor,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
                  });
                },
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingMedium),
          // // ----------- Days of week header -----------
          Row(
            children: ['Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi', 'Dimanche']
                .map((day) => Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Center(
                  child: Text(
                    day,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ))
                .toList(),
          ),
          const Divider(height: 1),
/*
          // -----------  Calendar grid -----------
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double itemHeight = (constraints.maxHeight - (4 * 5)) / 6; // 6 rows max
                final double itemWidth = (constraints.maxWidth - (4 * 6)) / 7;
                final double aspectRatio = itemWidth / itemHeight ;

                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                    childAspectRatio: 0.9,
                   // childAspectRatio: aspectRatio,
                  ),
                  itemCount: totalCells,
                  itemBuilder: (context, index) {
                    final DateTime day = gridStart.add(Duration(days: index));
                    final bool isCurrentMonth = day.month == _currentMonth.month;
                    final bool isToday = _formatDateKey(day) == _formatDateKey(_today);
                    final List<Reunion> dayReunions = _getReunionsForDate(day);

                    // Debug for November 24 (any year)
                    if (day.month == 11 && day.day == 24) {
                      debugPrint('Date key: ${_formatDateKey(day)}');
                      debugPrint('Looking for reunions in: ${_reunionsByDate.keys.where((key) => key.contains('11-24')).toList()}');
                      if (dayReunions.isNotEmpty) {
                        debugPrint('Reunions found: ${dayReunions.map((e) => e.title).toList()}');
                      }
                    }

                    return UtilsWidget().evenementGridForCalendarDay(context,day, isCurrentMonth, isToday, dayReunions);
                  },
                );
              },
            ),
          ),*/
        ],
      ),
    );
  }
}

