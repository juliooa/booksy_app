import 'package:booksy_app/services/books_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          TextFormField(
            controller: titleFieldController,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Título',
            ),
          ),
          TextFormField(
            controller: authorFieldController,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Autor',
            ),
          ),
          TextFormField(
            controller: summaryFieldController,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Resumen',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _saveBook();
            },
            child: Text("Guardar"),
          ),
        ]),
      ),
    );
  }

  void _saveBook() {
    var title = titleFieldController.text;
    var author = authorFieldController.text;
    var summary = summaryFieldController.text;

    BooksService().saveBook(title, author, summary);
  }
}
