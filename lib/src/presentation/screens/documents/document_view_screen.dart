import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/src/utils/consts/routes/app_routes_name.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';

import '/src/presentation/widgets/app_page_shell.dart';
import '/src/presentation/widgets/helper.dart';
import '/src/data/remote/document_api.dart';
import '/src/domain/remote/Document.dart';

import '/src/utils/api/api_url.dart';
import '/src/utils/consts/app_specifications/all_directories.dart';


class DocumentViewScreen extends StatefulWidget {
  final Document document;
  const DocumentViewScreen({super.key, required this.document});

  @override
  State<DocumentViewScreen> createState() => _DocumentViewScreenState();
}

class _DocumentViewScreenState extends State<DocumentViewScreen> {
  //faceId or fingerPRINT CHECK
  final LocalAuthentication auth = LocalAuthentication();


  Future<bool> authenticateAvant() async {
    try {
      final canCheck = await auth.canCheckBiometrics;
      final isSupported = await auth.isDeviceSupported();

      debugPrint("canCheckBiometrics: $canCheck");
      debugPrint("isDeviceSupported: $isSupported");


      if (!canCheck || !isSupported) return false;
      return await auth.authenticate(
        localizedReason: 'Authentifiez-vous pour lire ce document!',
        options: const AuthenticationOptions(
          biometricOnly:false, //pour enlever les blocages sur tablettes
         // biometricOnly: true,
          stickyAuth: true,
        ),
      );

    }on PlatformException catch (e) {
      print(e.code); // très important
      return false;
    }//handshake exception
    catch (e) {
      debugPrint("Biometric error: $e");
      return false;
    }
  }
  Future<bool> authenticate() async {
    try {
      final canCheck = await auth.canCheckBiometrics;
      final isSupported = await auth.isDeviceSupported();

      debugPrint("canCheckBiometrics: $canCheck");
      debugPrint("isDeviceSupported: $isSupported");

      // 🔹 Cas tablette / device sans biométrie
      if (!isSupported) {
        return await _authenticateWithDeviceCredential();
      }

      // 🔹 Biométrie dispo → on tente
      if (canCheck) {
        final authenticated = await auth.authenticate(
          localizedReason: 'Authentifiez-vous pour lire ce document',
          options: const AuthenticationOptions(
            biometricOnly: false, // IMPORTANT pour tablettes
            stickyAuth: true,
          ),
        );

        if (authenticated) return true;
      }

      // 🔹 Biométrie échouée → fallback
      return await _authenticateWithDeviceCredential();

    } on PlatformException catch (e) {
      debugPrint("Biometric error code: ${e.code}");

      // 🔹 Tous ces cas doivent fallback
      if ([
        'NotAvailable',
        'NotEnrolled',
        'LockedOut',
        'PermanentlyLockedOut',
      ].contains(e.code)) {
        return await _authenticateWithDeviceCredential();
      }

      return false;

    } catch (e) {
      debugPrint("Biometric error: $e");
      return false;
    }
  }

  Future<bool> _authenticateWithDeviceCredential() async {
    try {
      return await auth.authenticate(
        localizedReason: 'Entrez votre code pour continuer',
        options: const AuthenticationOptions(
          biometricOnly: false, // ⚠️ OBLIGATOIRE
          stickyAuth: true,
        ),
      );
    } catch (e) {
      debugPrint("Device credential error: $e");
      return false;
    }
  }



  @override
  Widget build(BuildContext context) {
    DateTime dateCreation = DateTime.parse(widget.document.createdAt);
    String formatted = DateFormat("yyyy-MM-dd HH:mm:ss").format(dateCreation);

    final  metadata = [
      Metadata(
          icon: "blue_user",
          bgColor:Color(0xffEFF6FF),
          label: 'Uploader par',
          value: widget.document.uploadedBy),
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
      Metadata(
          icon: "Frame-7",
          label: 'Statut',
          value: widget.document.status,
          bgColor: Colors.red.withOpacity(0.12)),
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

                 /* TextButton(onPressed: (){
                    Navigator.of(context).push(
                    MaterialPageRoute(builder: (context)=>RecentDocumentListScreen())
                  );}, child: Text('test'))*/
                ],
              ),
           // ),
          ),

    );

  }

  Widget _buildPreviewCard(BuildContext context) {
    List<_ActionButtonData> actions = [
      _ActionButtonData(Icons.share_rounded, 'Partager',Colors.white,(){}),
      _ActionButtonData(Icons.download_rounded, 'Télécharger',Color(0xff7DAA40),(){DocumentApi().voirDocuments(ApiUrl().voirDocumentUrl,widget.document.fileName);}),
      _ActionButtonData(Icons.print_rounded, 'Imprimer',Color(0xff305A9D),(){}),
    ];
   // index == quickStats.length - 1 ? 0

    final fileType = Helper().getFileExtension(widget.document.mimeType, widget.document.fileName);
    final fileColor = Helper().getFileTypeColor(fileType);
    final fileIcon = Helper().getFileTypeIcon(fileType);
    final fileSize = Helper().formatFileSize(widget.document.fileName);


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
                    child: Text(widget.document.title,
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
                  onPressed: () async {
                        //DocumentApi().voirDocuments(ApiUrl().voirDocumentUrl,widget.document.fileName);

                    /*final isAuth = await authenticate();
                    if (!isAuth) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Authentification échouée")),
                      );
                      return;
                    }*/

                    Navigator.of(context).pushNamed(AppRoutesName.openSecureDocPage,
                        arguments: {"fileName": widget.document.fileName}
                    );

                  },
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
                      onPressed:(){archivageDocPopUp(context,widget.document.id);},
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
                      onPressed:(){DocumentApi().voirDocuments(ApiUrl().voirDocumentUrl,widget.document.fileName);},
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
      _ActionButtonData(Icons.download_rounded, 'Télécharger',Color(0xff7DAA40),(){DocumentApi().voirDocuments(ApiUrl().voirDocumentUrl,widget.document.fileName);}),
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

          Text(widget.document.description,
            style: TextStyle(
              color: AppColors.textMainPageColor,
              fontWeight: FontWeight.w600,
            ),
          ),

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
            title: const Text('Archivage'),
            content: const Text(
              'Êtes-vous sûr de vouloir archiver le document?',
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

