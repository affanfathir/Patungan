import 'package:flutter/material.dart';
import 'assign_items_screen.dart';

class UploadReceiptScreen extends StatefulWidget {
  const UploadReceiptScreen({super.key});

  @override
  _UploadReceiptScreenState createState() => _UploadReceiptScreenState();
}

class _UploadReceiptScreenState extends State<UploadReceiptScreen> {
  final List<Map<String, dynamic>> items = [
    {"name": "", "quantity": 1, "price": 0.0},
  ];

  void _addItem() {
    setState(() {
      items.add({"name": "", "quantity": 1, "price": 0.0});
    });
  }

  void _submitItems() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AssignItemsScreen(items: items),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Item")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          TextField(
                            decoration: const InputDecoration(labelText: "Nama Menu"),
                            onChanged: (value) => items[index]["name"] = value,
                          ),
                          TextField(
                            decoration: const InputDecoration(labelText: "Jumlah"),
                            keyboardType: TextInputType.number,
                            onChanged: (value) => items[index]["quantity"] = int.tryParse(value) ?? 1,
                          ),
                          TextField(
                            decoration: const InputDecoration(labelText: "Harga (Rp)"),
                            keyboardType: TextInputType.number,
                            onChanged: (value) => items[index]["price"] = double.tryParse(value) ?? 0.0,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _addItem,
              child: const Text("Tambah Menu"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _submitItems,
              child: const Text("Lanjutkan"),
            ),
          ],
        ),
      ),
    );
  }
}
