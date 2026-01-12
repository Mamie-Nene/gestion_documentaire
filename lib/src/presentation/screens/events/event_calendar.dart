import 'package:flutter/material.dart';

import '/src/utils/consts/app_specifications/all_directories.dart';

import '/src/utils/consts/routes/app_routes_name.dart';
import '/src/utils/consts/app_specifications/app_colors.dart';


class EventOnCalendarPage extends StatefulWidget {
  const EventOnCalendarPage({super.key});

  @override
  State<EventOnCalendarPage> createState() => _EventOnCalendarPageState();
}

class _EventOnCalendarPageState extends State<EventOnCalendarPage> {

  final DateTime _today = DateTime.now();
  late DateTime _weekStart; // Monday of current week
  late DateTime _currentMonthFirstDay;

  final int _startHour = 7; // 07:00
  final int _endHour = 19; // 19:00

  int _viewIndex = 0; // 0 = Week, 1 = Month

  // Key: yyyy-MM-dd, Value: list of events
  final Map<String, List<CalendarEventEntity>> _planningsByDay = {};

  String _reformatDateGetted(DateTime d) => '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  @override
  void initState() {
    super.initState();
    _weekStart = _today.subtract(Duration(days: (_today.weekday + 6) % 7));
    _currentMonthFirstDay = DateTime(_today.year, _today.month, 1);
    _loadPlanningExemple();
  }

  void _loadPlanningExemple() {
    final String dateKeyFormat = _reformatDateGetted(_today);
    print("get data $dateKeyFormat");
    _planningsByDay[dateKeyFormat] = [
      CalendarEventEntity(
        title: 'Consultation - Salle 3',
        start: DateTime(_today.year, _today.month, _today.day, 9, 0),
        end: DateTime(_today.year, _today.month, _today.day, 9, 45),
        color:  AppColors.mainAppColor,
      ),
      CalendarEventEntity(
        title: 'Réunion de Coordination',
        start: DateTime(_today.year, _today.month, (_today.day + 3), 17, 0),
        end: DateTime(_today.year, _today.month, (_today.day + 3 ), 17, 45),
        color:  AppColors.mainAppColor,
      ),
      CalendarEventEntity(
        title: 'Briefing chirurgical',
        start: DateTime(_today.year, _today.month, _today.day, 11, 0),
        end: DateTime(_today.year, _today.month, _today.day, 12, 0),
        color: AppColors.secondAppColor,
      ),
    ];
  }


  void _goToPreviousWeek() {
    setState(() {
      _weekStart = _weekStart.subtract(const Duration(days: 7));
    });
  }

  void _goToNextWeek() {
    setState(() {
      _weekStart = _weekStart.add(const Duration(days: 7));
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pushNamed(context, AppRoutesName.homePage),
        ),
        title: const Text(
          'Gestion des évenements',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
        ),
      ),

      body: _viewIndex == 0
          ? Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                toggleButtonsForChoice(),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    _goToPreviousWeek();
                  },
                  icon: const Icon(Icons.chevron_left, color: Colors.black87),
                  tooltip: 'Précédent',
                ),
                Text(
                  _weekRangeLabel(),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                IconButton(
                  onPressed: () {
                    _goToNextWeek();
                  },
                  icon: const Icon(Icons.chevron_right, color: Colors.black87),
                  tooltip: 'Suivant',
                ),
              ],
            ),
          ),
          _buildWeekHeader(),
          const Divider(height: 1),
          Expanded(
            child: Row(
              children: [
                PlanningMedecinUtils().buildLeftTimer(_startHour,_endHour),
                Expanded(
                  child: _buildWeekGrid(size),
                ),
              ],
            ),
          ),
        ],
      )
          : Column(
        children: [
          // Top toolbar also for month view
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                toggleButtonsForChoice(),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _currentMonthFirstDay = DateTime(
                        _currentMonthFirstDay.year,
                        _currentMonthFirstDay.month - 1,
                        1,
                      );
                    });
                  },
                  icon: const Icon(Icons.chevron_left, color: Colors.black87),
                  tooltip: 'Précédent',
                ),
                Text(
                  _monthLabel(),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _currentMonthFirstDay = DateTime(
                        _currentMonthFirstDay.year,
                        _currentMonthFirstDay.month + 1,
                        1,
                      );
                    });
                  },
                  icon: const Icon(Icons.chevron_right, color: Colors.black87),
                  tooltip: 'Suivant',
                ),
              ],
            ),
          ),
          Expanded(child: _buildMonthGrid()),
        ],
      ),

    );
  }

  toggleButtonsForChoice(){
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          AppActionButton().buildModeChipForPlannification(
            label: 'Semaine',
            index: 0,
            viewIndex: _viewIndex,
            selectedBg: AppColors.mainAppColor,
            selectedText: Colors.white,
            action: () {
              setState(() {
                _viewIndex = 0;
              });
            },
          ),
          AppActionButton().buildModeChipForPlannification(
              label: 'Mois',
              index: 1,
              viewIndex: _viewIndex,
              selectedBg: AppColors.mainAppColor,
              selectedText: Colors.white,
              action: () {
                setState(() {
                  _viewIndex = 1;
                });
              }
          ),
        ],
      ),
    );
  }


  Widget _buildWeekHeader() {
    final List<Widget> dayLabels = [];
    for (int i = 0; i < 7; i++) {
      final DateTime day = _weekStart.add(Duration(days: i));
      final bool isToday = _reformatDateGetted(day) == _reformatDateGetted(_today);
      dayLabels.add(
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            color: isToday ? Colors.blue[50] : Colors.white,
            child: Column(
              spacing: 4,
              children: [
                Text(
                  LocalDataForDoctorEvenPlanification().weekdayShort(day.weekday),
                  style: TextStyle(
                    color: isToday? AppColors.mainAppColor : Colors.grey[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isToday ?  AppColors.mainAppColor : Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(day.day.toString().padLeft(2, '0'),
                    // '${day.day.toString().padLeft(2, '0')}/${day.month.toString().padLeft(2, '0')}',
                    style: TextStyle(
                      color: isToday ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(left:56 ),
      child: Row(
        children: [
          ...dayLabels,
        ],
      ),
    );
  }


  Widget _buildWeekGrid(Size size) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double hourHeight = 60; // each hour = 60 px
        final double dayWidth = constraints.maxWidth/7;

        return SingleChildScrollView(
          child: SizedBox(
            height: (_endHour - _startHour + 1) * hourHeight,
            child: Stack(
              children: [
                // Grid
                Row(
                  children: List.generate(7, (i) {
                    return SizedBox(
                      width: dayWidth,
                      child: Column(
                        children: List.generate(_endHour - _startHour + 1, (j) {
                          return Container(
                            height: hourHeight,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                top: BorderSide(color: Colors.grey[200]!),
                                right: BorderSide(color: Colors.grey[200]!),
                              ),
                            ),
                          );
                        }),
                      ),
                    );
                  }),
                ),

                // Events
                ...List<Widget>.generate(7, (dayIndex) {
                  final DateTime day = _weekStart.add(Duration(days: dayIndex));
                  final String key = _reformatDateGetted(day);
                  final List<CalendarEventEntity> events = _planningsByDay[key] ?? [];
                  return Stack(
                    children: events.map((e) {
                      final double top = _positionForTime(e.start, hourHeight);
                      final double height = (e.end.difference(e.start).inMinutes / 60) * hourHeight;
                      return Positioned(
                        left: dayWidth * dayIndex + 4, //dayWidth * dayIndex,
                        right:  4 +(dayWidth *  dayIndex), // 4 +(dayWidth * (6 - dayIndex)),
                        top: top,
                        height: height.clamp(70, double.infinity),
                        child: EventTitleWidget(event: e, onTap: () => _showEvent(e)),
                      );
                    }).toList(),
                  );
                }),

                // Tap areas for creating events
                /* Positioned.fill(
                  child: Row(
                    children: List.generate(7, (dayIndex) {
                      final DateTime day = _weekStart.add(Duration(days: dayIndex));
                      return SizedBox(
                        width: dayWidth,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTapDown: (d) {
                            final double localY = d.localPosition.dy;
                            final int minutesFromStart = (localY / 60 * 60).round();
                            final int hour = _startHour + (minutesFromStart ~/ 60);
                            final int minute = (minutesFromStart % 60) - (minutesFromStart % 30);
                            final DateTime start = DateTime(day.year, day.month, day.day, hour, minute.clamp(0, 59));
                            _promptCreateEvent(day, start);
                          },
                        ),
                      );
                    }),
                  ),
                ),*/
              ],
            ),
          ),
        );
      },
    );
  }

  double _positionForTime(DateTime time, double hourHeight) {
    final int totalMinutes = (time.hour - _startHour) * 60 + time.minute;
    return totalMinutes * (hourHeight / 60);
  }


  String _weekRangeLabel() {
    final DateTime end = _weekStart.add(const Duration(days: 6));
    final String startLabel = '${_weekStart.day.toString().padLeft(2, '0')}/${_weekStart.month.toString().padLeft(2, '0')}';
    final String endLabel = '${end.day.toString().padLeft(2, '0')}/${end.month.toString().padLeft(2, '0')}';
    return '$startLabel - $endLabel';
  }

  String _monthLabel() {
    final List<String> months = const [
      'janvier','février','mars','avril','mai','juin','juillet','août','septembre','octobre','novembre','décembre'
    ];
    return '${months[_currentMonthFirstDay.month - 1]} ${_currentMonthFirstDay.year}';
  }

  Widget _buildMonthGrid() {
    final DateTime first = _currentMonthFirstDay;
    final int firstWeekday = (first.weekday + 6) % 7; // 0 = Mon ... 6 = Sun
    final DateTime gridStart = first.subtract(Duration(days: firstWeekday));
    final DateTime nextMonth = DateTime(first.year, first.month + 1, 1);
    final DateTime gridEndCandidate = nextMonth.subtract(const Duration(days: 1));
    final int totalDays = gridEndCandidate.difference(gridStart).inDays + 1;
    final int cells = ((totalDays / 7).ceil() * 7).clamp(35, 42); // 5 or 6 weeks

    return Column(
      children: [
        Row(
          children: List.generate(7, (i) => Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Center(
                child: Text(
                  ['Lun','Mar','Mer','Jeu','Ven','Sam','Dim'][i],
                  style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.grey),
                ),
              ),
            ),
          )),
        ),
        const Divider(height: 1),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              const double horizontalPadding = 8;
              const double verticalPadding = 8;
              const double crossSpacing = 8;
              const double mainSpacing = 8;
              final int rows = (cells / 7).ceil();

              final double totalWidth = constraints.maxWidth - (horizontalPadding * 2) - ((7 - 1) * crossSpacing);
              final double itemWidth = totalWidth / 7;

              final double totalHeight = constraints.maxHeight - (verticalPadding * 2) - ((rows - 1) * mainSpacing);
              final double itemHeight = (rows > 0) ? (totalHeight / rows) : totalHeight;
              final double aspectRatio = itemWidth / itemHeight;

              return GridView.builder(
                padding: const EdgeInsets.all(8),
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  crossAxisSpacing: crossSpacing,
                  mainAxisSpacing: mainSpacing,
                  childAspectRatio: aspectRatio,
                ),
                itemCount: cells,
                itemBuilder: (context, index) {
                  final DateTime day = gridStart.add(Duration(days: index));
                  final bool inMonth = day.month == first.month;
                  final bool isToday = _reformatDateGetted(day) == _reformatDateGetted(_today);
                  final String key = _reformatDateGetted(day);
                  final List<CalendarEventEntity> events = _planningsByDay[key] ?? [];
                  return InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      setState(() {
                        _weekStart = day.subtract(Duration(days: (day.weekday + 6) % 7));
                        _viewIndex = 0; // switch to week
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: isToday ?  AppColors.mainAppColor : Colors.grey[200]!),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2)),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: isToday ?  AppColors.mainAppColor : Colors.grey[100],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  day.day.toString(),
                                  style: TextStyle(
                                    color: isToday ? Colors.white : (inMonth ? Colors.black87 : Colors.grey),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 4,
                            runSpacing: 4,
                            children: events.take(3).map((e) => PlanningMedecinUtils().dotForExistingEvent(e.color)).toList(),
                          ),
                          const Spacer(),
                          if (events.length > 3)
                            Text(
                              '+${events.length - 3} autres',
                              style: const TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.w600),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }



  void _createEventAtNow() {
    final DateTime day = _today;
    final DateTime start = DateTime(day.year, day.month, day.day, 14, 0);
    _promptCreateEvent(day, start);
  }

  Future<void> _promptCreateEvent(DateTime day, DateTime start) async {
    final TextEditingController controller = TextEditingController();
    final DateTime end = start.add(const Duration(minutes: 45));
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor:Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text('Créer un événement'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')} - ${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}'),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: 'Titre',

                  focusColor:AppColors.mainAppColor,
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: AppColors.mainAppColor,
                    ),
                  ),
                  border: OutlineInputBorder(
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler',style: TextStyle(color: Colors.red),),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: BorderSide(    color: AppColors.mainAppColor,)
              ),
              onPressed: () {
                final String key = _reformatDateGetted(day);
                final List<CalendarEventEntity> list = _planningsByDay[key] ?? [];
                list.add(CalendarEventEntity(
                  title: controller.text.isEmpty ? 'Nouvelle tâche' : controller.text,
                  start: start,
                  end: end,
                  color:  AppColors.mainAppColor,
                ));
                _planningsByDay[key] = list;
                setState(() {});
                Navigator.pop(context);
              },
              child: const Text('Enregistrer',style: TextStyle(color: AppColors.mainAppColor),),
            ),
          ],
        );
      },
    );
  }

  void _showEvent(CalendarEventEntity e) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: e.color,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      e.title,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${_fmt(e.start)} - ${_fmt(e.end)}',
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  ElevatedButton.icon(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.white),
                        side: MaterialStateProperty.all(
                          BorderSide(
                            color: AppColors.mainAppColor,
                          ),
                        )
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      _editEvent(e);
                    },
                    icon: const Icon(Icons.edit, size: 16,color: AppColors.mainAppColor,),
                    label: const Text('Modifier',style: TextStyle(color: AppColors.mainAppColor),),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    style: ButtonStyle(
                        side: MaterialStateProperty.all(
                          BorderSide(
                            color: Colors.red,
                          ),
                        )),
                    onPressed: () {
                      Navigator.pop(context);
                      _deleteEvent(e);
                    },
                    icon: const Icon(Icons.delete_outline, size: 16,color: Colors.red,),
                    label: const Text('Supprimer',style: TextStyle(color: Colors.red,)),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _editEvent(CalendarEventEntity e) {
    final TextEditingController controller = TextEditingController(text: e.title);
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text('Modifier l\'événement'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Titre',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler',style: TextStyle(color: Colors.red),),
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.white),
                  side: WidgetStateProperty.all(
                    BorderSide(
                      color: AppColors.mainAppColor,
                    ),
                  )
              ),
              onPressed: () {
                setState(() {
                  e.title = controller.text.isEmpty ? e.title : controller.text;
                });
                Navigator.pop(context);
              },
              child: const Text('Enregistrer',style: TextStyle(color: AppColors.mainAppColor)),
            ),
          ],
        );
      },
    );
  }

  void _deleteEvent(CalendarEventEntity e) {
    final String key = _reformatDateGetted(e.start);
    setState(() {
      _planningsByDay[key]?.remove(e);
    });
  }

  String _fmt(DateTime t) => '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
}

class AppActionButton {

  elevatedButtonWithColor({
    required BuildContext context,
    required String textButton,
    required Color textColor,
    required Color colorButton,
    required Color shapeColor,
    required VoidCallback? action,
  }) {
    return
      SizedBox(
        //  padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 17),
        width:MediaQuery.of(context).size.width/1.5,
        height: MediaQuery.of(context).size.height/18,
        child: ElevatedButton (
            style: ElevatedButton.styleFrom(
              elevation: 0,
              //padding: EdgeInsets.fromLTRB(AppDimensions.w10(context), 7, AppDimensions.w10(context),7),
              alignment: Alignment.center,
              backgroundColor:colorButton,
              /* shape: RoundedRectangleBorder(
                  borderRadius:  BorderRadius.circular(3),
                ),*/
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 1,
                  color:shapeColor,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed:action,
            child:Text(textButton,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor,
                fontSize:18,
                fontFamily: 'Lato',
                fontWeight: FontWeight.w600,
              ),
            )
        ),
      );
  }

  Widget buildModeChipForPlannification({
    required String label,
    required int index,
    required int viewIndex,
    required Color selectedBg,
    required Color selectedText,
    required VoidCallback action
  }) {
    final bool selected = viewIndex == index;
    return Padding(
      padding: const EdgeInsets.all(2),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: action,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: selected ?  selectedBg : Colors.transparent,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: selected ? selectedText : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

}
class LocalDataForDoctorEvenPlanification{

  String weekdayShort(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Lun';
      case DateTime.tuesday:
        return 'Mar';
      case DateTime.wednesday:
        return 'Mer';
      case DateTime.thursday:
        return 'Jeu';
      case DateTime.friday:
        return 'Ven';
      case DateTime.saturday:
        return 'Sam';
      case DateTime.sunday:
        return 'Dim';
      default:
        return '';
    }
  }

}


class CalendarEventEntity {
  CalendarEventEntity({required this.title, required this.start, required this.end, required this.color});
  String title;
  DateTime start;
  DateTime end;
  Color color;
}


class EventTitleWidget extends StatelessWidget {
  const EventTitleWidget({required this.event, required this.onTap});

  final CalendarEventEntity event;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: event.color.withOpacity(0.12),
            border: Border.all(color: event.color.withOpacity(0.6), width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: event.color,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      event.title,
                      maxLines: 3,
                      overflow: TextOverflow.fade,
                      softWrap: true,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: _bestOn(event.color),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '${_fmtTime(event.start)} - ${_fmtTime(event.end)}',
                style: TextStyle(fontSize: 12, color: _bestOn(event.color).withOpacity(0.8)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _bestOn(Color c) {
    // Simple luminance-based contrast decision
    return c.computeLuminance() > 0.5 ? Colors.black87 : Colors.black87;
  }

  String _fmtTime(DateTime t) => '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
}


class PlanningMedecinUtils{

  Widget buildLeftTimer(int startHour, int endHour) {
    final List<Widget> ticks = [];
    for (int h = startHour; h <= endHour; h++) {
      ticks.add(
          SizedBox(
            height: 60,
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  '${h.toString().padLeft(2, '0')}:00',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
            ),
          )
      );
    }
    return Container(
      width: 56,
      color: Colors.white,
      child: SingleChildScrollView(child: Column(children: ticks)),
    );
  }

  Widget dotForExistingEvent(Color color) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
    );
  }
}