import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/src/utils/consts/routes/app_routes_name.dart';

class SignOutMethod{

  Future signOut(BuildContext context) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('isLoggedIn');
    prefs.remove('token');
    var status = prefs.getBool('isLoggedIn') ?? false;
    print(status);
    //isUserConnected = status;
    Navigator.of(context).pushNamedAndRemoveUntil(AppRoutesName.loginPage, (Route<dynamic> route) => false);

  }

}