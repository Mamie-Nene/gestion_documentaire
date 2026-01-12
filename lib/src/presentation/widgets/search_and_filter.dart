
import 'package:flutter/material.dart';

import '/src/utils/consts/app_specifications/all_directories.dart';

class SearchAndFilter extends StatelessWidget {
  final TextEditingController searchController;
  final ValueChanged<String>? onChangeFunction;
  final String text;
  final bool isExpanded ;
   SearchAndFilter({super.key, required this.searchController, required this.onChangeFunction, required this.text, required this.isExpanded });

  @override
  Widget build(BuildContext context) {
    final searchBox = Container(
      width: isExpanded ? null : 300,
      decoration: BoxDecoration(
        color: AppColors.searchBgColor,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
      ),
      child: TextField(
        controller: searchController,
        onChanged: onChangeFunction,
        decoration: InputDecoration(
          hintText: text,
          prefixIcon: const Icon(Icons.search_rounded, color: Colors.black54),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            vertical: AppDimensions.paddingMedium,
            horizontal: AppDimensions.paddingMedium,
          ),
        ),
      ),
    );

    return  Row(
        children: [
        isExpanded ? Expanded(child: searchBox) : searchBox,
           /*Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xffF9F9F9),
                borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
              ),
              child: TextField(
                controller: searchController,
                onChanged: onChangeFunction,
                decoration:  InputDecoration(
                  hintText: text,
                  prefixIcon: Icon(Icons.search_rounded, color: Colors.black54),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: AppDimensions.paddingMedium,
                    horizontal: AppDimensions.paddingMedium,
                  ),
                ),
              ),
            ),
          ),*/
          const SizedBox(width: AppDimensions.paddingMedium),
          Container(
            decoration: BoxDecoration(
              color: AppColors.cardSurface,
              border: Border.all(color: Color(0xffD0D5DD)),
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
}
