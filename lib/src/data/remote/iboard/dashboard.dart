import 'dart:convert';

import 'package:gestion_documentaire/src/domain/remote/iboard/DashboardIboard.dart';
import 'package:http_interceptor/http/intercepted_http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';

import '../../../domain/remote/digidocs/Dashboard.dart';
import '/src/methods/token_interceptor.dart';
import '/src/utils/consts/app_specifications/all_directories.dart';
import '/src/utils/variable/global_variable.dart';


class IboardDashboardApi{

  getDashboard(String URL, String instanceName) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    final http = InterceptedHttp.build(interceptors: [TokenInterceptor()]);
    if(token==null)
    {
      globalResponseMessage.errorMessage(AppText.NO_TOKEN_GETTED);
      return;
    }
    else {
      final headers = {
        'Authorization': 'Bearer $token',
      };
      try {
        var uri="$URL/${instanceName}";
        print(URL);
        var response = await http.get(
            Uri.parse(uri),headers: headers
        );
        debugPrint("response.statusCode for getDashboard iboard ${response.statusCode}");
        debugPrint("response.body for getDashboard iboard ${response.body}");

        if (response.statusCode == 200) {

          var data = json.decode(response.body);
          DashboardIboard dashboard = DashboardIboard.fromJson(data);
          return dashboard;
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