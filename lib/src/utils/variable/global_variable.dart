import 'package:flutter/material.dart';

import '/src/methods/app_response_messages.dart';

AppResponseMessage globalResponseMessage = AppResponseMessage();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
// Définir une GlobalKey pour le ScaffoldMessenger
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
GlobalKey<ScaffoldMessengerState>();

