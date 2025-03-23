import 'package:flutter/material.dart';

class ItemSelector extends StatelessWidget {
  final String item;
  final Function(String) onSelected;

  const ItemSelector({super.key, required this.item, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item),
      trailing: DropdownButton<String>(
        items: ["User 1", "User 2"].map((String user) {
          return DropdownMenuItem(value: user, child: Text(user));
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            onSelected(value);
          }
        },
      ),
    );
  }
}
