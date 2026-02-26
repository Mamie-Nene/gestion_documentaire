import 'package:flutter/material.dart';

class ReportPage extends StatelessWidget {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Compte rendu")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: TextField(
          controller: controller,
          maxLines: 20,
          decoration: const InputDecoration(
            hintText: "Rédiger le compte rendu...",
            border: OutlineInputBorder(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text("Générer PDF"),
        icon: const Icon(Icons.picture_as_pdf),
        onPressed: () {},
      ),
    );
  }
}
