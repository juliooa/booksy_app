import 'dart:io';

import 'package:booksy_app/add_book/take_picture_screen.dart';
import 'package:booksy_app/services/books_service.dart';
import 'package:booksy_app/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddBookScreen extends StatelessWidget {
  const AddBookScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Agregar nuevo libro"),
        ),
        body: const AddBookForm());
  }
}

class AddBookForm extends StatefulWidget {
  const AddBookForm({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AddBookFormState();
  }
}

class AddBookFormState extends State<AddBookForm> {
  final titleFieldController = TextEditingController();
  final authorFieldController = TextEditingController();
  final summaryFieldController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _savingBook = false;

  String? _imagePath;

  @override
  Widget build(BuildContext context) {
    if (_savingBook) {
      return const Center(child: CircularProgressIndicator());
    }
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: [
            TextFormField(
              controller: titleFieldController,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Título',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Por favor ingresa el título";
                }
                return null;
              },
            ),
            TextFormField(
              controller: authorFieldController,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Autor',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Por favor ingresa el autor";
                }
                return null;
              },
            ),
            TextFormField(
              controller: summaryFieldController,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Resumen',
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              child: GestureDetector(
                onTap: () {
                  _navigateTakePictureScreen(context);
                },
                child: SizedBox(
                  child: _getImageWidget(context),
                  width: 150,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _saveBook(context);
                }
              },
              child: Text("Guardar"),
            ),
          ]),
        ),
      ),
    );
  }

  void _saveBook(BuildContext context) async {
    var title = titleFieldController.text;
    var author = authorFieldController.text;
    var summary = summaryFieldController.text;

    setState(() {
      _savingBook = true;
    });
    var newBookId = await BooksService().saveBook(title, author, summary);
    if (_imagePath != null) {
      String imageUrl =
          await BooksService().uploadBookCover(_imagePath!, newBookId);
      await BooksService().updateCoverBook(newBookId, imageUrl);
    }

    var bookshelfBloc = context.read<BookshelfBloc>();
    bookshelfBloc.add(AddBookToBookshelf(newBookId));

    Navigator.pop(context);
  }

  void _navigateTakePictureScreen(BuildContext context) async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TakePictureScreen(),
      ),
    );

    setState(() {
      _imagePath = result;
    });
  }

  Widget _getImageWidget(BuildContext context) {
    if (_imagePath == null) {
      return Image.asset('assets/images/take_photo.png');
    } else {
      return Image.file(File(_imagePath!));
    }
  }
}
