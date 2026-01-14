import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '/src/presentation/widgets/app_page_shell.dart';
import '/src/presentation/widgets/utils_widget.dart';

import '/src/data/remote/document_api.dart';
import '/src/data/remote/events_api.dart';
import '/src/domain/remote/Document.dart';
import '/src/domain/remote/Event.dart';

import '/src/utils/api/api_url.dart';
import '/src/utils/consts/app_specifications/all_directories.dart';


class DetailsEvenementScreen extends StatefulWidget {
  final String? eventCode;
  final String? eventId;
  const DetailsEvenementScreen({super.key, this.eventCode, this.eventId});

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
    if (widget.eventId== null) return;
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
    await DocumentApi().getDocumentsByCritera(ApiUrl().getDocumentsUrl, null, widget.eventCode).then((value) {
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
      title: "Détail d'un événement",
      whiteColorForMainCardIsHere: false,
      padding: EdgeInsets.zero,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Information générales Section
              _buildGeneralInfoSection(),
              const SizedBox(height: AppDimensions.paddingLarge),
              // Liste des documents Section
              _buildDocumentsSection(),

              const SizedBox(height: AppDimensions.paddingLarge),
              _buildActivityTimeline(),
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
          Divider(),
          const SizedBox(height: AppDimensions.paddingLarge),

          _isEventLoading
              ? const Center(child: CircularProgressIndicator())
              : event == null
                  ? const Text('Chargement...')
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                value: _formatDate(event!.startDate),
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
                              : 'pas de description!',
                          isVertical: true,
                        ),
                      ],
                    ),
        ],
      ),
    );
  }

  Widget _buildActivityTimeline() {
    const activities = [
      _TimelineActivity(
          time: '08:32',
          description: 'Document partagé avec l\'équipe Infinity'),
      //_TimelineActivity(time: '09:12', description: 'Sano  a relu la section 4.2'),
      _TimelineActivity(
          time: '10:45',
          description: 'Commentaire ajouté sur le document'),
      _TimelineActivity(
          time: '11:05', description: 'En attente de validation'),
    ];
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Chronologie d\'activité',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.loginTitleColor,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingMedium),
          ...activities.map(_TimelineTile.new),
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
              fontFamily: "Roboto",
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xff465668),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style:  TextStyle(
              fontFamily: "Chivo",
              fontSize: 16,
              color: Color(0xff212121),
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
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Color(0xff465668),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style:  TextStyle(
            fontSize: 18,
            fontFamily: "Chivo",
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
          const SizedBox(height: AppDimensions.paddingLarge),

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
          const SizedBox(height: AppDimensions.paddingLarge),

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
              color: Color(0xffF9F9F9),
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
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
          ),
      /*decoration: BoxDecoration(
            color: AppColors.cardSurface,
            borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 12,
                offset: const Offset(0, 8),
              ),
            ],
          ),*/
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

        return UtilsWidget().documentGrid(context, document,);

       /* return _buildDocumentCard(
          document: document,
          fileType: fileType,
          fileColor: fileColor,
          fileIcon: fileIcon,
          fileSize: fileSize,
        );*/
      },
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

class _TimelineTile extends StatelessWidget {
  const _TimelineTile(this.activity);

  final _TimelineActivity activity;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.paddingMedium),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: AppColors.mainAppColor,
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                width: 2,
                height: 34,
                color: AppColors.dividerLight,
              ),
            ],
          ),
          const SizedBox(width: AppDimensions.paddingMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.time,
                  style: TextStyle(
                    color: AppColors.textMainPageColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  activity.description,
                  style: TextStyle(
                    color: AppColors.loginTitleColor,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class _TimelineActivity {
  const _TimelineActivity({required this.time, required this.description});

  final String time;
  final String description;
}

