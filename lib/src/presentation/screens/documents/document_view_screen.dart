import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '/src/presentation/widgets/app_page_shell.dart';
import '/src/presentation/widgets/helper.dart';
import '/src/data/remote/document_api.dart';
import '/src/domain/remote/Document.dart';
import '/src/utils/api/api_url.dart';
import '/src/utils/consts/app_specifications/all_directories.dart';


class DocumentViewScreen extends StatelessWidget {
  final Document document;
  const DocumentViewScreen({super.key, required this.document});


  @override
  Widget build(BuildContext context) {
    DateTime dateCreation = DateTime.parse(document.createdAt);
    String formatted = DateFormat("yyyy-MM-dd HH:mm:ss").format(dateCreation);

    final  metadata = [
      Metadata(
          icon: "blue_user",
          bgColor:Color(0xffEFF6FF),
          label: 'Propriétaire',
          value: document.uploadedBy),
      Metadata(
          icon: "green_calendar",
          bgColor:Color(0xff00897B).withOpacity(0.12),
          label: 'Créé le',
          value: formatted),
      Metadata(
          icon: "orange_hour",
          bgColor: Color(0xffF97316).withOpacity(0.12),
          label: 'Dernière mise à jour',
          value: formatted),
      /*_Metadata(
          icon: "orange_hour",

          label: 'Statut',
          value: document.status),*/
    ];
    return AppPageShell(
      isForHomePage: false,
      title: "Détails",
      whiteColorForMainCardIsHere:false,
      child: /*Stack(
        children: [
          _SoftBackground(),*/
         /* SafeArea(
            child: */SingleChildScrollView(
              //padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPreviewCard(context),
                  const SizedBox(height: AppDimensions.paddingLarge),
                /*  _buildActionButtons(),
                  const SizedBox(height: AppDimensions.paddingLarge),
                 */ _buildDescriptionSection(),
                  const SizedBox(height: AppDimensions.paddingLarge),
                  _buildMetadataSection(metadata),
                  const SizedBox(height: AppDimensions.paddingLarge),
                  _buildActivityTimeline(),
                ],
              ),
           // ),
          ),

    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingLarge,
        vertical: AppDimensions.paddingMedium,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: AppColors.mainAppColor),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.bookmark_border_rounded),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_horiz_rounded),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewCard(BuildContext context) {
    List<_ActionButtonData> actions = [
      _ActionButtonData(Icons.share_rounded, 'Partager',Colors.white,(){}),
      _ActionButtonData(Icons.download_rounded, 'Télécharger',Color(0xff7DAA40),(){DocumentApi().voirDocuments(ApiUrl().voirDocumentUrl,document.fileName);}),
      _ActionButtonData(Icons.print_rounded, 'Imprimer',Color(0xff305A9D),(){}),
    ];
   // index == quickStats.length - 1 ? 0

    final fileType = Helper().getFileExtension(document.mimeType, document.fileName);
    final fileColor = Helper().getFileTypeColor(fileType);
    final fileIcon = Helper().getFileTypeIcon(fileType);
    final fileSize = Helper().formatFileSize(document.fileName);


    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SvgPicture.asset("asset/images/$fileIcon.svg"),
              const SizedBox(width: AppDimensions.paddingMedium),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 200,
                    child: Text(document.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Color(0xff212529),
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'PDF • 12,8 Mo • 38 pages',
                    //'PDF • 12,8 Mo • 38 pages',
                    style: TextStyle(color: Color(0xff979797)),
                  ),
                  const SizedBox(height: AppDimensions.paddingMedium),
                  /*Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: const [
                    _InfoChip(
                        icon: Icons.lock_open_rounded,
                        label: 'Partagé avec le service juridique'),
                    _InfoChip(
                        icon: Icons.history_toggle_off, label: 'Version 12.3'),
                    _InfoChip(
                        icon: Icons.cloud_done_rounded,
                        label: 'Synchronisé au cloud'),
                  ],
                ),*/
                ],
              ),
            ],
          ),

          Row(
              spacing: 10,
              children: [
                ElevatedButton.icon(
                      onPressed:(){DocumentApi().voirDocuments(ApiUrl().voirDocumentUrl,document.fileName);},
                      icon: SvgPicture.asset("asset/images/eye.svg"),
                      label: Text("Visualiser"),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12,horizontal: AppDimensions.paddingMedium),
                        backgroundColor: AppColors.cardSurface,
                        foregroundColor: AppColors.loginTitleColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium),
                        ),
                        side: BorderSide(color:Color(0xffD0D5DD))
                      ),
                    ),
                ElevatedButton.icon(
                      onPressed:(){archivageDocPopUp(context,document.id);},
                      icon: SvgPicture.asset("asset/images/archive.svg"),
                      label: Text("Archiver",style: TextStyle(fontSize: 15,fontFamily: "Chivo",color: Colors.white),),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12,horizontal: AppDimensions.paddingMedium),
                        backgroundColor: Color(0xff7DAA40),
                        foregroundColor: AppColors.loginTitleColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(AppDimensions.borderRadiusMedium),
                        ),
                      ),
                    ),
                ElevatedButton.icon(
                      onPressed:(){DocumentApi().voirDocuments(ApiUrl().voirDocumentUrl,document.fileName);},
                      icon: SvgPicture.asset("asset/images/download.svg"),
                      label: Text("Télécharger",style: TextStyle(fontSize: 15,fontFamily: "Chivo",color: Colors.white),),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12,horizontal: AppDimensions.paddingMedium),
                        backgroundColor: Color(0xff305A9D),
                        foregroundColor: AppColors.loginTitleColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(AppDimensions.borderRadiusMedium),
                        ),
                      ),
                    ),
              ],
            ),

        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    List<_ActionButtonData> actions = [
      _ActionButtonData(Icons.share_rounded, 'Partager',Colors.white,(){}),
      _ActionButtonData(Icons.download_rounded, 'Télécharger',Color(0xff7DAA40),(){DocumentApi().voirDocuments(ApiUrl().voirDocumentUrl,document.fileName);}),
      _ActionButtonData(Icons.print_rounded, 'Imprimer',Color(0xff305A9D),(){}),
    ];
    return Row(
      children: [

      ]
    );
  }

  Widget _buildMetadataSection(_metadata) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Détails du document',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.loginTitleColor,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingMedium),
          ..._metadata.map(
            (item) => Padding(
              padding:
                  const EdgeInsets.only(bottom: AppDimensions.paddingMedium,),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: item.bgColor,
                      //color: AppColors.mainAppColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SvgPicture.asset("asset/images/${item.icon}.svg"),

                   // Icon(item.icon, color: AppColors.mainAppColor, size: 20),
                  ),
                  const SizedBox(width: AppDimensions.paddingLarge),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.label,
                          style: TextStyle(
                            color: AppColors.textMainPageColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          item.value,
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
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildDescriptionSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),

      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.loginTitleColor,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingMedium),

          Text(document.description,
            style: TextStyle(
              color: AppColors.textMainPageColor,
              fontWeight: FontWeight.w600,
            ),
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

  void archivageDocPopUp(BuildContext context, String idDocument) {
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text('Déconnexion'),
            content: const Text(
              'Êtes-vous sûr de vouloir vous déconnecter ?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('Annuler'),
              ),
              ElevatedButton(
                onPressed: () {
                  DocumentApi().archiverDocument(ApiUrl().archiverDocumentUrl,idDocument,context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mainRedColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Archiver'),
              ),
            ],
          );
        },
      );
    }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMedium,
        vertical: AppDimensions.paddingSmall / 1.5,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _SoftBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: -80,
            right: -40,
            child: _blurCircle(200, AppColors.secondAppColor.withOpacity(0.12)),
          ),
          Positioned(
            bottom: -50,
            left: -30,
            child: _blurCircle(240, AppColors.accentPurple.withOpacity(0.08)),
          ),
        ],
      ),
    );
  }

  Widget _blurCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
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

class Metadata {
  const Metadata( {

    required this.icon,
    required this.bgColor,
    required this.label,
    required this.value,
  });

  final String icon;
  final Color bgColor;
  final String label;
  final String value;
}

class _ActionButtonData {
  const _ActionButtonData(this.icon, this.label, this.color, this.action);

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback action;
}

class _TimelineActivity {
  const _TimelineActivity({required this.time, required this.description});

  final String time;
  final String description;
}
