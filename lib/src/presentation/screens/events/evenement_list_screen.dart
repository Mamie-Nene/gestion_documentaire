
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import '/src/presentation/widgets/app_page_shell.dart';
import '/src/presentation/widgets/utils_widget.dart';
import '/src/presentation/widgets/search_and_filter.dart';
import '/src/data/remote/events_api.dart';
import '/src/domain/remote/Event.dart';

import '/src/utils/api/api_url.dart';
import '/src/utils/consts/app_specifications/all_directories.dart';


class EventListScreen extends StatefulWidget {
  const EventListScreen({super.key});

  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  final TextEditingController _searchController = TextEditingController();

  DateTime _currentMonth = DateTime.now();
  final DateTime _today = DateTime.now();

  bool listView=true;
  List<Event> events = [];
  bool _isEventsLoading=false;

  // Pagination state
  int _currentPage = 1;
  int _itemsPerPage = 10;
  final List<int> _itemsPerPageOptions = [10, 20, 30, 50];


  @override
  void initState() {
    eventsGetted();
    listView =true;
    super.initState();
  }

  eventsGetted() async {
    setState(() {
      _isEventsLoading = true;
    });
    await EventsApi().getListEvents( ApiUrl().getEventsUrl).then((value) {
      setState(() {
        events = value ?? [];
       // events = value;
        _isEventsLoading=false;

        debugPrint('Loaded ${events.length} events from API');
      });
    }).catchError((error) {
      setState(() {
        _isEventsLoading=false;
      });
      debugPrint('Error loading events: $error');
    });
  }

  List<Event> get _visibleEvents {
    return events.where((event) {
      final bool matchesSearch = event.title
          .toLowerCase()
          .contains(_searchController.text.toLowerCase());

      return matchesSearch ;
    }).toList();
  }

  String _formatDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Map<String, List<Event>> get _eventsByDate {
    final Map<String, List<Event>> map = {};
    debugPrint('=== Mapping events by date ===');
    debugPrint('Total visible events: ${_visibleEvents.length}');

    for (var event in _visibleEvents) {
      try {
        // Parse the date string - API returns ISO 8601 format: "2025-11-24T08:00:00"
        DateTime eventDate;
        String dateStr = event.startDate.trim();

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
      //  debugPrint('✓ Event: "${event.title}" | Date: "${event.eventDate}" → Parsed: $eventDate → Key: $key');

        if (map[key] == null) {
          map[key] = [];
        }
        map[key]!.add(event);
      } catch (e) {
        debugPrint('Erreur de transformation de date events de "${event.title}": "${event.startDate}" - Erreur: $e');
        // Skip invalid dates
      }
    }

   /* debugPrint('Events mapped to ${map.keys.length} unique dates');
    debugPrint('All date keys: ${map.keys.toList()}');
    debugPrint('Looking for November 24: ${map.keys.where((k) => k.contains('11-24')).toList()}');
    debugPrint('==============================');*/
    return map;
  }

  List<Event> _getEventsForDate(DateTime date) {
    final key = _formatDateKey(date);
    return _eventsByDate[key] ?? [];
  }

  int get _totalPages {
    return (_visibleEvents.length / _itemsPerPage).ceil();
  }

  @override
  Widget build(BuildContext context) {
    return  AppPageShell(
      isForHomePage: false,
      title: "Gestion des événements",
      whiteColorForMainCardIsHere:true,
      /*actions: [
        GestureDetector(
          onTap: () {Navigator.of(context).pushNamed(AppRoutesName.eventCalendarPage);},
         // onTap: () {Navigator.of(context).pushNamed(AppRoutesName.addEventPage);},

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
                  "Ajouter un évenement",
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
      ],*/
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSearchAndFilter(),

          const SizedBox(height: AppDimensions.paddingMedium),

          _isEventsLoading
              ? Center(
              child: CircularProgressIndicator()
          )
              : _visibleEvents.isEmpty
              ? Center(
              child: Text('La liste est vide !')
          )
              :
          listView?
          Container(
            child: Column(
              children: [
                UtilsWidget().evenementGridForViewList(context,_visibleEvents.reversed,false),
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

    );
  }
//floatingActionButton: _buildFloatingActionButton(),

  Widget _buildSearchAndFilter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SearchAndFilter(
            searchController: _searchController,
            onChangeFunction: (_)=> setState(() {_currentPage = 1;}),
            text: 'Rechercher un événement....',
            isExpanded: false
        ),
        /*Container(
          width: 300,
            decoration: BoxDecoration(
              color: Color(0xffF9F9F9),
              //color: AppColors.cardSurface,
              borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),

            ),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {
                _currentPage = 1; // Reset to first page on search
              }),
              decoration: const InputDecoration(
                hintText: 'Rechercher un fichier....',
                prefixIcon: Icon(Icons.search_rounded, color: Colors.black54),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  vertical: AppDimensions.paddingMedium,
                  horizontal: AppDimensions.paddingMedium,
                ),
              ),
            ),
          ),*/
       /* const SizedBox(width: AppDimensions.paddingMedium),
        InkWell(
          onTap: () {
            // TODO: Show filter dialog
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingMedium,
              vertical: AppDimensions.paddingMedium,
            ),
            decoration: BoxDecoration(
              color: AppColors.cardSurface,
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
            ),
            child:  const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.filter_list, color: Colors.black54, size: 20),
                SizedBox(width: 8),
                Text(
                  'Filtrer',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),*/
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingMedium,
            vertical: AppDimensions.paddingSmall,
          ),
          decoration: BoxDecoration(
            color: Color(0xffF2F5F9),
            borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium),
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
                      color: listView?Color(0xffE4ECF5):Colors.transparent,
                      borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium),
                    ),
                    child: Text("Vu liste",
                    style: TextStyle(
                      color: listView? Color(0xff205DA9):Color(0xff2D3748),
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
                    color: listView?Colors.transparent:Color(0xffE4ECF5),
                    borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
                  ),
                  child: Text("Vu calendrier",
                    style: TextStyle(
                      color: listView? Color(0xff2D3748):Color(0xff205DA9),
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

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () {},
      backgroundColor: AppColors.mainAppColor,
      foregroundColor: Colors.white,
      icon: const Icon(Icons.add),
      label: const Text("Ajout d'un évenement"),
    );
  }

  Widget _buildPaginationControls() {
    final totalItems = _visibleEvents.length;
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
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.grey.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Text(
                'éléments par page:',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.withOpacity(0.3)),
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
                icon: const Icon(Icons.arrow_back_ios, size: 16),
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
                icon: const Icon(Icons.arrow_forward_ios, size: 16),
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
                    final List<Event> dayEvents = _getEventsForDate(day);

                    // Debug for November 24 (any year)
                    if (day.month == 11 && day.day == 24) {
                      debugPrint('Date key: ${_formatDateKey(day)}');
                      debugPrint('Looking for events in: ${_eventsByDate.keys.where((key) => key.contains('11-24')).toList()}');
                      if (dayEvents.isNotEmpty) {
                        debugPrint('Events found: ${dayEvents.map((e) => e.title).toList()}');
                      }
                    }

                    return UtilsWidget().evenementGridForCalendarDay(context,day, isCurrentMonth, isToday, dayEvents);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

}

