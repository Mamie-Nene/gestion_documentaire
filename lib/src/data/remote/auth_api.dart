import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/intercepted_http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/src/domain/remote/UserInfo.dart';
import '/src/methods/token_interceptor.dart';
import '/src/utils/variable/global_variable.dart';
import '/src/utils/consts/routes/app_routes_name.dart';
import '/src/utils/consts/app_specifications/all_directories.dart';


class AuthApi{

  loginRequest(BuildContext context,String email, String password, String URL) async {

    try {

      var response = await http.post(
          Uri.parse(URL),
          headers: {
            'Content-Type': 'application/json'
          },
          body: jsonEncode({
            'email': email,
            'password': password,
          })
      );
      debugPrint("response.statusCode for getToken after login ${response.statusCode}");
      debugPrint("response.body for getToken after login ${response.body}");

      if (response.statusCode == 200) {

        print(response.body);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var data = json.decode(response.body);
        String token = data['token'];

        prefs.setString("token", token);
        prefs.setString("email", email);
        prefs.setBool("isLoggedIn", true);

        globalResponseMessage.successMessage("Connexion réussie !!");

        if(context.mounted) {
          return Navigator.of(context).pushReplacementNamed(AppRoutesName.chooseGroupInstance);
         // return Navigator.of(context).pushReplacementNamed(AppRoutesName.homePage);
        }

      }

      else  {//400
        print(response.statusCode);
        globalResponseMessage.errorMessage("Identifiant ou mot de passe invalide !! ");

      }
    }

    catch (e) {
      debugPrint("error throw: ${e.toString()}");
      globalResponseMessage.errorMessage(AppText.NO_CONNECTION);
    }

  }

  getUserInfo( String URL) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    String? emailUser = prefs.getString("email");
    final http = InterceptedHttp.build(interceptors: [TokenInterceptor()]);

    if(token==null)
    {
      globalResponseMessage.errorMessage(AppText.NO_TOKEN_GETTED);
      return;
    }
    else {
      var uri = "$URL/$emailUser";
      final headers = {
        'Authorization': 'Bearer $token',
      };
      try {
        print(uri);
        var response = await http.get(
            Uri.parse(uri),headers: headers
        );
        debugPrint("response.statusCode for user Info ${response.statusCode}");
        debugPrint("response.body for user Info ${response.body}");

        if (response.statusCode == 200) {

          var data = json.decode(response.body);

          UserInfo userInfo = UserInfo.fromJson(data);
          return userInfo;
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

  getGroupBelongingToUserInfo( String URL) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    String? emailUser = prefs.getString("email");
    final http = InterceptedHttp.build(interceptors: [TokenInterceptor()]);

    if(token==null)
    {
      globalResponseMessage.errorMessage(AppText.NO_TOKEN_GETTED);
      return;
    }
    else {
      var uri = "$URL/$emailUser";
      final headers = {
        'Authorization': 'Bearer $token',
      };
      try {
        print(uri);
        var response = await http.get(
            Uri.parse(uri),headers: headers
        );
        debugPrint("response.statusCode for list groups from user ${response.statusCode}");
        debugPrint("response.body for list groups from user ${response.body}");

        if (response.statusCode == 200) {

         // var data = json.decode(response.body);

          List<String> groups = response.body.split(',');
          return groups;
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