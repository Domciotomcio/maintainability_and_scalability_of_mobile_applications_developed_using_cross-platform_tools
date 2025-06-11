import 'package:flutter/material.dart';
import '../services/mock_book_service.dart';

class UserBooksView extends StatelessWidget {
  const UserBooksView({super.key});

  @override
  Widget build(BuildContext context) {
    final books = MockBookService.getBooks();
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Books'),
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                tooltip: 'Back',
                onPressed: () => Navigator.maybePop(context),
              )
            : null,
        actions: [
          IconButton(
            icon: const Icon(Icons.book),
            tooltip: 'Books',
            onPressed: () => Navigator.pushReplacementNamed(context, '/'),
          ),
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'My Books',
            onPressed: () => Navigator.pushReplacementNamed(context, '/user'),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () =>
                Navigator.pushReplacementNamed(context, '/settings'),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          return ListTile(
            title: Text(book.title),
            subtitle: Text('by ${book.author}'),
            onTap: () {
              // Navigate to book details
            },
          );
        },
      ),
    );
  }
}
