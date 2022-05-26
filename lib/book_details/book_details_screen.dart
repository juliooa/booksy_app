import 'package:booksy_app/model/book.dart';
import 'package:booksy_app/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../utils.dart';

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

class BookActionsWidget extends StatefulWidget {
  final String bookId;
  const BookActionsWidget(this.bookId, {Key? key}) : super(key: key);

  @override
  State<BookActionsWidget> createState() => _BookActionsWidgetState();
}

class _BookActionsWidgetState extends State<BookActionsWidget> {
  static const String ebookSimpleSKU = "ebook_tier_1";

  bool _canPurchase = false;
  ProductDetails? _productDetails;
  bool _purchased = false;

  @override
  void initState() {
    getIAPproducts();
    listenForPurchases();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookshelfBloc, BookshelfState>(
        builder: (context, bookshelfState) {
      var action = () => _addToBookshelf(context, widget.bookId);
      var label = "Agregar a Mi Estante";
      var color = Colors.green;
      if (bookshelfState.bookIds.contains(widget.bookId)) {
        action = () => _removeFromBookshelf(context, widget.bookId);
        label = "Quitar de Mi Estante";
        color = Colors.amber;
      }
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: action,
            child: Text(label),
            style: ElevatedButton.styleFrom(primary: color),
          ),
          ElevatedButton(
            onPressed: _canPurchaseBook(),
            child:
                Text(_purchased ? "Ya compraste este libro" : "Comprar Ebook"),
            style: ElevatedButton.styleFrom(primary: Colors.purpleAccent),
          )
        ],
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

  void buyEbook(String bookId) {
    var details = _productDetails;
    if (details != null) {
      PurchaseParam purchaseParam = PurchaseParam(productDetails: details);
      InAppPurchase.instance.buyConsumable(purchaseParam: purchaseParam);
    }
  }

  void getIAPproducts() async {
    final bool available = await InAppPurchase.instance.isAvailable();
    if (!available) {
      //TODO El dispositivo no tiene disponible Google Play
      // para hacer compras, informar error y retornar.
      return;
    }

    Set<String> productIds = <String>{ebookSimpleSKU};
    var productsDetailsResponse =
        await InAppPurchase.instance.queryProductDetails(productIds);

    if (productsDetailsResponse.notFoundIDs.isNotEmpty) {
      // TODO No se encuentra el id de producto que buscamos,
      // revisar que esté correctamente escrito el id, y que el iap
      // esté activado en la consola de Google Play Developers
    } else {
      for (ProductDetails productDetails
          in productsDetailsResponse.productDetails) {
        if (productDetails.id == ebookSimpleSKU) {
          setState(() {
            _canPurchase = true;
            _productDetails = productDetails;
          });
        }
      }
    }
  }

  void listenForPurchases() {
    Stream purchasesStream = InAppPurchase.instance.purchaseStream;
    purchasesStream.listen((purchaseDetailsList) {
      _handlePurchases(purchaseDetailsList);
    });
  }

  void _handlePurchases(List<PurchaseDetails> purchaseDetailsList) {
    for (var purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        //TODO la compra está pendiente de ser pagada
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          _showError(purchaseDetails.error);
        } else if (purchaseDetails.status == PurchaseStatus.purchased) {
          // TODO es recomendable validar la compra con nuestro propio servidor
          // que el usuario le corresponde dicha compra y el producto está disponible.

          setState(() {
            _purchased = true;
            _showDialog(
                "Compra exitosa!", "Disfruta tu libro, gracias por tu compra");
          });
        }
      }
    }
  }

  VoidCallback? _canPurchaseBook() {
    if (!_purchased && _canPurchase) {
      return () {
        buyEbook(widget.bookId);
      };
    }
    return null;
  }

  void _showError(IAPError? error) {
    String errorText = error != null ? error.message : "Error desconocido";
    _showDialog(
        "Error", "Ocurrió un error al realizar tu compra. Error:" + errorText);
  }

  void _showDialog(String title, String body) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text(title),
              content: Text(body),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancelar'),
                  child: const Text('Ok'),
                ),
              ],
            ));
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
      width: 170,
      child: Image(image: getImageWidget(_coverUrl)),
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
