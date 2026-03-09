import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gestion_documentaire/src/domain/remote/Document.dart';
import 'package:open_filex/open_filex.dart';
import '/src/domain/remote/iboard/AgendaMeeting.dart';
import '/src/domain/remote/iboard/FeuillePresence.dart';
import '/src/domain/remote/iboard/IboardMeetingData.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_interceptor/http/intercepted_http.dart';

import '/src/methods/token_interceptor.dart';
import '/src/utils/variable/global_variable.dart';
import '/src/utils/consts/app_specifications/all_directories.dart';


class MeetingIboardApi{

  getListMeetings( String URL) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    final http = InterceptedHttp.build(interceptors: [TokenInterceptor()]);
    List<IboardMeetingData> meetings=[];
    if(token==null)
    {
      globalResponseMessage.errorMessage(AppText.NO_TOKEN_GETTED);
      return;
    }
    else {
      var uri = "$URL";
      final headers = {
        'Authorization': 'Bearer $token',
      };
      try {

        print(uri);
        var response = await http.get(
            Uri.parse(uri),headers: headers
        );
        debugPrint("response.statusCode for get iboard meetings ${response.statusCode}");
        debugPrint("response.body for get iboard meetings ${response.body}");

        if (response.statusCode == 200) {

          List data = json.decode(response.body);

          if (data.isEmpty) {
            return meetings;
          }
           meetings = data.map((e) => IboardMeetingData.fromJson(e)).toList();
          return meetings;
        }

        else  {
          print(response.statusCode);
          globalResponseMessage.errorMessage("Une Erreur est survenue!");

        }
      }

      catch (e) {
        debugPrint("error throw: ${e.toString()}");
        globalResponseMessage.errorMessage("Listes Reunions ${AppText.CATCH_ERROR_TEXT}");
      }
    }
  }

  getListOrdreDuJour( String URL,{required String meetingCode}) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    final http = InterceptedHttp.build(interceptors: [TokenInterceptor()]);
    List<AgendaMeeting> agendaMeetings=[];
    if(token==null)
    {
      globalResponseMessage.errorMessage(AppText.NO_TOKEN_GETTED);
      return;
    }
    else {
      var uri = "$URL/$meetingCode";
      final headers = {
        'Authorization': 'Bearer $token',
      };
      try {

        print(uri);
        var response = await http.get(
            Uri.parse(uri),headers: headers
        );
        debugPrint("response.statusCode for get agenda ${response.statusCode}");
        debugPrint("response.body for get agenda ${response.body}");

        if (response.statusCode == 200) {

          List data = json.decode(response.body);

          if (data.isEmpty) {
            return agendaMeetings;
          }
          agendaMeetings = data.map((e) => AgendaMeeting.fromJson(e)).toList();
          return agendaMeetings;
        }

        else  {
          print(response.statusCode);
          globalResponseMessage.errorMessage("Une Erreur est survenue!");

        }
      }

      catch (e) {
        debugPrint("error throw: ${e.toString()}");
        globalResponseMessage.errorMessage("Listes Reunions ${AppText.CATCH_ERROR_TEXT}");
      }
    }
  }

  getFeuillePresence( String URL, {required String meetingCode}) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    final http = InterceptedHttp.build(interceptors: [TokenInterceptor()]);

    if(token==null)
    {
      globalResponseMessage.errorMessage(AppText.NO_TOKEN_GETTED);
      return;
    }
    else {
      var uri = "$URL/$meetingCode";
      final headers = {
        'Authorization': 'Bearer $token',
      };
      try {

        print(uri);
        var response = await http.get(
            Uri.parse(uri),headers: headers
        );
        debugPrint("response.statusCode for get feuille presence ${response.statusCode}");
        debugPrint("response.body for get feuille presence ${response.body}");

        if (response.statusCode == 200) {

          var data = json.decode(response.body);

          FeuillePresence feuillePresence = FeuillePresence.fromJson(data);
          return feuillePresence;
        }

        else if (response.statusCode == 404) {
         return globalResponseMessage.noDataGettedMessage("Pas de feuille de présence déclarée !");

        }
        else  {
          print(response.statusCode);
          globalResponseMessage.errorMessage("Une Erreur est survenue!");

        }
      }

      catch (e) {
        debugPrint("error throw: ${e.toString()}");
        globalResponseMessage.errorMessage("Listes Reunions ${AppText.CATCH_ERROR_TEXT}");
      }
    }
  }

  voirDocuments( String URL,String fileName) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final http = InterceptedHttp.build(interceptors: [TokenInterceptor()]);
    String? token = prefs.getString("token");

    if(token==null)
    {
      globalResponseMessage.errorMessage(AppText.NO_TOKEN_GETTED);
      return;
    }
    else {
      var uri = "$URL?fileName=$fileName";
      final headers = {
        'Authorization': 'Bearer $token',
      };
      try {

        print(uri);
        var response = await http.get(
            Uri.parse(uri),headers: headers
        );
        debugPrint("response.statusCode for view doc ${response.statusCode}");


        if (response.statusCode == 200) {
          // Step 2: Get a temporary directory
          final tempDir = await getTemporaryDirectory();
          final filePath = '${tempDir.path}/$fileName'; // Adjust extension as needed

          // Step 3: Save the file
          final file = File(filePath);
          await file.writeAsBytes(response.bodyBytes);

          // Step 4: Open the file
          final result = await OpenFilex.open(filePath);

          if (result.type != ResultType.done) {
            print("Erreur lors de l'ouverture : ${result.message}");
          }
        } else {
          print("Erreur d'affichage: ${response.statusCode}");
          // Optional: show dialog/snackbar
        }
      }

      catch (e) {
        debugPrint("error throw: ${e.toString()}");
        globalResponseMessage.errorMessage(AppText.CATCH_ERROR_TEXT);
      }
    }
  }

  getListDocuments( String URL) async {
    List<Document> gieDocs = [] ;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    final http = InterceptedHttp.build(interceptors: [TokenInterceptor()]);

    if(token==null)
    {
      globalResponseMessage.errorMessage(AppText.NO_TOKEN_GETTED);
      return;
    }
    else {
      try{
        var uri = "$URL";
        print(uri);
        var response = await http.get(
          Uri.parse(uri),
          headers: {
            'Accept': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
        );

        debugPrint("response.statusCode for get list docs ${response.statusCode}");
        debugPrint("response.body for get list docs ${response.body}");


        if (response.statusCode == 200) {

          List data = json.decode(response.body);
          if (data.isEmpty) {
            return gieDocs;
          }
          gieDocs = data.map((e) => Document.fromJson(e)).toList();
          return gieDocs;
        }
        else if (response.statusCode == 400) {
          globalResponseMessage.errorMessage("Pas documents!!");
          return gieDocs;
        }

        else if (response.statusCode == 500) {//404
          globalResponseMessage.errorMessage("Pas documents!!");
          return gieDocs;
        }
      }
      catch (e) {
        debugPrint("error throw: ${e.toString()}");
        return globalResponseMessage.errorMessage("Connexion impossible. Veuillez réessayer plus tard !!");
      }
    }
  }
}