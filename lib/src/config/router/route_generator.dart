import 'package:flutter/material.dart';
import '/src/presentation/screens/document_list_screen.dart';
import '/src/presentation/screens/document_view_screen.dart';
import '/src/presentation/screens/home_pages/home_screen.dart';
import '/src/presentation/screens/home_pages/profile_screen.dart';
import '/src/presentation/screens/login_screen.dart';
import '/src/presentation/screens/auth/login.dart';
import '/src/presentation/screens/home_pages/splash_first_page.dart';

import '/src/presentation/screens/home_pages/task_page.dart';
import '/src/utils/consts/routes/app_routes_name.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutesName.splashFirstPage:
        return MaterialPageRoute(builder: (context) => const SplashPage());

      case AppRoutesName.loginPage:
        return MaterialPageRoute(builder: (context) => const LoginScreen());

      case AppRoutesName.homePage:
        return MaterialPageRoute(builder: (context) => const HomeScreen());

      case AppRoutesName.documentPage:
        return MaterialPageRoute(
            builder: (context) => const DocumentListScreen());

      case AppRoutesName.viewDocumentPage:
        final args = settings.arguments;
        var titleDoc = (args as Map)["titleDoc"].toString();
        return MaterialPageRoute(
            builder: (context) => DocumentViewScreen(titleDoc: titleDoc));

      case AppRoutesName.profilePage:
        return MaterialPageRoute(builder: (context) => const ProfileScreen());

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
        builder: (context) => Scaffold(
            body: ElevatedButton(
                onPressed: () =>
                    Navigator.of(context).pushNamed(AppRoutesName.accueilPage),
                child: const Text(" Cette page n'existe pas"))));
  }
}
