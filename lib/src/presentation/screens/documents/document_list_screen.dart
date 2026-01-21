
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';

import '/src/data/remote/document_api.dart';
import '/src/domain/remote/Document.dart';
import '/src/presentation/widgets/app_page_shell.dart';
import '/src/presentation/widgets/helper.dart';
import '/src/presentation/widgets/search_and_filter.dart';

import '/src/utils/api/api_url.dart';
import '/src/utils/consts/app_specifications/all_directories.dart';
import '/src/utils/consts/routes/app_routes_name.dart';


class DocumentListScreen extends StatefulWidget {
  final String? category;
  final String? eventCode;
  final String subtitle;
  const DocumentListScreen({super.key, this.category, this.eventCode, required this.subtitle});

  @override
  State<DocumentListScreen> createState() => _DocumentListScreenState();
}

class _DocumentListScreenState extends State<DocumentListScreen> {

  final TextEditingController _searchController = TextEditingController();
  List<Document> documentsGetted = [];
  List<Document> documentsFiltered = [];
  bool _isDocumentsLoading=false;

  // Pagination state
  int _currentPage = 1;
  int _itemsPerPage = 10;
  final List<int> _itemsPerPageOptions = [10, 20, 30, 50];

  @override
  void initState() {
    getDocs();
    super.initState();
  }

  getDocs() async {
    await DocumentApi().getDocumentsByCritera( ApiUrl().getDocumentsUrl, widget.category,widget.eventCode).then((value) {
      setState(() {
        documentsGetted = value;
        documentsFiltered = documentsGetted;
        _isDocumentsLoading=false;
      });
    }).catchError((error) {
      setState(() {
        _isDocumentsLoading=false;
      });
    });
  }

  List<Document> get _visibleDocs {
    return documentsGetted.where((document) {
      final bool matchesSearch = document.title
          .toLowerCase()
          .contains(_searchController.text.toLowerCase());

      return matchesSearch ;
    }).toList();
  }


  List<Document> get _paginatedDocs {
    final filtered = _visibleDocs;
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;
    return filtered.length > startIndex
        ? filtered.sublist(
      startIndex,
      endIndex > filtered.length ? filtered.length : endIndex,
    )
        : [];
  }

  @override
  Widget build(BuildContext context) {
    return  AppPageShell(
      isForHomePage: false,
      title: "Gestion des documents",
      subtitle: widget.subtitle,
      whiteColorForMainCardIsHere:true,
      /*actions: [
        GestureDetector(
          onTap: () {Navigator.of(context).pushNamed(AppRoutesName.addDocumentPage);},
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
                  "Ajouter un document",
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
       // floatingActionButton: _buildFloatingActionButton(),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

             // _buildSearchAndFilter(),
              SearchAndFilter(
                  searchController: _searchController,
                  onChangeFunction: (_)=> setState(() {_currentPage = 1;}),
                  text: 'Rechercher un fichier....',
                  isExpanded: true
              ),

              const SizedBox(height: AppDimensions.paddingLarge),

              _isDocumentsLoading?
                  CircularProgressIndicator()
              :
              _visibleDocs.isEmpty?

              Text('La liste est vide !')
                  :
              _buildDocumentsGrid(),
              //child:  _buildDocumentList(_visibleDocs),
              const SizedBox(height: AppDimensions.paddingLarge),

              _buildPaginationControls(),

            ],
          ),
        ),
      );
  }

  Widget _buildDocumentsGrid() {
    final documents = _paginatedDocs.reversed;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppDimensions.paddingMedium,
        mainAxisSpacing: AppDimensions.paddingMedium,
        childAspectRatio:4.3,
      ),
      itemCount: documents.length,
      itemBuilder: (context, index) {
        final document = documents.elementAt(index);

        final fileType = Helper().getFileExtension(document.mimeType, document.fileName);
        final fileColor = Helper().getFileTypeColor(fileType);
        final fileIcon = Helper().getFileTypeIcon(fileType);
        final fileSize = Helper().formatFileSize(document.fileName);

        return _buildDocumentCard(context,
          document: document,
          fileType: fileType,
          fileColor: fileColor,
          fileIcon: fileIcon,
          fileSize: fileSize,
        );
      },
    );
  }

  Widget _buildDocumentCard(BuildContext context, {
    required Document document,
    required String fileType,
    required Color fileColor,
    required String fileIcon,
    required String fileSize,
  }) {
    final fileType = Helper().getFileExtension(document.mimeType, document.fileName);
    final fileColor = Helper().getFileTypeColor(fileType);
    final fileIcon = Helper().getFileTypeIcon(fileType);
    final fileSize = Helper().formatFileSize(document.fileName);
    final fileTypeText = Helper().getFileTypeText(fileType);

    return InkWell(
      onTap: () => Navigator.pushNamed(context, AppRoutesName.viewDocumentPage, arguments: {"document": document},),
     // borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.cardBorderColor),
          color: AppColors.cardSurface,
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),

        ),
        child: Row(
          children: [
            SvgPicture.asset("asset/images/$fileIcon.svg"),
            SizedBox(width: 10,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    document.title,
                    overflow: TextOverflow.ellipsis,
                    style:  TextStyle(
                      fontFamily: "Roboto",
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff212529),
                      /*fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.loginTitleColor,*/
                    ),
                    //maxLines: 2,

                  ),
                  Row(
                    spacing: 8,
                    children: [
                      Text(fileType,
                        style: TextStyle(
                          fontFamily: "Roboto",
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Color(0xff979797),
                        ),
                      ),

                      SvgPicture.asset("asset/images/dots.svg"),

                      Text(fileSize,
                        style: TextStyle(
                          fontFamily: "Roboto",
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Color(0xff979797),
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            ),

            Container(
              width: 40,
              padding: const EdgeInsets.all(4.5),
             // padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color:fileColor.withOpacity(0.1),
                border: Border.all(color: fileColor),
                borderRadius: BorderRadius.circular(AppDimensions.borderRadiusSmall),

              ),
              child: Text(
                fileTypeText,
                textAlign: TextAlign.center,
                style:  TextStyle(
                  fontSize: 10,
                 // fontWeight: FontWeight.w600,
                  color: fileColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaginationControls() {
    final totalItems = _visibleDocs.length;
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
                onPressed: _currentPage < ((totalItems / _itemsPerPage).ceil())
                    ? () {
                  setState(() {
                    _currentPage++;
                  });
                }
                    : null,
                icon: const Icon(Icons.arrow_forward_ios, size: 16),
                color: _currentPage < ((totalItems / _itemsPerPage).ceil())
                    ? AppColors.mainAppColor
                    : Colors.grey,
              ),
            ],
          ),
        ],
      ),
    );
  }

}




