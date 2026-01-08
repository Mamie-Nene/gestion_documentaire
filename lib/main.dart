import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:gestion_documentaire/src/config/router_observer.dart';
import 'package:gestion_documentaire/src/utils/variable/global_variable.dart';
import 'src/config/router/route_generator.dart';
import 'src/utils/consts/routes/app_routes_name.dart';
import 'dart:io';
import 'package:flutter_localizations/flutter_localizations.dart';
import '/src/utils/app_localization.dart';

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}
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
    return MaterialApp(
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
      onGenerateRoute: RouteGenerator.generateRoute,
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
  }
}