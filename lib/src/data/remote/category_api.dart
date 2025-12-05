import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gestion_documentaire/src/domain/remote/Categorie.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '/src/utils/variable/global_variable.dart';
import '/src/utils/consts/routes/app_routes_name.dart';
import '/src/utils/consts/app_specifications/all_directories.dart';


class CatecoriesApi{

  getListCategory( String URL) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

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
        debugPrint("response.statusCode for stats inspecteurs ${response.statusCode}");
        debugPrint("response.body for stats inspecteurs ${response.body}");

        if (response.statusCode == 200) {

          var data = json.decode(response.body);
          var statistiques = data["statistiques"];

          List<Categorie> inspecteurStats = data.map((e) => Categorie.fromJson(e)).toList();
          return inspecteurStats;
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