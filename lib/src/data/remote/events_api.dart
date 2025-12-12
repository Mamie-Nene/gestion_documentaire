import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gestion_documentaire/src/domain/remote/Categorie.dart';
import 'package:gestion_documentaire/src/domain/remote/Event.dart';
import 'package:gestion_documentaire/src/methods/token_interceptor.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_interceptor/http/intercepted_http.dart';

import '/src/utils/variable/global_variable.dart';
import '/src/utils/consts/routes/app_routes_name.dart';
import '/src/utils/consts/app_specifications/all_directories.dart';


class EventsApi{

  getListEvents( String URL) async {

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
        globalResponseMessage.errorMessage(AppText.CATCH_ERROR_TEXT);
      }
    }
  }
  getLastEvents( String URL) async {
    final http = InterceptedHttp.build(interceptors: [TokenInterceptor()]);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
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
          evenements.sort((a, b) => DateTime.parse(b.eventDate)
              .compareTo(DateTime.parse(a.eventDate)));

          return evenements.take(4).toList();
           //return evenements;
        }

        else  {
          print(response.statusCode);
          globalResponseMessage.errorMessage("Une Erreur est survenue!");

        }
      }

      catch (e) {
        debugPrint("error throw: ${e.toString()}");
        globalResponseMessage.errorMessage(AppText.CATCH_ERROR_TEXT);
      }
    }
  }

  getDetailEvent( String URL, String idEvent) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    if(token==null)
    {
      globalResponseMessage.errorMessage(AppText.NO_TOKEN_GETTED);
      return;
    }
    else {
      var uri = "$URL/$idEvent";
      final headers = {
        'Authorization': 'Bearer $token',
      };
      try {

        print(uri);
        var response = await http.get(
            Uri.parse(uri),headers: headers
        );
        debugPrint("response.statusCode for detail event ${response.statusCode}");
        debugPrint("response.body for detail event ${response.body}");

        if (response.statusCode == 200) {

          var data = json.decode(response.body);

          Event event =Event.fromJson(data);
          return event;
        }

        else  {
          print(response.statusCode);
          globalResponseMessage.errorMessage("Une Erreur est survenue!");

        }
      }

      catch (e) {
        debugPrint("error throw: ${e.toString()}");
        globalResponseMessage.errorMessage(AppText.CATCH_ERROR_TEXT);
      }
    }
  }
}