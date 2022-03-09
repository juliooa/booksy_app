import 'package:booksy_app/bookshelf/bookshelf_screen.dart';
import 'package:booksy_app/categories/categories_screen.dart';
import 'package:booksy_app/home/home_screen.dart';
import 'package:booksy_app/state.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  MobileAds.instance.initialize();
  runApp(const BooksyApp());
}

class BooksyApp extends StatelessWidget {
  const BooksyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => BookshelfBloc(BookshelfState([])),
        child: MaterialApp(
          title: 'Booksy',
          theme: ThemeData(
            primarySwatch: Colors.purple,
          ),
          home: const BottomNavigationWidget(),
        ));
  }
}

class BottomNavigationWidget extends StatefulWidget {
  const BottomNavigationWidget({Key? key}) : super(key: key);

  @override
  State<BottomNavigationWidget> createState() => _BottomNavigationWidgetState();
}

class _BottomNavigationWidgetState extends State<BottomNavigationWidget> {
  int _selectedIndex = 0;

  static final List<Widget> _sections = [
    const HomeScreen(),
    const CategoriesScreen(),
    BookshelfScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Booksy"),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_library),
            label: 'Biblioteca',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_stories),
            label: 'Mi Estante',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      body: _sections[_selectedIndex],
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
