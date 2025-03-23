import 'package:flutter/material.dart';
import 'dart:io';

class ReceiptPreview extends StatelessWidget {
  final File? image;

  const ReceiptPreview({super.key, this.image});

  @override
  Widget build(BuildContext context) {
    return image == null
        ? const Text("Belum ada gambar")
        : Image.file(image!, width: 200, height: 200, fit: BoxFit.cover);
  }
}
