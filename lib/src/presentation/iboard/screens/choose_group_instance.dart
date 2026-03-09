import 'package:flutter/material.dart';
import '/core/theme/text_style.dart';
import '/src/presentation/widgets/helper.dart';

import '/src/domain/remote/iboard/UserAssignmentGroup.dart';
import '/src/utils/api/api_url_iboard.dart';
import '/src/data/remote/auth_api.dart';


import '/src/utils/consts/routes/app_routes_name.dart';
import '/src/utils/consts/app_specifications/all_directories.dart';

class ChooseGroupInstance extends StatefulWidget {
  ChooseGroupInstance({Key? key}) : super(key: key);

  @override
  State<ChooseGroupInstance> createState() => _ChooseGroupInstanceState();
}

class _ChooseGroupInstanceState extends State<ChooseGroupInstance> {
  int selectedCardIndex = 0;
  String? codeInstance;
  String? instanceName;
  bool isCodeInstanceGetted = false;
  bool isSelected = true;
  bool _isGroupLoader = true;
  List<UserAssignmentGroup> groups = [];

  getListGroups() async {
    await AuthApi().getGroupBelongingToUser(ApiUrlIboard().getListUserGroupsFromUser).then((value) {
      setState(() {
        groups = value;
        _isGroupLoader = false;
      });
    }).catchError((error) {
      setState(() {
        _isGroupLoader = false;
      });
    });
  }

  @override
  void initState() {
    getListGroups();
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.mainBackgroundColor,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimensions.paddingLarge),
              child:_isGroupLoader?
              const Center(
                child: CircularProgressIndicator(),
              )
                  :
                  groups.isEmpty?
                  //  TextButton(onPressed: (){getListGroups();}, child: Text('test'))
                  Text('Aucune instance trouvée pour votre profil!')
                  :
              _buildChooseInstanceCard(context,groups),

            )
      ),
        )
    );
  }

  Widget _buildChooseInstanceCard(BuildContext context, List<UserAssignmentGroup> groups) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 500),
      padding: const EdgeInsets.all(AppDimensions.paddingLarge + 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge + 8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [

        Text(
        'Veuillez sélectionner une instance de groupe',
        style: TextStyleHelper.instance.title18BoldPlusJakartaSans.copyWith(
          fontSize: 28,
          color: appTheme.gray_900,

          height: 1.2,
        ),
      ),

          const SizedBox(height: AppDimensions.paddingLarge + 4),
          Text(
            'Ci-dessous, la liste des instances de groupe dans lesquels vous êtes assignés.',
            style: TextStyleHelper.instance.body14RegularPlusJakartaSans.copyWith(
              color: appTheme.gray_600,
              height: 1.4,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingMedium),
          SizedBox(
              height: 400,
              child: _buildCardsList(context,groups)
          ),

        ],
      ),
    );
  }

  Widget _buildCardsList(BuildContext context, List<UserAssignmentGroup> groups) {

    return SingleChildScrollView(
          child: Column(
            children: [
              ...List.generate(groups.length, (index) {

                final group = groups[index];
                String logoText = Helper().getUserAssignmentGroupCodeText(group.groupName);
                return GroupUserCardWidget(
                  userAssignmentGroup: group,
                  logoText :logoText,
                  isSelected: selectedCardIndex == index,
                  onTap: () {
                    setState(() {
                      selectedCardIndex = index;
                      isCodeInstanceGetted=true;
                      codeInstance = logoText;
                      instanceName = group.groupName;
                    });
                    print(selectedCardIndex);
                  },
                );
              }),
              SizedBox(height: 12),
            //  _buildAddCardButton(context),

              codeInstance==null||instanceName==null?
                  const SizedBox()
                  :
              _buildContinueButton(context, isCodeInstanceGetted,codeInstance!,instanceName!),
              SizedBox(height: 20),
            ],
          )
    );
  }



  Widget _buildAddCardButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
       // Navigator.of(context).pushNamed(AppRoutesName.homePage);
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: appTheme.white_A700,
          border: Border.all(color: appTheme.gray_300, width: 2.0),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: appTheme.gray_200,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Icon(Icons.add, color: appTheme.gray_600, size: 24),
            ),
            SizedBox(width: 16),
            Text(
              'Demander à intégrer un groupe',
              style: TextStyleHelper.instance.title16MediumPlusJakartaSans,
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildContinueButton(BuildContext context,bool isCodeInstanceGetted, String? codeInstance, String? instanceName) {
    return
      SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed:isCodeInstanceGetted? () {Navigator.of(context).pushNamed(AppRoutesName.meetingListPage,arguments: {"codeInstance": codeInstance,"instanceName":instanceName});} : null ,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                vertical: AppDimensions.paddingMedium + 2,
              ),
              backgroundColor: isCodeInstanceGetted?AppColors.secondWebAppColor:Colors.grey,
              // backgroundColor: AppColors.mainAppColor,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(AppDimensions.borderRadiusLarge),
              ),
            ),
            child: const Text(
              'Rejoindre mon espace',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
          ),
        );
  }

  GroupUserCardWidget ( {
    required UserAssignmentGroup userAssignmentGroup,
    required String logoText,
    required bool isSelected,
    required VoidCallback? onTap,
  }) {

    Color logoColor = appTheme.gray_600;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? appTheme.bleu_600.withAlpha(13)
              : appTheme.white_A700,
          border: Border.all(
            color: isSelected ? appTheme.bleu_600 : appTheme.gray_300,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: appTheme.gray_200,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Center(
                  child: Text(logoText,
                      style: TextStyleHelper.instance.body12MediumPlusJakartaSans.copyWith(
                      color: logoColor,
                     fontWeight: FontWeight.w700,
                    ),
                  )
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userAssignmentGroup.groupName,
                    style: TextStyleHelper.instance.title16MediumPlusJakartaSans,
                  ),
                  SizedBox(height: 4),
                  Text(
                    userAssignmentGroup.groupRoleName,
                    style: TextStyleHelper.instance.body14RegularPlusJakartaSans
                      .copyWith(color: appTheme.gray_600),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: appTheme.bleu_600,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check, color: appTheme.white_A700, size: 16,
                ),
              ),
          ],
        ),
      ),
    );
  }


}

