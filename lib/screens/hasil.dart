import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import untuk format angka

class HasilSplitBillScreen extends StatelessWidget {
  final Map<String, double> userTotals;

  const HasilSplitBillScreen({super.key, required this.userTotals});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hasil Split Bill")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text("Total yang harus dibayar:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 10),
            ...userTotals.entries.map((entry) => ListTile(
              title: Text(entry.key, style: const TextStyle(fontSize: 16)),
              trailing: Text(
                "Rp ${NumberFormat("#,##0", "id_ID").format(entry.value)}",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
