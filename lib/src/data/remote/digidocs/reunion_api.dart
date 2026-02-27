import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gestion_documentaire/src/domain/remote/EventTimeline.dart';
import 'package:gestion_documentaire/src/domain/remote/IboardMeetingData.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_interceptor/http/intercepted_http.dart';

import '/src/domain/remote/Event.dart';
import '/src/methods/token_interceptor.dart';
import '/src/utils/variable/global_variable.dart';
import '/src/utils/consts/app_specifications/all_directories.dart';


class ReunionApi{

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

  getListReunions( String URL) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    final http = InterceptedHttp.build(interceptors: [TokenInterceptor()]);
    List<Event> evenements=[];
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
        debugPrint("response.statusCode for get events ${response.statusCode}");
        debugPrint("response.body for get events ${response.body}");

        if (response.statusCode == 200) {

          List data = json.decode(response.body);

          if (data.isEmpty) {
            return evenements;
          }
           evenements = data.map((e) => Event.fromJson(e)).toList();
//          evenements = data.map((e) => Event.fromJson(e as Map<String, dynamic>)).toList();
           return evenements;
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

}