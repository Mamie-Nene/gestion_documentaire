import 'package:flutter/material.dart';
import 'package:gestion_documentaire/src/presentation/iboard/screens/detailMeeting.dart';

import '/src/presentation/iboard/screens/add_reunion.dart';
import '/src/presentation/iboard/screens/agenda_page.dart';
import '/src/presentation/iboard/screens/feuille_presence_page.dart';
import '/src/presentation/iboard/screens/documents_page.dart';
import '/src/presentation/iboard/screens/meeting_list_page.dart';
import '/src/presentation/iboard/screens/static_meeting_list_page.dart';
import '/src/presentation/iboard/screens/report_page.dart';
import '/src/presentation/iboard/screens/signature_page.dart';

import '/src/presentation/digiDocs/screens/documents/secure_document_viewer.dart';
import '/src/presentation/digiDocs/screens/home_pages/choose_group_instance.dart';

import '/src/presentation/digiDocs/screens/documents/document_view_screen.dart';

import '/src/presentation/digiDocs/screens/auth/profile_screen.dart';
import '../../presentation/digiDocs/screens/auth/login_screen.dart';
import '/src/presentation/digiDocs/screens/home_pages/splash_first_page.dart';
import '/src/utils/consts/routes/app_routes_name.dart';

class IboardRouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutesName.splashFirstPage:
        return MaterialPageRoute(builder: (context) => const SplashPage());

      case AppRoutesName.loginPage:
        return MaterialPageRoute(builder: (context) => const LoginScreen());

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

      case AppRoutesName.chooseGroupInstance:
        return MaterialPageRoute(builder: (context) =>  ChooseGroupInstance());

        // new
      case AppRoutesName.meetingListPage :
      return MaterialPageRoute(builder: (context) =>  ListReunionPage());
       // return MaterialPageRoute(builder: (context) =>  TaskTimelinePage());
         //return MaterialPageRoute(builder: (context) =>  MeetingListPage()); AVANT AVANT

      case AppRoutesName.detailMeetingPage :
        return MaterialPageRoute(builder: (context) =>  MeetingDetailsPage());

      case AppRoutesName.signaturePage :
         return MaterialPageRoute(builder: (context) =>  SignaturePage());

      case AppRoutesName.agendaPage :
        final args = settings.arguments;
        var title = (args as Map)["title"];
         return MaterialPageRoute(builder: (context) =>  AgendaPage(title: title,));

      case AppRoutesName.documentsPage :
         return MaterialPageRoute(builder: (context) => DocumentsPage());

      case AppRoutesName.reportPage :
        return MaterialPageRoute(builder: (context) =>  ReportPage());

      case AppRoutesName.addMeetingPage :
         return MaterialPageRoute(builder: (context) =>  AddReunionScreen());

      case AppRoutesName.feuillePresencePage :
        final args = settings.arguments;
        var title = (args as Map)["title"];
         return MaterialPageRoute(builder: (context) => ListPresencePage(title: title,));
         //return MaterialPageRoute(builder: (context) => FeuillePresencePage(title: title,));
    // return MaterialPageRoute(builder: (context) =>  AttendancePage());


      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
        builder: (context) => Scaffold(
            body: ElevatedButton(
                onPressed: () => Navigator.of(context).pushNamed(AppRoutesName.meetingListPage),
                child: const Text(" Cette page n'existe pas")
            )
        )
    );
  }
}
