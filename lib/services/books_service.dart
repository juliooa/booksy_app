import 'dart:io';

import 'package:booksy_app/model/book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BooksService {
  final booksRef = FirebaseFirestore.instance.collection('books').withConverter(
        fromFirestore: (snapshot, _) =>
            Book.fromJson(snapshot.id, snapshot.data()!),
        toFirestore: (book, _) => book.toJson(),
      );

  Future<List<Book>> getLastBooks() async {
    var result = await booksRef.limit(3).get().then((value) => value);
    List<Book> books = [];
    for (var doc in result.docs) {
      books.add(doc.data());
    }
    return Future.value(books);
  }

  Future<Book> getBook(String bookId) async {
    var result = await booksRef.doc(bookId).get().then((value) => value);
    if (result.exists) {
      return Future.value(result.data());
    }
    throw const HttpException("Book not found");
  }
}
