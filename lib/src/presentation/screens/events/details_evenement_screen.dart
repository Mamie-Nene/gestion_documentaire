import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gestion_documentaire/src/presentation/widgets/app_page_shell.dart';
import 'package:intl/intl.dart';
import '/src/data/remote/document_api.dart';
import '/src/data/remote/events_api.dart';
import '/src/domain/remote/Document.dart';
import '/src/domain/remote/Event.dart';
import '/src/utils/api/api_url.dart';
import '/src/utils/consts/app_specifications/all_directories.dart';
import '/src/utils/consts/routes/app_routes_name.dart';

class DetailsEvenementScreen extends StatefulWidget {
  final String? eventId;
  const DetailsEvenementScreen({super.key, this.eventId});

  @override
  State<DetailsEvenementScreen> createState() => _DetailsEvenementScreenState();
}

class _DetailsEvenementScreenState extends State<DetailsEvenementScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Document> documentsGetted = [];
  Event? event;
  bool _isDocumentsLoading = false;
  bool _isEventLoading = false;

  // Pagination state
  int _currentPage = 1;
  int _itemsPerPage = 10;
  final List<int> _itemsPerPageOptions = [10, 20, 30, 50];

  @override
  void initState() {
    super.initState();
    getEventDetails();
    getDocs();
  }

  getEventDetails() async {
    if (widget.eventId == null) return;
    setState(() {
      _isEventLoading = true;
    });
    await EventsApi().getDetailEvent(ApiUrl().getEventsUrl, widget.eventId!).then((value) {
      setState(() {
        event = value;
        _isEventLoading = false;
      });
    }).catchError((error) {
      setState(() {
        _isEventLoading = false;
      });
    });
  }

  getDocs() async {
    setState(() {
      _isDocumentsLoading = true;
    });
    await DocumentApi().getDocumentsByCritera(ApiUrl().getDocumentsUrl, null, widget.eventId).then((value) {
      setState(() {
        documentsGetted = value ?? [];
        _isDocumentsLoading = false;
      });
    }).catchError((error) {
      setState(() {
        _isDocumentsLoading = false;
      });
    });
  }

  List<Document> get _visibleDocs {
    return documentsGetted.where((document) {
      final bool matchesSearch = document.title
          .toLowerCase()
          .contains(_searchController.text.toLowerCase());
      return matchesSearch;
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

  String _formatFileSize(String? fileName) {
    // Mock file size for now
    return '2.4MB';
  }

  String _getFileExtension(String? mimeType, String? fileName) {
    if (mimeType?.contains('pdf') ?? false) return 'PDF';
    if (mimeType?.contains('word') ?? false || mimeType!.contains('document') ?? false) return 'DOCX';
    if (mimeType?.contains('excel') ?? false || mimeType!.contains('spreadsheet') ?? false) return 'XLSX';
    if (mimeType?.contains('powerpoint') ?? false || mimeType!.contains('presentation') ?? false) return 'PPTX';
    return 'DOCX';
  }

  Color _getFileTypeColor(String fileType) {
    switch (fileType.toUpperCase()) {
      case 'PDF':
        return Colors.red;
      case 'DOCX':
        return Colors.blue;
      case 'XLSX':
        return Colors.green;
      case 'PPTX':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _getFileTypeIcon(String fileType) {
    switch (fileType.toUpperCase()) {
      case 'PDF':
        return 'P';
      case 'DOCX':
        return 'W';
      case 'XLSX':
        return 'X';
      case 'PPTX':
        return 'P';
      default:
        return 'D';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppPageShell(
        isForHomePage: false,
      title: "Detail d'un évenement",
      whiteColorForMainCardIsHere: false,
      padding: EdgeInsets.zero,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingLarge,
                  vertical: AppDimensions.paddingMedium,
                ),
              child: Column(
                children: [
                    // Information générales Section
                    _buildGeneralInfoSection(),
                    const SizedBox(height: AppDimensions.paddingLarge),
                    // Liste des documents Section
                    _buildDocumentsSection(),

                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGeneralInfoSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text(
            'Information générales',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.loginTitleColor,
            ),
           ),
          const SizedBox(height: AppDimensions.paddingLarge),
          _isEventLoading
              ? const Center(child: CircularProgressIndicator())
              : event == null
                  ? const Text('Chargement...')
                  : Column(
                      children: [
                        // Libellé, Comité, Date Grid
                        Row(
                          children: [
                            Expanded(
                              child: _buildInfoItem(
                                label: 'Libellé',
                                value: event!.title,
                              ),
                            ),
                            const SizedBox(width: AppDimensions.paddingMedium),
                            Expanded(
                              child: _buildInfoItem(
                                label: 'Comité',
                                value: 'Design', // TODO: Get from event data
                              ),
                            ),
                            const SizedBox(width: AppDimensions.paddingMedium),
                            Expanded(
                              child: _buildInfoItem(
                                label: 'Date',
                                value: _formatDate(event!.eventDate),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppDimensions.paddingLarge),
                        // Description
                        _buildInfoItem(
                          label: 'Description',
                          value: event!.description.isNotEmpty
                              ? event!.description
                              : 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled.',
                          isVertical: true,
                        ),
                      ],
                    ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required String label,
    required String value,
    bool isVertical = false,
  }) {
    if (isVertical) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style:  TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textMainPageColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style:  TextStyle(
              fontSize: 14,
              color: AppColors.loginTitleColor,
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style:  TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textMainPageColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style:  TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.loginTitleColor,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }

  Widget _buildDocumentsSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Row(
             spacing: 30,
             children: [
               Text(
                'Liste des documents',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.loginTitleColor,
                ),
               ),

               Expanded(child: _buildSearchAndFilter()),
             ],
           ),
          const SizedBox(height: AppDimensions.paddingLarge),

         Divider(thickness: 0.5,),
         _isDocumentsLoading
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(),
                  ),
                )
              : _visibleDocs.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text('Aucun document trouvé'),
                      ),
                    )
                  : _buildDocumentsGrid(),

          _buildPaginationControls(),
        ],
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
             /* boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 8),
                ),
              ],*/
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

  Widget _buildDocumentsGrid() {
    final documents = _paginatedDocs;

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
        final document = documents[index];
        final fileType = _getFileExtension(document.mimeType, document.fileName);
        final fileColor = _getFileTypeColor(fileType);
        final fileIcon = _getFileTypeIcon(fileType);
        final fileSize = _formatFileSize(document.fileName);

        return _buildDocumentCard(
          document: document,
          fileType: fileType,
          fileColor: fileColor,
          fileIcon: fileIcon,
          fileSize: fileSize,
        );
      },
    );
  }

  Widget _buildDocumentCard({
        required Document document,
    required String fileType,
    required Color fileColor,
    required String fileIcon,
    required String fileSize,
  }) {
    return InkWell(
      onTap: () => Navigator.pushNamed(
        context,
        AppRoutesName.viewDocumentPage,
        arguments: {"document": document},
      ),
      borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xffDEE8EE)),
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),

        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset("asset/images/pdf.svg"),
            const SizedBox(height: AppDimensions.paddingMedium),
            Column(
              children: [
                Text(
                  document.title,
                  style:  TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.loginTitleColor,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '$fileType • $fileSize',
                  style:  TextStyle(
                    fontSize: 11,
                    color: AppColors.textMainPageColor,
                  ),
                ),
              ],
            ),

            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: fileColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                fileType,
                style:  TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
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
