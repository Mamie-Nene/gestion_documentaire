import 'package:flutter/material.dart';
import 'package:gestion_documentaire/src/presentation/widgets/utils_widget.dart';
import 'package:gestion_documentaire/src/utils/consts/app_specifications/all_directories.dart';
import '/src/utils/consts/app_specifications/app_colors.dart';

class AppPageShell extends StatelessWidget {
  const AppPageShell({
    super.key,
    required this.title,
    required this.child,
    required this.isForHomePage,
    required this.whiteColorForMainCardIsHere,
    this.isItAnExtendedFloatingButton,
    this.subtitle,
    this.bgColor,
    this.padding,
    this.actions,
    this.actionForFloatingButton,
    this.decoration,
  });

  final String title;
  final String? subtitle;
  final Color? bgColor;
  final bool isForHomePage;
  final bool whiteColorForMainCardIsHere;
  final bool? isItAnExtendedFloatingButton;
  final VoidCallback? actionForFloatingButton;
  final EdgeInsetsGeometry? padding;
  final Widget child;
  final List<Widget>? actions;
  final Decoration? decoration;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Color(0xffEEF2F8),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Blue header section only
            Container(
              width: double.infinity,
              decoration: decoration ?? const BoxDecoration(
                color: Color(0xff305A9D),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, top: 50, bottom: 100),
                child: Row(
                  children: [
                    UtilsWidget().iconContainerCard(
                      isItWithBorder: true,
                      bgColor: null,
                      widget:IconButton(
                        icon:Icon(isForHomePage?Icons.menu:Icons.arrow_back, color: Colors.white, size: 20),
                        onPressed: isForHomePage?null:(){Navigator.of(context).pop();},
                      ),
                    ),
                    SizedBox(width: 10,),
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (subtitle != null)
                              Text(
                                  subtitle!,
                                  style: TextStyle(
                                    color: Color(0xffDEE8EE),
                                    fontSize: 16,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w500,
                                    height: 1.40,
                                  ),
                                 /* style: theme.textTheme.bodyLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  )*/
                              ),
                            Text(
                                title,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w700,
                                  height: 1.40,
                                )
                              //theme.textTheme.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w600,),
                            ),
                          ]
                      ),
                    ),
                    if (actions != null) ...actions!,
                  ],
                ),
              ),
            ),
            // White content card
            Flexible(
              fit: FlexFit.loose,
              child: Transform.translate(
                offset: const Offset(0, -70),
                child: whiteColorForMainCardIsHere
                    ? Container(
                        margin: const EdgeInsets.only(left: 20,right: 20,top: 0,bottom: 5),
                        width: double.infinity,
                        decoration:  BoxDecoration(
                          color:Colors.white,
                         // color: bgColor ?? (isForHomePage?AppColors.mainAppColor:AppColors.secondAppColor),
                          borderRadius: BorderRadius.circular(12.0)
                        ),
                        child: Padding(
                          padding: padding ?? const EdgeInsets.only(left: 20,right: 20,top: 20,bottom: 5),
                          // padding: padding ?? const EdgeInsets.all(20),
                          child: child,
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(left: 20,right: 20,top: 0,bottom: 5),
                        //padding:  EdgeInsets.symmetric(horizontal: AppDimensions.paddingLarge, vertical: AppDimensions.paddingMedium,),
                        child: child,
                      )
              ),
            ),
          ],
        ),
      ),
    );
  }
}