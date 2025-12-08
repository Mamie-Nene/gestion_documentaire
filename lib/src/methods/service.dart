import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UtilsService{
  static Future<bool> isTokenExpired() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final token = prefs.getString("token");
    bool hasExpired = JwtDecoder.isExpired(token!);

    return hasExpired;
  }
}