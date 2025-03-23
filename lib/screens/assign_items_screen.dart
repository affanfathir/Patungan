import 'package:flutter/material.dart';
import 'hasil.dart';

class AssignItemsScreen extends StatefulWidget {
  final List<Map<String, dynamic>> items;

  const AssignItemsScreen({super.key, required this.items});

  @override
  _AssignItemsScreenState createState() => _AssignItemsScreenState();
}

class _AssignItemsScreenState extends State<AssignItemsScreen> {
  final List<String> users = ["User 1", "User 2", "User 3"];
  late List<Map<String, int>> userItemQuantities;

  @override
  void initState() {
    super.initState();
    userItemQuantities = List.generate(
      widget.items.length,
      (_) => {for (var user in users) user: 0},
    );
  }

  void _addUser() {
    final TextEditingController _controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Tambah Peserta"),
        content: TextField(
          controller: _controller,
          decoration: const InputDecoration(hintText: "Nama Peserta"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          TextButton(
            onPressed: () {
              if (_controller.text.isNotEmpty) {
                setState(() {
                  users.add(_controller.text);
                  for (var itemQuantity in userItemQuantities) {
                    itemQuantity[_controller.text] = 0;
                  }
                });
                Navigator.pop(context);
              }
            },
            child: const Text("Tambah"),
          ),
        ],
      ),
    );
  }

  void _updateQuantity(int itemIndex, String user, int change) {
    int currentQty = userItemQuantities[itemIndex][user]!;
    int totalItemQuantity = widget.items[itemIndex]["quantity"]!;
    int assignedQty = userItemQuantities[itemIndex].values.fold(0, (sum, qty) => sum + qty);

    if (change > 0 && assignedQty >= totalItemQuantity) return;
    if (change < 0 && currentQty == 0) return;

    setState(() {
      userItemQuantities[itemIndex][user] = (currentQty + change).clamp(0, totalItemQuantity);
    });
  }

  bool _isSplitBillEnabled() {
    return userItemQuantities.any((item) => item.values.any((qty) => qty > 0));
  }

  void _submitSplitBill() {
    Map<String, double> userTotals = {for (var user in users) user: 0};

    for (int i = 0; i < widget.items.length; i++) {
      int totalQty = widget.items[i]["quantity"];
      double totalPrice = widget.items[i]["price"];
      double pricePerItem = totalPrice / totalQty;

      for (var user in users) {
        if (userItemQuantities[i][user]! > 0) {
          userTotals[user] = (userTotals[user] ?? 0) + (userItemQuantities[i][user]! * pricePerItem);
        }
      }
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HasilSplitBillScreen(userTotals: userTotals),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pilih Barang")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Daftar Peserta:", style: TextStyle(fontWeight: FontWeight.bold)),
                ElevatedButton.icon(
                  onPressed: _addUser,
                  icon: const Icon(Icons.add),
                  label: const Text("Tambah Peserta"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            Wrap(
              spacing: 8,
              children: users.map((user) {
                return Chip(
                  label: Text(user),
                  deleteIcon: const Icon(Icons.close),
                  onDeleted: () {
                    setState(() {
                      users.remove(user);
                      for (var itemQuantity in userItemQuantities) {
                        itemQuantity.remove(user);
                      }
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: widget.items.length,
                itemBuilder: (context, index) {
                  final item = widget.items[index];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  item["name"],
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                              ),
                              Text(
                                "Rp ${item["price"].toStringAsFixed(0)}",
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text("Jumlah: ${item["quantity"]}"),
                          const SizedBox(height: 10),
                          const Text("Siapa yang memesan dan berapa banyak?"),
                          Column(
                            children: users.map((user) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: userItemQuantities[index][user]! > 0,
                                        onChanged: (val) {},
                                      ),
                                      Text(user),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove, color: Colors.red),
                                        onPressed: () => _updateQuantity(index, user, -1),
                                      ),
                                      Text(
                                        "${userItemQuantities[index][user]}",
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.add, color: Colors.green),
                                        onPressed: () => _updateQuantity(index, user, 1),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            ElevatedButton(
              onPressed: _isSplitBillEnabled() ? _submitSplitBill : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text("Lihat Hasil Split Bill", style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
