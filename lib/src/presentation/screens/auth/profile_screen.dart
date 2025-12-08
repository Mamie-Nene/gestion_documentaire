import 'package:flutter/material.dart';
import 'package:gestion_documentaire/src/data/remote/auth_api.dart';
import 'package:gestion_documentaire/src/domain/remote/UserInfo.dart';
import 'package:gestion_documentaire/src/methods/signout.dart';
import 'package:gestion_documentaire/src/utils/api/api_url.dart';
import '/src/utils/consts/app_specifications/all_directories.dart';
import '/src/utils/consts/routes/app_routes_name.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

 UserInfo? userInfo;
 bool _infoLoader= true;


  getInfoUser() async {
    await AuthApi().getUserInfo( ApiUrl().getUserInfoUrl).then((value) {
      setState(() {
        userInfo = value;
        _infoLoader=false;
      });
    }).catchError((error) {
      setState(() {
        _infoLoader=false;
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
    return Scaffold(
      backgroundColor: AppColors.mainBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.mainAppColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Profil',
          style: TextStyle(
            color: AppColors.loginTitleColor,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit_outlined, color: AppColors.mainAppColor),
            onPressed: () {
              // TODO: Implement edit functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child:
        _infoLoader?
           Center(child: CircularProgressIndicator())
        :
            userInfo == null
            ? Center(child:Text("Une erreur est survenue"))
            :
          Column(
          children: [
            // Profile Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppDimensions.paddingLarge),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.mainBackgroundColor,
                    foregroundImage: AssetImage(AppImages.PROFIL_IMAGES),
                  ),
                  const SizedBox(height: AppDimensions.paddingMedium),
                  Text(
                    '${userInfo!.firstName} ${userInfo!.lastName}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: AppColors.loginTitleColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(userInfo!.email,
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.textMainPageColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.paddingLarge),
            // User Information
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingLarge,
              ),
              child: Column(
                children: [
                  _buildInfoCard(
                    icon: Icons.person_outline_rounded,
                    label: 'Nom complet',
                    value: '${userInfo!.firstName} ${userInfo!.lastName}',
                  ),
                  const SizedBox(height: AppDimensions.paddingMedium),
                  _buildInfoCard(
                    icon: Icons.email_outlined,
                    label: 'Email',
                    value: userInfo!.email,
                  ),
                  const SizedBox(height: AppDimensions.paddingMedium),
                  _buildInfoCard(
                    icon: Icons.phone_outlined,
                    label: 'Profil',
                    value: userInfo!.role,
                  ),
                  const SizedBox(height: AppDimensions.paddingLarge * 2),
                  // Logout button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        SignOutMethod().signOut(context);
                        /*Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRoutesName.loginPage,
                          (route) => false,
                        );*/
                      },
                      icon: Icon(Icons.logout, color: AppColors.mainRedColor),
                      label: Text(
                        'Déconnexion',
                        style: TextStyle(
                          color: AppColors.mainRedColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppDimensions.paddingMedium,
                        ),
                        side: BorderSide(color: AppColors.mainRedColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppDimensions.borderRadiusLarge,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingLarge),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
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
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.mainAppColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: AppColors.mainAppColor,
              size: 24,
            ),
          ),
          const SizedBox(width: AppDimensions.paddingMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textMainPageColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.loginTitleColor,
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
