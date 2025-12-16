import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gestion_documentaire/src/presentation/widgets/app_page_shell.dart';
import '/src/data/remote/category_api.dart';
import '/src/domain/remote/Categorie.dart';
import '/src/utils/api/api_url.dart';
import '/src/utils/consts/app_specifications/all_directories.dart';
import '/src/utils/consts/routes/app_routes_name.dart';

class CategoriePage extends StatefulWidget {
  const CategoriePage({super.key});

  @override
  State<CategoriePage> createState() => _CategoriePageState();
}

class _CategoriePageState extends State<CategoriePage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isCategoriesLoading = false;
  List<Categorie> categoriesGetted = [];
  
  // Pagination state
  int _currentPage = 1;
  int _itemsPerPage = 10;
  final List<int> _itemsPerPageOptions = [10, 20, 30, 50];

  @override
  void initState() {
    super.initState();
    getCategories();
  }

  getCategories() async {
    setState(() {
      _isCategoriesLoading = true;
    });
    await CategoriesApi().getListCategory(ApiUrl().getCategoriesUrl).then((value) {
      setState(() {
        categoriesGetted = value;
        _isCategoriesLoading = false;
      });
    }).catchError((error) {
      setState(() {
        _isCategoriesLoading = false;
      });
    });
  }

  List<Categorie> get _visibleCategories {
    return categoriesGetted.where((categorie) {
      final bool matchesSearch = categorie.name
          .toLowerCase()
          .contains(_searchController.text.toLowerCase());
      return matchesSearch;
    }).toList();
  }

  List<Categorie> get _paginatedCategories {
    final filtered = _visibleCategories;
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
    return (_visibleCategories.length / _itemsPerPage).ceil();
  }

  @override
  Widget build(BuildContext context) {
    return AppPageShell(
      isForHomePage: false,
      title: "Gestion des catégorie",
        whiteColorForMainCardIsHere:true,
      actions: [
        GestureDetector(
          onTap: () {
            // TODO: Navigate to add category page
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
                  "Ajouter une catégorie",
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
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingSmall, vertical: AppDimensions.paddingSmall,
              ),
              child: _buildSearchAndFilter(),
            ),
            const SizedBox(height: AppDimensions.paddingLarge),
            _isCategoriesLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : _visibleCategories.isEmpty
                      ? const Center(
                          child: Text('Aucune catégorie trouvée'),
                        )
                      : _buildCategoryGrid(),

            _buildPaginationControls(),
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
              color: Colors.grey.shade50,
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
          ),
        ),
        const SizedBox(width: AppDimensions.paddingMedium),
        Container(
          decoration: BoxDecoration(
            color: AppColors.cardSurface,
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
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

  Widget _buildCategoryGrid() {
    final categories = _paginatedCategories;
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppDimensions.paddingLarge,
        mainAxisSpacing: AppDimensions.paddingLarge,
        childAspectRatio: 3.5,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        
        return InkWell(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
          onTap: () => Navigator.pushNamed(
            context,
            AppRoutesName.documentPage,
            arguments: {
              "category": category.id,
              "subtitle": category.name
            },
          ),
          child: Container(
            padding: const EdgeInsets.all(AppDimensions.paddingMedium),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
             // color: AppColors.cardSurface,
              borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
            ),
            child:  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              category.documentCount.toString(),
                              style:  TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff212529),
                                //color: AppColors.loginTitleColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              category.name,
                              style:  TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textMainPageColor,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.folder,
                          color: Colors.orange,
                          size: 32,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

          ),
        );
      },
    );
  }

  Widget _buildPaginationControls() {
    final totalItems = _visibleCategories.length;
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

