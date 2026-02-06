//import 'dart:nativewrappers/_internal/vm/lib/typed_data_patch.dart';
import 'dart:typed_data';

import 'package:flutter/material.dart';

//import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:gestion_documentaire/src/services/secure_Screen.dart';
import 'package:http_interceptor/http/intercepted_http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';


import '/src/methods/token_interceptor.dart';
import '/src/utils/api/api_url.dart';

/*Tell me if you want:
⏱ Auto-close document after X seconds
🔄 Re-authentication when app resumes
🧼 Clear file from memory on background
🔥 Watermark with user name / date
🧠 BLoC / Riverpod version
You’re building something serious — happy to harden it with you 💪

Auto-close document on app background
Add dynamic watermark
Lock screen again on app resume
Wrap everything in BLoC / Riverpod

*/
class SecureDocumentViewer extends StatefulWidget {
  final String fileName;

  const SecureDocumentViewer({
    super.key,
    required this.fileName,
  });

  @override
  State<SecureDocumentViewer> createState() => _SecureDocumentViewerState();
}

class _SecureDocumentViewerState extends State<SecureDocumentViewer> {
  Uint8List? fileBytes;
  bool loading = true;

  @override
  void initState() {
    super.initState();
   // _secureScreen();
    SecureScreen.enable();
    _loadFile(ApiUrl().voirDocumentUrl);
  }

 /* void _secureScreen() {
    FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }*/

  Future<void> _loadFile(String URL) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    final http = InterceptedHttp.build(interceptors: [TokenInterceptor()]);
    final uri = "$URL?fileName=${widget.fileName}";
    final response = await http.get(
      Uri.parse(uri),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      setState(() {
       // fileBytes = response.bodyBytes;
        fileBytes = Uint8List.fromList(response.bodyBytes);

        loading = false;
      });
    }
    else {
      debugPrint("Impossible d'ouvrir le document");
    }
  }

  @override
  void dispose() {
    SecureScreen.disable();
   // FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
    super.dispose();
  }

  /*window.setFlags(
    WindowManager.LayoutParams.FLAG_SECURE,
    WindowManager.LayoutParams.FLAG_SECURE
)*/
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      Navigator.of(context).pop(); // auto-close document
    }
  }
  @override
  void didChangeDependencies() {
    SecureScreen.enable();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title:  Text(widget.fileName)),
        body: fileBytes == null
            ? const Center(child: CircularProgressIndicator())
            : SfPdfViewer.memory(fileBytes!)
    );
  }

 /* import 'dart:ui'; for ios

  Widget build(BuildContext context) {
    return Stack(
      children: [
        _documentView(),
        if (isScreenCaptured)
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.black),
          ),
      ],
    );
  }*/

}
