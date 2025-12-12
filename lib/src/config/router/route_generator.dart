import 'package:flutter/material.dart';
import 'package:gestion_documentaire/src/presentation/screens/categories/category_list_screen.dart';
import 'package:gestion_documentaire/src/presentation/screens/categories/categorie_page.dart';
import 'package:gestion_documentaire/src/presentation/screens/documents/recents_document_list_screen.dart';
import 'package:gestion_documentaire/src/presentation/screens/events/evenement_list_screen.dart';
import '../../presentation/screens/documents/document_list_screen.dart';
import '../../presentation/screens/documents/document_view_screen.dart';
import '/src/presentation/screens/home_pages/home_screen.dart';
import '../../presentation/screens/auth/profile_screen.dart';
import '/src/presentation/screens/login_screen.dart';
import '/src/presentation/screens/home_pages/splash_first_page.dart';
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
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        var event = args["event"];
        var category = args["category"];
        var subtitle = args["subtitle"];

        return MaterialPageRoute(
            builder: (context) => DocumentListScreen(event: event,categorie :category ,subtitle:subtitle));


        case AppRoutesName.recentDocumentPage :
          return MaterialPageRoute(builder: (context) => const RecentDocumentListScreen());

        // ----------------------- Evenement Pages ------------------------

        case AppRoutesName.evenementListPage :
          return MaterialPageRoute(builder: (context) => const EventListScreen());

        // ----------------------- Category Pages ------------------------

        case AppRoutesName.categoryListPage:
          return MaterialPageRoute(builder: (context) => const CategoryListScreen());

        case AppRoutesName.categoriePage:
          return MaterialPageRoute(builder: (context) => const CategoriePage());

      case AppRoutesName.viewDocumentPage:
        final args = settings.arguments;
        var document = (args as Map)["document"];
        return MaterialPageRoute(
            builder: (context) => DocumentViewScreen(document: document));

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
                    Navigator.of(context).pushNamed(AppRoutesName.homePage),
                child: const Text(" Cette page n'existe pas"))));
  }
}
