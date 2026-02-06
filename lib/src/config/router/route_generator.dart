import 'package:flutter/material.dart';
import 'package:gestion_documentaire/src/presentation/screens/documents/secure_document_viewer.dart';

import '/src/presentation/screens/categories/categorie_page.dart';
import '/src/presentation/screens/categories/add_category_screen.dart';
import '/src/presentation/screens/documents/recents_document_list_screen.dart';
import '/src/presentation/screens/documents/add_document_screen.dart';
import '/src/presentation/screens/events/details_evenement_screen.dart';

import '/src/presentation/screens/events/evenement_list_screen.dart';
import '/src/presentation/screens/events/event_calendar_screen.dart';
import '/src/presentation/screens/events/add_event_screen.dart';
import '/src/presentation/screens/documents/document_list_screen.dart';
import '/src/presentation/screens/documents/document_view_screen.dart';

import '/src/presentation/screens/home_pages/home_screen.dart';
import '/src/presentation/screens/auth/profile_screen.dart';
import '../../presentation/screens/auth/login_screen.dart';
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
        var eventCode = args["eventCode"];
        var category = args["category"];
        var subtitle = args["subtitle"];

        return MaterialPageRoute(
            builder: (context) => DocumentListScreen(eventCode: eventCode,category :category ,subtitle:subtitle));


        case AppRoutesName.recentDocumentPage :
          return MaterialPageRoute(builder: (context) => const RecentDocumentListScreen());

        // ----------------------- Evenement Pages ------------------------

        case AppRoutesName.evenementListPage :
          return MaterialPageRoute(builder: (context) => const EventListScreen());

          case AppRoutesName.detailsEventPage :
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        var eventCode = args["eventCode"];
        var eventId =  args["eventId"];
        return MaterialPageRoute(builder: (context) => DetailsEvenementScreen(eventCode: eventCode,eventId: eventId,));

        case AppRoutesName.eventCalendarPage:
          return MaterialPageRoute(builder: (context) => const EventCalendarScreen());

        case AppRoutesName.addEventPage:
          return MaterialPageRoute(builder: (context) => const AddEventScreen());

        // ----------------------- Category Pages ------------------------


        case AppRoutesName.categoriePage:
          return MaterialPageRoute(builder: (context) => const CategorieListScreen());

        case AppRoutesName.addCategoryPage:
          return MaterialPageRoute(builder: (context) => const AddCategoryScreen());

        // ----------------------- Document Pages ------------------------

        case AppRoutesName.addDocumentPage:
          return MaterialPageRoute(builder: (context) => const AddDocumentScreen());

      case AppRoutesName.viewDocumentPage:
        final args = settings.arguments;
        var document = (args as Map)["document"];
        return MaterialPageRoute(builder: (context) => DocumentViewScreen(document: document));

      case AppRoutesName.openSecureDocPage:
        final args = settings.arguments;
        var fileName = (args as Map)["fileName"];
       return MaterialPageRoute(builder: (context) => SecureDocumentViewer(fileName: fileName));

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
