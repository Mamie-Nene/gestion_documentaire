import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gestion_documentaire/src/domain/remote/iboard/UserAssignmentGroup.dart';
import 'package:gestion_documentaire/src/utils/api/api_url_digidocs.dart';
import 'package:gestion_documentaire/src/utils/api/api_url_iboard.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/intercepted_http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/src/domain/remote/UserInfo.dart';
import '/src/methods/token_interceptor.dart';
import '/src/utils/variable/global_variable.dart';
import '/src/utils/consts/routes/app_routes_name.dart';
import '/src/utils/consts/app_specifications/all_directories.dart';


class AuthApi{

  loginRequest(BuildContext context,String email, String password, bool isForIboard) async {

    try {
      var URL ;
      if(!isForIboard) {
        URL = ApiUrlDigidocs().getLoginUrl;
      }
        else {
        URL = ApiUrlIboard().getLoginUrl;
      }
        print(URL);
        print(email);
        print(password);
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
      debugPrint("response.statusCode for login isForIboard : $isForIboard ${response.statusCode}");
      debugPrint("response.body for login isForIboard : $isForIboard ${response.body}");

      if (response.statusCode == 200) {

        print(response.body);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var data = json.decode(response.body);
        String token = data['token'];
        String id = data['id'];

        prefs.setString("token", token);
        prefs.setString("id", id);
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

  Future<List<UserAssignmentGroup>> getGroupBelongingToUser( String URL) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    String? id = prefs.getString("id");
    final http = InterceptedHttp.build(interceptors: [TokenInterceptor()]);
    List<UserAssignmentGroup> userAssignments=[];
    if(token==null)
    {
      globalResponseMessage.errorMessage(AppText.NO_TOKEN_GETTED);
      return [];
    }

      var uri = "$URL/$id";
      final headers = {
        'Authorization': 'Bearer $token',
      };
        print(uri);
        var response = await http.get(
            Uri.parse(uri),headers: headers
        );
        debugPrint("response.statusCode for list groups from user ${response.statusCode}");
        debugPrint("response.body for list groups from user ${response.body}");

        if (response.statusCode == 200) {

          List data = json.decode(response.body);
          if (data.isEmpty) {
            return userAssignments;
          }
          userAssignments = data.map((e) => UserAssignmentGroup.fromJson(e)).toList();
          return userAssignments;
        }

        else  {
          print(response.statusCode);
          globalResponseMessage.errorMessage("Une Erreur est survenue!");
          return [];
        }
      }

}