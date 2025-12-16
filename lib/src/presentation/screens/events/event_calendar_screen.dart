import 'package:flutter/material.dart';
import 'package:gestion_documentaire/src/presentation/widgets/app_page_shell.dart';
import '/src/data/remote/events_api.dart';
import '/src/domain/remote/Event.dart';
import '/src/utils/api/api_url.dart';
import '/src/utils/consts/app_specifications/all_directories.dart';
import '/src/utils/consts/routes/app_routes_name.dart';
import 'package:intl/intl.dart';

class EventCalendarScreen extends StatefulWidget {
  const EventCalendarScreen({super.key});

  @override
  State<EventCalendarScreen> createState() => _EventCalendarScreenState();
}

class _EventCalendarScreenState extends State<EventCalendarScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isEventsLoading = false;
  List<Event> events = [];
  DateTime _currentMonth = DateTime.now();
  int _viewMode = 1; // 0 = Liste, 1 = Calendrier
  final DateTime _today = DateTime.now();

  @override
  void initState() {
    super.initState();
    getEvents();
  }

  getEvents() async {
    setState(() {
      _isEventsLoading = true;
    });
    await EventsApi().getListEvents(ApiUrl().getEventsUrl).then((value) {
      setState(() {
        events = value ?? [];
        _isEventsLoading = false;
      });
    }).catchError((error) {
      setState(() {
        _isEventsLoading = false;
      });
    });
  }

  String _formatDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Map<String, List<Event>> get _eventsByDate {
    final Map<String, List<Event>> map = {};
    for (var event in events) {
      try {
        final eventDate = DateTime.parse(event.eventDate);
        final key = _formatDateKey(eventDate);
        if (map[key] == null) {
          map[key] = [];
        }
        map[key]!.add(event);
      } catch (e) {
        // Skip invalid dates
      }
    }
    return map;
  }

  List<Event> _getEventsForDate(DateTime date) {
    final key = _formatDateKey(date);
    return _eventsByDate[key] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return AppPageShell(
      isForHomePage: false,
      title: "Gestion des événement",
        whiteColorForMainCardIsHere:true,
      actions: [
        GestureDetector(
          onTap: () {
            // TODO: Navigate to add event page
          },
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
                  "Ajouter un événement",
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
      padding: EdgeInsets.zero,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingLarge,
                vertical: AppDimensions.paddingMedium,
              ),
              child: Column(
                children: [
                  _buildSearchAndFilter(),
                  const SizedBox(height: AppDimensions.paddingMedium),
                  _buildViewToggle(),
                ],
              ),
            ),
            Expanded(
              child: _viewMode == 1
                  ? _buildCalendarView()
                  : _buildListView(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Row(
      children: [
        Expanded(
          child: Container(
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
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
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
          ),
        ),
        const SizedBox(width: AppDimensions.paddingMedium),
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
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                // TODO: Show filter dialog
              },
              borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingMedium,
                  vertical: AppDimensions.paddingMedium,
                ),
                child: const Row(
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
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildViewToggle() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildToggleButton(
            label: 'Vue liste',
            isSelected: _viewMode == 0,
            onTap: () => setState(() => _viewMode = 0),
          ),
          _buildToggleButton(
            label: 'Vue calendrier',
            isSelected: _viewMode == 1,
            onTap: () => setState(() => _viewMode = 1),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.mainAppColor : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.black87,
            fontSize: 14,
          ),
        ),
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
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingLarge),
      child: Column(
        children: [
          // Days of week header
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
          // Calendar grid
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double itemHeight = (constraints.maxHeight - (4 * 5)) / 6; // 6 rows max
                final double itemWidth = (constraints.maxWidth - (4 * 6)) / 7;
                final double aspectRatio = itemWidth / itemHeight;

                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                    childAspectRatio: aspectRatio,
                  ),
                  itemCount: totalCells,
                  itemBuilder: (context, index) {
                    final DateTime day = gridStart.add(Duration(days: index));
                    final bool isCurrentMonth = day.month == _currentMonth.month;
                    final bool isToday = _formatDateKey(day) == _formatDateKey(_today);
                    final List<Event> dayEvents = _getEventsForDate(day);

                    return _buildCalendarDay(day, isCurrentMonth, isToday, dayEvents);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarDay(DateTime day, bool isCurrentMonth, bool isToday, List<Event> dayEvents) {
    Color? backgroundColor;
    String? labelText;
    Color? labelColor;

    if (isToday) {
      backgroundColor = Colors.green[50];
      labelText = 'Aujourd\'hui';
      labelColor = Colors.green;
    } else if (dayEvents.isNotEmpty) {
      // Use different colors for different events
      final event = dayEvents.first;
      if (event.title.toLowerCase().contains('numerique') || event.title.toLowerCase().contains('numérique')) {
        backgroundColor = Colors.blue[50];
        labelText = event.title;
        labelColor = Colors.blue;
      } else if (event.title.toLowerCase().contains('e-commerce') || event.title.toLowerCase().contains('forum')) {
        backgroundColor = Colors.orange[50];
        labelText = event.title;
        labelColor = Colors.orange;
      } else {
        backgroundColor = Colors.blue[50];
        labelText = event.title;
        labelColor = Colors.blue;
      }
    }

    return InkWell(
      onTap: () {
        // TODO: Show events for this day
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              day.day.toString(),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isCurrentMonth ? Colors.black87 : Colors.grey[400],
              ),
            ),
            if (labelText != null && dayEvents.isNotEmpty) ...[
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: labelColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  labelText.length > 12 ? '${labelText.substring(0, 12)}...' : labelText,
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildListView() {
    // TODO: Implement list view
    return const Center(
      child: Text('Vue liste à implémenter'),
    );
  }
}

