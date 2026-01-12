import 'package:flutter/material.dart';

import '/src/data/remote/auth_api.dart';
import '/src/domain/remote/UserInfo.dart';
import '/src/methods/signout.dart';

import '/src/presentation/widgets/app_page_shell.dart';
import '/src/utils/api/api_url.dart';
import '/src/utils/consts/app_specifications/all_directories.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserInfo? userInfo;
  bool _infoLoader = true;

  getInfoUser() async {
    await AuthApi().getUserInfo(ApiUrl().getUserInfoUrl).then((value) {
      setState(() {
        userInfo = value;
        _infoLoader = false;
      });
    }).catchError((error) {
      setState(() {
        _infoLoader = false;
      });
    });
  }

  @override
  void initState() {
    getInfoUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppPageShell(
      isForHomePage: false,
      title: "Mon compte",
      padding: EdgeInsets.zero,
        whiteColorForMainCardIsHere:false,
      child: _infoLoader
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : userInfo == null
              ? const Center(
                  child: Text("Une erreur est survenue"),
                )
              : SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                        children: [
                          // Profile Card - Full width
                          Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(AppDimensions.paddingLarge),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                children: [
                                  // Profile Picture
                                  CircleAvatar(
                                    radius: 50,
                                    backgroundColor: AppColors.mainBackgroundColor,
                                    foregroundImage: AssetImage(AppImages.PROFIL_IMAGES),
                                  ),
                                  const SizedBox(height: AppDimensions.paddingMedium),
                                  // Name
                                  Text(
                                    '${userInfo!.firstName} ${userInfo!.lastName}',
                                    style:  TextStyle(
                                      fontFamily: "Roboto",
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff030319),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  // Email
                                  Text(
                                    userInfo!.email,
                                    style:  TextStyle(
                                      fontFamily: "Roboto",
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color:Color(0xff757575),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          const SizedBox(height: AppDimensions.paddingMedium),
                          // Account Settings Section
                           Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                 Text(
                                  'Paramètres du compte',
                                  style: TextStyle(
                                    fontFamily: "Roboto",
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff292D32),
                                  ),
                                ),
                                const SizedBox(height: AppDimensions.paddingMedium),
                                // Settings Grid
                                _buildSettingsGrid(),
                                const SizedBox(height: AppDimensions.paddingLarge * 2),
                                // Logout Button
                                _buildLogoutButton(),
                                const SizedBox(height: AppDimensions.paddingLarge),
                              ],
                            ),

                        ],
                      ),
                  ),
                ),
    );
  }

  Widget _buildSettingsGrid() {
    final settings = [
      {
        'title': 'Informations personnelles',
        'subtitle': 'Modifier votre profil et vos coordonnées',
        'icon': Icons.person_outline,
        'color': const Color(0xFF9C6EF3),
      },
      /*{
        'title': 'Sécurité et connexion',
        'subtitle': 'Mot de passe et authentification',
        'icon': Icons.shield_outlined,
        'color': const Color(0xFF6B46C1),
      },*/
      {
        'title': 'Notifications',
        'subtitle': 'Gérer vos préférences d\'alertes',
        'icon': Icons.notifications_outlined,
        'color': const Color(0xFF9C6EF3),
      },
     /* {
        'title': 'Moyens de paiement',
        'subtitle': 'Cartes enregistrées et historique',
        'icon': Icons.credit_card_outlined,
        'color': const Color(0xFF10B981),
      },
      {
        'title': 'Préférences',
        'subtitle': 'Langue, thème et affichage',
        'icon': Icons.settings_outlined,
        'color': Colors.orange,
      },
      {
        'title': 'Aide et support',
        'subtitle': 'FAQ et contact service client',
        'icon': Icons.help_outline,
        'color': const Color(0xFF3B82F6),
      },*/
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppDimensions.paddingMedium,
        mainAxisSpacing: AppDimensions.paddingMedium,
        childAspectRatio: 4.6,
      ),
      itemCount: settings.length,
      itemBuilder: (context, index) {
        final setting = settings[index];
        return _buildSettingCard(
          title: setting['title'] as String,
          subtitle: setting['subtitle'] as String,
          icon: setting['icon'] as IconData,
          color: setting['color'] as Color,
        );
      },
    );
  }

  Widget _buildSettingCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return InkWell(
      onTap: () {
        // TODO: Navigate to setting page
      },
      borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.paddingMedium),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      icon,
                      color: color,
                      size: 20,
                    ),
                  ),
              SizedBox(width: 15,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [

                  const SizedBox(height: AppDimensions.paddingSmall),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.loginTitleColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.textMainPageColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),

              const Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                size: 12,
                color: AppColors.textMainPageColor.withOpacity(0.5),
              ),
            ],
          ),
        ),
    );
  }
  void _showLogoutDialog(BuildContext context) {
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
                Navigator.of(dialogContext).pop();
                SignOutMethod().signOut(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mainRedColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Déconnexion'),
            ),
          ],
        );
      },
    );
  }
  Widget _buildLogoutButton() {
    return InkWell(
      onTap: () {
        _showLogoutDialog(context);
      },
      borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppDimensions.paddingMedium),
          decoration: BoxDecoration(
            border: Border.all(color:Color(0xFFDC2626) ),
            color: const Color(0xFFDC2626).withOpacity(0.1), // Dark red color
            borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
          ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color(0xFFDC2626),
               // color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.logout,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: AppDimensions.paddingMedium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Déconnexion',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFDC2626),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Se déconnecter de votre compte en toute sécurité',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFFDC2626).withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
