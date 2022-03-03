import 'package:booksy_app/add_book/add_book_screen.dart';
import 'package:booksy_app/book_details/book_details_screen.dart';
import 'package:booksy_app/model/book.dart';
import 'package:booksy_app/services/books_service.dart';
import 'package:booksy_app/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookshelfScreen extends StatelessWidget {
  const BookshelfScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookshelfBloc, BookshelfState>(
        builder: (context, bookshelfState) {
      var emptyListWidget = Center(
        child: Text(
          "Aún no tienes ningún libro en tu estante.",
          style: Theme.of(context).textTheme.headline4,
          textAlign: TextAlign.center,
        ),
      );

      var mainWidget = bookshelfState.bookIds.isEmpty
          ? emptyListWidget
          : MyBooksGrid(bookshelfState.bookIds);

      return Column(
        children: [
          Expanded(child: mainWidget),
          ElevatedButton(
            onPressed: () {
              _navigateToAddNewBookScreen(context);
            },
            child: const Text("Agregar nuevo libro"),
          ),
        ],
      );
    });
  }

  void _navigateToAddNewBookScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddBookScreen(),
      ),
    );
  }
}

class MyBooksGrid extends StatelessWidget {
  final List<String> bookIds;
  const MyBooksGrid(this.bookIds, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.7,
          ),
          itemCount: bookIds.length,
          itemBuilder: (context, index) {
            return BookCoverItem(bookIds[index]);
          }),
    );
  }
}

class BookCoverItem extends StatefulWidget {
  final String _bookId;

  const BookCoverItem(this._bookId, {Key? key}) : super(key: key);

  @override
  State<BookCoverItem> createState() => _BookCoverItemState();
}

class _BookCoverItemState extends State<BookCoverItem> {
  Book? _book;

  @override
  void initState() {
    super.initState();
    _getBook(widget._bookId);
  }

  void _getBook(String bookId) async {
    var book = await BooksService().getBook(bookId);
    setState(() {
      _book = book;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_book == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return InkWell(
      onTap: () {
        _openBookDetails(_book!, context);
      },
      child: Ink.image(fit: BoxFit.fill, image: AssetImage(_book!.coverUrl)),
    );
  }

  _openBookDetails(Book book, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookDetailsScreen(book),
      ),
    );
  }
}
