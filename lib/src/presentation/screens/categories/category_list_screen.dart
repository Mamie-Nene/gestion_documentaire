import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gestion_documentaire/src/presentation/widgets/app_page_shell.dart';
import '/src/data/remote/category_api.dart';
import '/src/domain/remote/Categorie.dart';
import '/src/utils/api/api_url.dart';
import '/src/utils/consts/app_specifications/all_directories.dart';
import '/src/utils/consts/routes/app_routes_name.dart';
import 'package:intl/intl.dart';

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({super.key});

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  static const _tabs = ['Récents', 'Partagés', 'Favoris'];
  static const _filters = ["Aujourd'hui", 'Cette semaine', 'Ce mois'];
  int _activeFilter = 0;
  final TextEditingController _searchController = TextEditingController();

  bool _isCategoriesLoading=false;
  List<Categorie> categoriesGetted = [];


  getCategories() async {
    await CategoriesApi().getListCategory( ApiUrl().getCategoriesUrl).then((value) {
      setState(() {
        categoriesGetted = value;
        _isCategoriesLoading=false;
      });
    }).catchError((error) {
      setState(() {
        _isCategoriesLoading=false;
      });
    });
  }

  List<Categorie> get _visibleCategories {
    return categoriesGetted.where((categorie) {
      final bool matchesSearch = categorie.name
          .toLowerCase()
          .contains(_searchController.text.toLowerCase());

      return matchesSearch ;
    }).toList();
  }

  @override
  void initState() {
    getCategories();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // floatingActionButton: _buildFloatingActionButton(),
    //
    return  AppPageShell(
      isForHomePage: false,
      title: "Gestion Categorie",
      actions:[
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xffF5F6F9)),
            borderRadius: BorderRadius.circular(12),
          ),
          child:Row(
            children: [
              Icon(Icons.add, color: Colors.white, size: 20),
              SizedBox(width: 10),
              Text("Ajouter une catégorie",style: TextStyle(color: Colors.white,fontSize: 20),)
            ],
          ),
        )
      ],
      child:
         SafeArea(
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
                    const SizedBox(height: AppDimensions.paddingLarge),
                    _isCategoriesLoading?
                    CircularProgressIndicator()
                        :
                    _visibleCategories.isEmpty?
                    Text('La liste est vide !')
                    :
                    _buildCategoryList(_visibleCategories),

                  ],
                ),
              ),

            ],
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
              'Type de documents',
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
  Widget _buildCategoryList(List<Categorie>categoriesGetted) {

    final categories = categoriesGetted;
   // final documents = _generateDocuments(tabIndex);
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
      itemCount: categories.length,//categories
      itemBuilder: (context, index) {
        final category = categories[index]; //categories[index];
         final Random random = Random();
        Color accentPalette=Color.fromARGB(
          255, // Alpha (opacity)
          random.nextInt(256), // Red
          random.nextInt(256), // Green
          random.nextInt(256), // Blue
        );
        DateTime dateCreation = DateTime.parse(category.createdAt);
        String formatted = DateFormat("yyyy-MM-dd HH:mm:ss").format(dateCreation);

        IconData iconGetted= Icons.article_outlined;
        return InkWell(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
          onTap: () => Navigator.pushNamed(context,AppRoutesName.documentPage,arguments: {"category": category.id, "subtitle":category.name}),
          child: Container(
            padding: const EdgeInsets.all(AppDimensions.paddingMedium),//large
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
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppDimensions.paddingSmall),
                      decoration: BoxDecoration(
                        color: accentPalette.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(iconGetted, color: accentPalette, size: 28),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      category.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.loginTitleColor,
                      ),
                    ),

                  ],
                ),
                RichText(
                    text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Nombre de docs : ",
                            style: TextStyle(color: AppColors.textMainPageColor,fontSize: 17),
                          ),
                          TextSpan(
                            text: category.documentCount.toString(),
                            style: TextStyle(color: AppColors.textMainPageColor,fontSize: 19),
                          )]
                    )),

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
      label: const Text('Nouvelle catégorie'),
    );
  }
}


