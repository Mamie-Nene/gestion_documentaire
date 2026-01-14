import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/src/methods/service.dart';
import '/src/utils/consts/routes/app_routes_name.dart';
import '/src/utils/variable/global_variable.dart';



class TokenInterceptor extends InterceptorContract {

  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    print('----- Request Interceptor -----');
    print(request.toString());
    print(request.headers.toString());
    //verifier si le token est expiré ou pas
    final isTokenExpired = await UtilsService.isTokenExpired();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (isTokenExpired) {

      prefs.remove('token');
      prefs.remove('email');

      navigatorKey.currentState?.pushNamedAndRemoveUntil(AppRoutesName.loginPage,(Route<dynamic> route) => false,);


      // Afficher un SnackBar pour informer l'utilisateur
      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          backgroundColor: const Color.fromARGB(255, 243, 200, 230),
          content: Row(
            children: [
              Expanded(
                child: Text(
                  "Votre session a expiré. Veuillez vous reconnecter.",
                  softWrap: true,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      );
    }
    return request;
  }

  @override
  Future<BaseResponse> interceptResponse({
    required BaseResponse response,
  }) async {
    // print('----- Response Interceptor -----');
    // print('Code: ${response.statusCode}');

    if (response is Response) {
      try {
        // Décodage en UTF-8
        // print('Response body : ${response.body.toString()}');
        if (response.bodyBytes.isNotEmpty) {
          final decodedBody = utf8.decode(response.bodyBytes);

          final newResponse = Response(
            decodedBody,
            response.statusCode,
            headers: response.headers,
            request: response.request,
            isRedirect: response.isRedirect,
            persistentConnection: response.persistentConnection,
            reasonPhrase: response.reasonPhrase,
          );

          return newResponse;
        }
      } catch (e) {
        print("Erreur de décodage UTF-8: $e");
      }
    }

    return response;
  }
}