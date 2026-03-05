import 'dart:io';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:gestion_documentaire/core/theme/app_colors.dart';
import 'package:gestion_documentaire/src/config/router/iboard_route_generator.dart';

import '/src/config/router_observer.dart';
import '/src/utils/variable/global_variable.dart';
import 'src/config/router/digidocs_route_generator.dart';
import 'src/utils/consts/routes/app_routes_name.dart';

import '/src/utils/app_localization.dart';

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}
/*authorise fingerprint on ios
<key>NSFaceIDUsageDescription</key>
<string>Authenticate to view secure documents</string>*/
void main() {
   HttpOverrides.global = MyHttpOverrides();
  runApp(
     /* DevicePreview( // for ios simulator
        enabled: true,
        builder: (context) =>*/ MyApp()
       //)
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData appTheme = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primary,
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        error: AppColors.destructive,
        background: AppColors.background,
      ),
      cardColor: AppColors.card,
      dividerColor: AppColors.border,
    );

    MaterialApp iboardMaterialApp = MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorObservers: [routeObserver],
      title: 'gestion_documentaire',
      theme: appTheme,
      navigatorKey: navigatorKey, // <-- clé globale
      scaffoldMessengerKey: scaffoldMessengerKey, // Associer la GlobalKey
      initialRoute: AppRoutesName.splashFirstPage,
      onGenerateRoute: (settings) => IboardRouteGenerator.generateRoute(settings, true),
      //onGenerateRoute: IboardRouteGenerator.generateRoute,
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('fr', ''),
      ],
      locale: Locale('fr'),
    );

    MaterialApp digidocsMaterialApp =  MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorObservers: [routeObserver],
      title: 'gestion_documentaire',
       theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      navigatorKey: navigatorKey, // <-- clé globale
      scaffoldMessengerKey: scaffoldMessengerKey, // Associer la GlobalKey
      initialRoute: AppRoutesName.splashFirstPage,
      onGenerateRoute: (settings) => DigidocsRouteGenerator.generateRoute(settings, false),
      // onGenerateRoute: DigidocsRouteGenerator.generateRoute,
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('fr', ''),
      ],
      locale: Locale('fr'),
    );

    return iboardMaterialApp;
  //  return digidocsMaterialApp;

  }
}