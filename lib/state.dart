import 'package:flutter_bloc/flutter_bloc.dart';

class BookshelfState {
  List<int> bookIds;
  BookshelfState(this.bookIds);
}

abstract class BookshelfEvent {
  const BookshelfEvent();
}

class AddBookToBookshelf extends BookshelfEvent {
  final int bookId;
  const AddBookToBookshelf(this.bookId);
}

class RemoveBookFromBookshelf extends BookshelfEvent {
  final int bookId;
  const RemoveBookFromBookshelf(this.bookId);
}

class BookshelfBloc extends Bloc<BookshelfEvent, BookshelfState> {
  BookshelfBloc(BookshelfState initialState) : super(initialState) {
    on<AddBookToBookshelf>((event, emit) {
      state.bookIds.add(event.bookId);
      emit(BookshelfState(state.bookIds));
    });
    on<RemoveBookFromBookshelf>((event, emit) {
      state.bookIds.remove(event.bookId);
      emit(BookshelfState(state.bookIds));
    });
  }
}
