import 'package:booksy_app/model/book.dart';
import 'package:booksy_app/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookDetailsScreen extends StatelessWidget {
  final Book _book;
  const BookDetailsScreen(this._book, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalle Libro"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            BookCoverWidget(_book.coverUrl),
            BookInfoWidget(_book.title, _book.author, _book.description),
            BookActionsWidget(_book.id),
          ],
        ),
      ),
    );
  }
}

class BookActionsWidget extends StatelessWidget {
  final String bookId;
  const BookActionsWidget(this.bookId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookshelfBloc, BookshelfState>(
        builder: (context, bookshelfState) {
      var action = () => _addToBookshelf(context, bookId);
      var label = "Agregar a Mi Estante";
      var color = Colors.green;
      if (bookshelfState.bookIds.contains(bookId)) {
        action = () => _removeFromBookshelf(context, bookId);
        label = "Quitar de Mi Estante";
        color = Colors.amber;
      }
      return ElevatedButton(
        onPressed: action,
        child: Text(label),
        style: ElevatedButton.styleFrom(primary: color),
      );
    });
  }

  void _addToBookshelf(BuildContext context, String bookId) {
    var bookshelfBloc = context.read<BookshelfBloc>();
    bookshelfBloc.add(AddBookToBookshelf(bookId));
  }

  void _removeFromBookshelf(BuildContext context, String bookId) {
    var bookshelfBloc = context.read<BookshelfBloc>();
    bookshelfBloc.add(RemoveBookFromBookshelf(bookId));
  }
}

class BookInfoWidget extends StatelessWidget {
  final String _title;
  final String _author;
  final String _description;

  const BookInfoWidget(this._title, this._author, this._description, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(children: [
        Text(_title,
            style: Theme.of(context)
                .textTheme
                .headline5!
                .copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 5),
        Text(
          _author,
          style: Theme.of(context).textTheme.headline6,
        ),
        const SizedBox(height: 20),
        Text(
          _description,
          style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 16),
        ),
      ]),
    );
  }
}

class BookCoverWidget extends StatelessWidget {
  final String _coverUrl;
  const BookCoverWidget(this._coverUrl, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20, bottom: 20),
      width: 230,
      child: Image.asset(_coverUrl),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 5,
          blurRadius: 20,
        )
      ]),
    );
  }
}
