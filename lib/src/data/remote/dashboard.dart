import 'dart:convert';
import 'package:http_interceptor/http/intercepted_http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/cupertino.dart';
import '/src/domain/remote/Dashboard.dart';
import '/src/methods/token_interceptor.dart';
import '/src/utils/consts/app_specifications/all_directories.dart';
import '/src/utils/variable/global_variable.dart';


class DashboardApi{

  getDashboard(String URL) async {

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
        print(URL);
        var response = await http.get(
            Uri.parse(URL),headers: headers
        );
        debugPrint("response.statusCode for getDashboard ${response.statusCode}");
        debugPrint("response.body for getDashboard ${response.body}");

        if (response.statusCode == 200) {

          var data = json.decode(response.body);
          Dashboard dashboard = Dashboard.fromJson(data);
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