import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';

import '/src/domain/remote/Document.dart';
import '/src/utils/variable/global_variable.dart';
import '/src/utils/consts/routes/app_routes_name.dart';
import '/src/utils/consts/app_specifications/all_directories.dart';


class DocumentApi{

  getDetailDocument( String URL, String idDocument) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    if(token==null)
    {
      globalResponseMessage.errorMessage(AppText.NO_TOKEN_GETTED);
      return;
    }
    else {
      var uri = "$URL/$idDocument";
      final headers = {
        'Authorization': 'Bearer $token',
      };
      try {
        print(uri);
        var response = await http.get(
            Uri.parse(uri),headers: headers
        );
        debugPrint("response.statusCode for getDetailCandidat ${response.statusCode}");
        debugPrint("response.body for getDetailCandidat ${response.body}");

        if (response.statusCode == 200) {

          var data = json.decode(response.body);

          Document document =Document.fromJson(data);
          return document;
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

  getListDocuments( String URL) async {
    List<Document> gieDocs = [] ;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

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
        },
      );

      debugPrint("response.statusCode for get gieDocs ${response.statusCode}");
      debugPrint("response.body for get gieDocs ${response.body}");


      if (response.statusCode == 200) {

        List data = json.decode(response.body);
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
  voirDocuments( String URL,String fileName) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

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
        debugPrint("response.body for view doc ${response.body}");

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
}