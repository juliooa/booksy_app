import 'dart:io';

import 'package:flutter/material.dart';

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key? key, required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Foto')),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.black,
              child: Center(
                child: Image.file(
                  File(imagePath),
                ),
              ),
            ),
          ),
          Container(
            color: Colors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, imagePath);
                  },
                  child: const Text("Aceptar"),
                ),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Tomar otra")),
              ],
            ),
          )
        ],
      ),
    );
  }
}
