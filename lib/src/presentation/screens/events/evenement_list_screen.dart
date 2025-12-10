import 'dart:math';

import 'package:flutter/material.dart';
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

  @override
  void initState() {
    eventsGetted();
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
                    //_buildSearchField(),
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
                    _buildFilterChips(),
                    const SizedBox(height: AppDimensions.paddingMedium),

                    _isEventsLoading?
                    CircularProgressIndicator()
                    :
                    _visibleEvents.isEmpty?
                    Text('La liste est vide !')

                        :
                    _buildEventList( _visibleEvents)
                  ],
                ),
              ),
             // _buildTabBar(),
             // const Divider(height: 1, color: AppColors.dividerLight),

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
            /*decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradient[index],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius:
              BorderRadius.circular(AppDimensions.borderRadiusLarge),
              boxShadow: [
                BoxShadow(
                  color: gradient[index].last.withOpacity(0.25),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
            ),*/
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
}

class _EventTile extends StatelessWidget {
  const _EventTile({
    required this.event,
    required this.onTap,
  });

  final Event event;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    DateTime dateCreation = DateTime.parse(event.eventDate);
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
                color: AppColors.mainAppColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.article_outlined, color:AppColors.mainAppColor, size: 28),
            ),
            const SizedBox(width: AppDimensions.paddingMedium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.loginTitleColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text("Gainde 2000",
                    style: TextStyle(color: AppColors.textMainPageColor),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.schedule,
                          size: 14,
                          color: AppColors.textMainPageColor.withOpacity(0.7)),
                      const SizedBox(width: 4),
                      Text(formatted,
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
