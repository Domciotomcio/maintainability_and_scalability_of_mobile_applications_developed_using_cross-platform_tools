import 'package:flutter/material.dart';
import 'views/book_list_view.dart' show BookListView;
import 'views/book_details_view.dart' show BookDetailsView;
import 'views/book_search_view.dart' show BookSearchView;
import 'views/user_books_view.dart' show UserBooksView;
import 'views/settings_view.dart' show SettingsView;

void main() {
  runApp(const ComplexApp());
}

class ComplexApp extends StatelessWidget {
  const ComplexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Complex Book App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const BookListView(),
        '/details': (context) => const BookDetailsView(),
        '/user': (context) => const UserBooksView(),
        '/settings': (context) => const SettingsView(),
      },
    );
  }
}
