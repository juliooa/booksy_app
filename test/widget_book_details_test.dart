import 'package:booksy_app/book_details/book_details_screen.dart';
import 'package:booksy_app/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('BookDetails cambio botón al agregar a estante',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      BlocProvider(
        create: (_) => BookshelfBloc(BookshelfState([])),
        child: const Directionality(
          child: BookActionsWidget('fake-id'),
          textDirection: TextDirection.ltr,
        ),
      ),
    );
    var buttonFinder = find.byType(ElevatedButton);
    expect(buttonFinder, findsOneWidget);

    await tester.tap(buttonFinder);
    await tester.pump();
    expect(find.text('Quitar de Mi Estante'), findsOneWidget);

    await tester.tap(buttonFinder);
    await tester.pump();
    expect(find.text('Agregar a Mi Estante'), findsOneWidget);
  });
}
