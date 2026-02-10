import 'package:flutter/material.dart';

import '/src/utils/consts/routes/app_routes_name.dart';
import '/src/utils/consts/app_specifications/all_directories.dart';

class ChooseGroupInstance extends StatefulWidget {
  ChooseGroupInstance({Key? key}) : super(key: key);

  @override
  State<ChooseGroupInstance> createState() => _ChooseGroupInstanceState();
}

class _ChooseGroupInstanceState extends State<ChooseGroupInstance> {
  int selectedCardIndex = 0;
  bool isSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.mainBackgroundColor,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimensions.paddingLarge),
              child:_buildChooseInstanceCard(context),
            )
      ),
        )
    );
  }

  Widget _buildChooseInstanceCard(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 500),
      padding: const EdgeInsets.all(AppDimensions.paddingLarge + 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(AppDimensions.borderRadiusLarge + 8),
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
          _buildTitle(context),
          const SizedBox(height: AppDimensions.paddingLarge + 4),
          _buildSubtitle(context),
          const SizedBox(height: AppDimensions.paddingMedium),
      SizedBox(
        height: 400,child: _buildCardsList(context)),
        //  Expanded(child: _buildCardsList(context)),
          _buildContinueButton(context),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      'Veuillez sélectionner une instance de groupe',
      style: TextStyleHelper.instance.title18BoldPlusJakartaSans.copyWith(
        fontSize: 28,
        color: appTheme.gray_900,

        height: 1.2,
      ),
    );
  }

  Widget _buildSubtitle(BuildContext context) {
    return Text(
      'Ci-dessous, la liste des instances de groupe dans lesquels vous êtes assignés.',
      style: TextStyleHelper.instance.body14RegularPlusJakartaSans.copyWith(
        color: appTheme.gray_600,
        height: 1.4,
      ),
    );
  }

  Widget _buildCardsList(BuildContext context) {
    List<PaymentCardModel> cardsList = [
      PaymentCardModel(
        cardName: 'Comité Gestion',
        cardNumber: 'Président de comité',
        cardType: 'CG',
        isSelected: selectedCardIndex == 'Comité Gestion',
      ),
      PaymentCardModel(
        cardName: 'Comité Développement',
        cardNumber: 'Membre simple',
        cardType: 'CD',
        isSelected: selectedCardIndex == 'Comité Développement',
      ),
      PaymentCardModel(
        cardName: 'Comité Stratégique',
        cardNumber: 'Coordinateur',
        cardType: 'CS',
        isSelected: selectedCardIndex == 'Comité Stratégique',
      ),
    ];

    return SingleChildScrollView(
          child: Column(
            children: [
              ...List.generate(cardsList.length, (index) {
                final card = cardsList[index];
                return PaymentCardItemWidget(
                  cardItem: card,
                  isSelected: selectedCardIndex == index,
                  onTap: () {
                   // selectedCardIndex == index;
                    setState(() {
                      selectedCardIndex = index;
                      print(selectedCardIndex);
                     // cardsList[index].isSelected = !cardsList[index].isSelected!;
                    });
                  },
                );
              }),
              SizedBox(height: 12),
            //  _buildAddCardButton(context),
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

  Widget _buildContinueButtonAvant(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(AppRoutesName.homePage);
      },
      child: Container(
        width: double.maxFinite,
        height: 56,
        decoration: BoxDecoration(
          color: Color(0xff7DAA40),
         // color: appTheme.gray_900,
          borderRadius: BorderRadius.circular(28.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.arrow_forward, color: appTheme.white_A700, size: 24),
          ],
        ),
      ),
    );
  }
  Widget _buildContinueButton(BuildContext context) {
    return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed:() {
              Navigator.of(context).pushNamed(AppRoutesName.homePage);
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                vertical: AppDimensions.paddingMedium + 2,
              ),
              backgroundColor: Color(0xff7DAA40),
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
}

class PaymentCardItemWidget extends StatelessWidget {
  final PaymentCardModel cardItem;
  final bool isSelected;
  final VoidCallback? onTap;

  const PaymentCardItemWidget({
    Key? key,
    required this.cardItem,
    required this.isSelected,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              child: Center(child: _buildCardLogo()),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cardItem.cardName ?? '',
                    style:
                    TextStyleHelper.instance.title16MediumPlusJakartaSans,
                  ),
                  SizedBox(height: 4),
                  Text(
                    cardItem.cardNumber ?? '',
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
                child: Icon(
                  Icons.check,
                  color: appTheme.white_A700,
                  size: 16,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardLogo() {
    String logoText = '';
    Color logoColor = appTheme.gray_600;

    switch (cardItem.cardType?.toLowerCase()) {
      case 'elo':
        logoText = 'ELO';
        logoColor = appTheme.gray_900;
        break;
      case 'mastercard':
        logoText = 'MC';
        logoColor = Colors.red;
        break;
      case 'visa':
        logoText = 'VISA';
        logoColor = Colors.blue;
        break;
      default:
        logoText = 'CARD';
    }

    return Text(cardItem.cardType!,
      //logoText,
      style: TextStyleHelper.instance.body12MediumPlusJakartaSans.copyWith(
        color: logoColor,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class TextStyleHelper {
  static TextStyleHelper? _instance;

  TextStyleHelper._();

  static TextStyleHelper get instance {
    _instance ??= TextStyleHelper._();
    return _instance!;
  }

  // Title Styles
  // Medium text styles for titles and subtitles

  TextStyle get title20RegularRoboto => TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w400,
    fontFamily: 'Roboto',
  );

  TextStyle get title18BoldPlusJakartaSans => TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    fontFamily: 'Plus Jakarta Sans',
  );

  TextStyle get title16MediumPlusJakartaSans => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    fontFamily: 'Plus Jakarta Sans',
    color: appTheme.gray_900_01,
  );

  TextStyle get title16RegularPlusJakartaSans => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontFamily: 'Plus Jakarta Sans',
    color: appTheme.gray_600,
  );

  // Body Styles
  // Standard text styles for body content

  TextStyle get body15RegularInter => TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    fontFamily: 'Inter',
    color: appTheme.gray_700,
  );

  TextStyle get body14BoldPlusJakartaSans => TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    fontFamily: 'Plus Jakarta Sans',
  );

  TextStyle get body14RegularPlusJakartaSans => TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontFamily: 'Plus Jakarta Sans',
    color: appTheme.green_600_01,
  );

  TextStyle get body13RegularInter => TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    fontFamily: 'Inter',
    color: appTheme.gray_500_01,
  );

  TextStyle get body13SemiBoldInter => TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    fontFamily: 'Inter',
    color: appTheme.gray_700_01,
  );

  TextStyle get body12SemiBoldInter => TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    fontFamily: 'Inter',
    color: appTheme.gray_400_02,
  );

  TextStyle get body12MediumPlusJakartaSans => TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    fontFamily: 'Plus Jakarta Sans',
  );

  // Label Styles
  // Small text styles for labels, captions, and hints

  TextStyle get label11SemiBoldInter => TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    fontFamily: 'Inter',
    color: appTheme.green_300,
  );

  TextStyle get label11LightInter => TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w300,
    fontFamily: 'Inter',
    color: appTheme.gray_500_02,
  );

  TextStyle get label10LightInter => TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w300,
    fontFamily: 'Inter',
    color: appTheme.gray_500,
  );

  TextStyle get label10SemiBoldInter => TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    fontFamily: 'Inter',
    color: appTheme.gray_400,
  );

  TextStyle get label9SemiBoldInter => TextStyle(
    fontSize: 9,
    fontWeight: FontWeight.w600,
    fontFamily: 'Inter',
    color: appTheme.orange_300,
  );
}


LightCodeColors get appTheme => ThemeHelper().themeColor();
ThemeData get theme => ThemeHelper().themeData();

/// Helper class for managing themes and colors.

// ignore_for_file: must_be_immutable
class ThemeHelper {
  // The current app theme
  var _appTheme = "lightCode";

  // A map of custom color themes supported by the app
  Map<String, LightCodeColors> _supportedCustomColor = {
    'lightCode': LightCodeColors(),
  };

  // A map of color schemes supported by the app
  Map<String, ColorScheme> _supportedColorScheme = {
    'lightCode': ColorSchemes.lightCodeColorScheme,
  };

  /// Returns the lightCode colors for the current theme.
  LightCodeColors _getThemeColors() {
    return _supportedCustomColor[_appTheme] ?? LightCodeColors();
  }

  /// Returns the current theme data.
  ThemeData _getThemeData() {
    var colorScheme =
        _supportedColorScheme[_appTheme] ?? ColorSchemes.lightCodeColorScheme;
    return ThemeData(
      visualDensity: VisualDensity.standard,
      colorScheme: colorScheme,
    );
  }

  /// Returns the lightCode colors for the current theme.
  LightCodeColors themeColor() => _getThemeColors();

  /// Returns the current theme data.
  ThemeData themeData() => _getThemeData();
}

class ColorSchemes {
  static final lightCodeColorScheme = ColorScheme.light();
}

class LightCodeColors {
  // App Colors
  Color get gray_900 => Color(0xFF1C160C);
  Color get white_A700 => Color(0xFFFFFFFF);
  Color get gray_600 => Color(0xFF727272);
  Color get deep_orange_50 => Color(0xFFF5F0E5);
  Color get gray_200 => Color(0xFFE5E8EA);
  Color get green_600 => Color(0xFF30A05E);
  Color get bleu_600 => Color(0xFF0056D6);
  Color get yellow_800 => Color(0xFFEF9920);
  Color get gray_900_01 => Color(0xFF0C1C11);
  Color get green_600_01 => Color(0xFF4C9368);
  Color get deep_orange_50_01 => Color(0xFFF4EFE5);
  Color get black_900 => Color(0xFF000000);
  Color get gray_300 => Color(0xFFE8DDCE);
  Color get gray_700 => Color(0xFF585858);
  Color get gray_500 => Color(0xFFADADAD);
  Color get gray_400 => Color(0xFFBFC0C0);
  Color get orange_50 => Color(0xFFFEF4E4);
  Color get amber_100 => Color(0xFFFEE6C5);
  Color get orange_300 => Color(0xFFF3B965);
  Color get orange_50_01 => Color(0xFFFEF5E4);
  Color get orange_300_01 => Color(0xFFF3BA67);
  Color get orange_50_02 => Color(0xFFFEF4E2);
  Color get orange_300_02 => Color(0xFFF4BB68);
  Color get yellow_100 => Color(0xFFFEE7C6);
  Color get orange_50_03 => Color(0xFFFEF5E5);
  Color get green_300 => Color(0xFF7AC097);
  Color get gray_400_01 => Color(0xFFAEAEAE);
  Color get gray_400_02 => Color(0xFFAFAFAF);
  Color get gray_700_01 => Color(0xFF5E5E5E);
  Color get gray_400_03 => Color(0xFFBFBFBF);
  Color get gray_500_01 => Color(0xFF929292);
  Color get gray_500_02 => Color(0xFF979797);
  Color get gray_700_02 => Color(0xFF5A5A59);
  Color get gray_400_04 => Color(0xFFB6B6B6);
  Color get gray_400_05 => Color(0xFFC4C4C4);
  Color get orange_300_03 => Color(0xFFF3BB68);
  Color get orange_50_04 => Color(0xFFFEF4E3);
  Color get orange_50_05 => Color(0xFFFEF5E6);
  Color get orange_200 => Color(0xFFF4BC6A);
  Color get gray_400_06 => Color(0xFFB8B8B8);
  Color get gray_500_03 => Color(0xFFACACAC);
  Color get gray_500_04 => Color(0xFFA9A9A9);
  Color get gray_400_07 => Color(0xFFC5C5C6);
  Color get gray_500_05 => Color(0xFF999999);

  // Additional Colors
  Color get transparentCustom => Colors.transparent;
  Color get greyCustom => Colors.grey;
  Color get redCustom => Colors.red;

  // Color Shades - Each shade has its own dedicated constant
  Color get grey200 => Colors.grey.shade200;
  Color get grey100 => Colors.grey.shade100;
}

class PaymentCardModel {
  final String? cardName;
  final String? cardNumber;
  final String? cardType;
   bool? isSelected;

  PaymentCardModel({
    this.cardName,
    this.cardNumber,
    this.cardType,
    this.isSelected,
  });

  PaymentCardModel copyWith({
    String? cardName,
    String? cardNumber,
    String? cardType,
    bool? isSelected,
  }) {
    return PaymentCardModel(
      cardName: cardName ?? this.cardName,
      cardNumber: cardNumber ?? this.cardNumber,
      cardType: cardType ?? this.cardType,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  @override
  List<Object?> get props => [cardName, cardNumber, cardType, isSelected];
}
