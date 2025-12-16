import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gestion_documentaire/src/presentation/widgets/app_page_shell.dart';
import 'package:gestion_documentaire/src/presentation/widgets/utils_widget.dart';
import '/src/data/remote/events_api.dart';
import '/src/domain/remote/Event.dart';
import '/src/utils/api/api_url.dart';
import '/src/utils/consts/app_specifications/all_directories.dart';
import '/src/utils/consts/routes/app_routes_name.dart';
import 'package:intl/intl.dart';

class EventListScreen extends StatefulWidget {
  const EventListScreen({super.key});

  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  static const _tabs = ['Récents', 'Partagés', 'Favoris'];
  static const _filters = ["Aujourd'hui", 'Cette semaine', 'Ce mois'];
  int _activeFilter = 0;
  final TextEditingController _searchController = TextEditingController();

  List<Event> events = [];
  bool _isEventsLoading=false;

  // Pagination state
  int _currentPage = 1;
  int _itemsPerPage = 10;
  final List<int> _itemsPerPageOptions = [10, 20, 30, 50];


  @override
  void initState() {
    eventsGetted();
    super.initState();
  }

  eventsGetted() async {
    await EventsApi().getListEvents( ApiUrl().getEventsUrl).then((value) {
      setState(() {
        events = value;
        _isEventsLoading=false;
      });
    }).catchError((error) {
      setState(() {
        _isEventsLoading=false;
      });
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

  List<Event> get _paginatedEvents {
    final filtered = _visibleEvents;
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;
    return filtered.length > startIndex
        ? filtered.sublist(
      startIndex,
      endIndex > filtered.length ? filtered.length : endIndex,
    )
        : [];
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
      child: Column(
       mainAxisSize: MainAxisSize.min,
        children: [
           Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              /*  _buildTopBar(context),
                const SizedBox(height: AppDimensions.paddingMedium),
                //_buildSearchField(),*/
                Container(
                  decoration: BoxDecoration(
                   // color: AppColors.cardSurface,
                    color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
                       /* boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 12,
                            offset: const Offset(0, 8),
                          ),
                        ],*/
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
                _buildFilterChips(),
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
                UtilsWidget().evenementGrid(context,_visibleEvents,false),
                // UtilsWidget().evenementGrid(context,_visibleEvents),
                // UtilsWidget().evenementGrid(context,_visibleEvents),
              ],
           ),
          _buildPaginationControls()
             // _buildTabBar(),

            ],
          ),

      );
  }
//floatingActionButton: _buildFloatingActionButton(),
//
  Widget _buildTopBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.mainAppColor),
        ),

            Text(
              'Evénements',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.loginTitleColor,
              ),
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


  Widget _buildEventList(List<Event> events) {
    final evenements = events;
    //final evenement = _generateDocuments(tabIndex);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppDimensions.paddingLarge,
        mainAxisSpacing: AppDimensions.paddingLarge,
        childAspectRatio: 2.3,
        // childAspectRatio: 1.2,
      ),
      itemCount: evenements.length,//
      itemBuilder: (context, index) {
        final event = evenements[index]; //categories[index];
       final Random random = Random();
        Color accentPalette=Color.fromARGB(
          255, // Alpha (opacity)
          random.nextInt(256), // Red
          random.nextInt(256), // Green
          random.nextInt(256), // Blue
        );
        DateTime dateCreation = DateTime.parse(event.eventDate);
        String formatted = DateFormat("yyyy-MM-dd HH:mm:ss").format(dateCreation);

        IconData iconGetted= Icons.article_outlined;
        return InkWell(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
          onTap: () => Navigator.pushNamed(context,AppRoutesName.documentPage,arguments: {"event":event.id,"subtitle":event.title}),
          child: Container(
            padding: const EdgeInsets.all(AppDimensions.paddingLarge),//large
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Text(
                  event.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.loginTitleColor,
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.location_on_outlined,color: AppColors.textMainPageColor,size: 18,),
                    RichText(
                        text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Lieu : ",
                          style: TextStyle(color: AppColors.textMainPageColor,fontSize: 18),
                        ),
                        TextSpan(
                          text: "CICAD",
                          style: TextStyle(color: AppColors.mainblueColor,fontSize: 19),
                        )]
                    )),
                  ],
                ),


                Icon(Icons.arrow_outward_rounded, color: AppColors.mainblueColor, size: 20),
              ],
            ),
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

}

