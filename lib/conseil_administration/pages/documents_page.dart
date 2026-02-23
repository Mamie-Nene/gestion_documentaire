
import 'package:flutter/material.dart';
class DocumentsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Documents")),
      body: ListView(
        children: const [
          ListTile(
            leading: Icon(Icons.picture_as_pdf),
            title: Text("Rapport.pdf"),
          ),
          ListTile(
            leading: Icon(Icons.insert_drive_file),
            title: Text("Budget.docx"),
          ),
        ],
      ),
    );
  }
}
