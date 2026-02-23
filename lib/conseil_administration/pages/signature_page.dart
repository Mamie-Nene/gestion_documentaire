import 'package:signature/signature.dart';
import 'package:flutter/material.dart';

class SignaturePage extends StatelessWidget {
  final SignatureController controller = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Signature")),
      body: Column(
        children: [
          Expanded(
            child: Signature(
              controller: controller,
              backgroundColor: Colors.grey[200]!,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: controller.clear,
                child: const Text("Effacer"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text("Valider"),
              )
            ],
          )
        ],
      ),
    );
  }
}
