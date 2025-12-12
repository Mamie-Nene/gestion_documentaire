import 'package:flutter/material.dart';
import '/src/utils/consts/app_specifications/app_colors.dart';

class AppPageShell extends StatelessWidget {
  const AppPageShell({
    super.key,
    required this.title,
    required this.child,
    required this.isForHomePage,
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
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 50),
                child: Row(
                  children: [
                    Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xffF5F6F9)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child:
                      IconButton(
                        icon:Icon(Icons.arrow_back, color: Colors.white, size: 20),
                        onPressed: (){Navigator.of(context).pop();},
                      ),
                    ),

                    SizedBox(width: 10,),
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                title,
                                style:
                        TextStyle(
                        color: Colors.white /* white */,
                        fontSize: 24,
                        fontFamily: 'Archivo',
                        fontWeight: FontWeight.w500,
                        height: 1.40,
                      )

                      //theme.textTheme.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w600,),
                            ),
                            if (subtitle != null)
                              Text(
                                  subtitle!,
                                  /*style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: 'Archivo',
                                    fontWeight: FontWeight.w600,
                                    height: 1.40,
                                  ),*/
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  )
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
              child: Transform.translate(
                offset: const Offset(0, -20),
                child: Container(
                  margin: const EdgeInsets.only(left: 20,right: 20,top: 0,bottom: 5),
                  width: double.infinity,
                  constraints: const BoxConstraints(
                    minHeight: 200,
                  ),
                  decoration:  BoxDecoration(
                    color:Colors.white,
                   // color: bgColor ?? (isForHomePage?AppColors.mainAppColor:AppColors.secondAppColor),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 12,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: padding ?? const EdgeInsets.only(left: 20,right: 20,top: 20,bottom: 5),
                    // padding: padding ?? const EdgeInsets.all(20),
                    child: child,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}