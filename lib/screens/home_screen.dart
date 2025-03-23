import 'package:flutter/material.dart';
import '../screens/upload_receipt_screen.dart';
import '../widgets/primary_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Patungan")),
      body: Center(
        child: PrimaryButton(
          text: "Mulai",
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const UploadReceiptScreen()),
            );
          },
        ),
      ),
    );
  }
}
