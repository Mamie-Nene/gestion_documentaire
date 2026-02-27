import 'package:flutter/material.dart';
import 'package:gestion_documentaire/src/data/remote/auth_api.dart';
import 'package:gestion_documentaire/src/domain/remote/UserInfo.dart';
import 'package:gestion_documentaire/src/utils/api/api_url.dart';
import '/core/theme/app_colors.dart';

class UserProfileDataClass {
  final String userName;
  final String userRole;
  final String userEmail;
  final String userInitials;

  const UserProfileDataClass({
    required this.userName,
    required this.userRole,
    required this.userEmail,
    required this.userInitials,
  });
}

class UserProfilePage extends StatefulWidget {
  UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  UserInfo? userInfo;
  bool _infoLoader = true;

  final UserProfileDataClass userProfileDataClass = const UserProfileDataClass(
    userName: 'Mamie',
    userRole: 'Admin',
    userEmail: 'mnba@gmail.com',
    userInitials: 'MNB',
  );

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
    return Scaffold(
      backgroundColor: AppColors.background,

      body: _infoLoader
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : userInfo == null
          ? const Center(
        child: Text("Une erreur est survenue"),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 24),
            _buildUserInfoCard(),
            const SizedBox(height: 24),
            _buildInstanceGroupCard(context),
            const SizedBox(height: 24),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: AppColors.primary.withOpacity(0.1),
          child: Text(
            userProfileDataClass.userInitials,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          '${userInfo!.firstName} ${userInfo!.lastName}',
         // userProfileDataClass.userName,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.foreground,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          userProfileDataClass.userRole,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.mutedForeground,
          ),
        ),
      ],
    );
  }

  Widget _buildUserInfoCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: AppColors.card,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _infoRow('Nom', userProfileDataClass.userName),
            const Divider(color: AppColors.border),
            _infoRow('Email', userProfileDataClass.userEmail),
            const Divider(color: AppColors.border),
            _infoRow('Rôle', userProfileDataClass.userRole),
          ],
        ),
      ),
    );
  }

  Widget _buildInstanceGroupCard(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: AppColors.card,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Instance de groupe actuelle',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.mutedForeground,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Groupe par défaut',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.foreground,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/changeInstanceGroup');
                },
                icon: const Icon(Icons.swap_horiz, size: 18),
                label: const Text('Changer d\'instance de groupe'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(44),
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.primaryForeground,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: AppColors.mutedForeground, fontSize: 14)),
          Text(value, style: const TextStyle(color: AppColors.foreground, fontSize: 14, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        OutlinedButton.icon(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/login');
          },
          icon: const Icon(Icons.logout, size: 18, color: AppColors.destructive),
          label: const Text(
            'Déconnexion',
            style: TextStyle(color: AppColors.destructive),
          ),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
            side: const BorderSide(color: AppColors.destructive),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }
}