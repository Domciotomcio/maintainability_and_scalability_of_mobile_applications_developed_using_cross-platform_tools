import 'package:flutter/material.dart';
import '../services/mock_book_service.dart';

class BookListView extends StatefulWidget {
  const BookListView({super.key});

  @override
  State<BookListView> createState() => _BookListViewState();
}

class _BookListViewState extends State<BookListView> {
  String query = '';
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final books = MockBookService.getBooks()
        .where(
          (b) =>
              b.title.toLowerCase().contains(query.toLowerCase()) ||
              b.author.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Books'),
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search by title or author',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => setState(() => query = ''),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (val) => setState(() => query = val),
            ),
          ),
          Expanded(
            child: books.isEmpty
                ? const Center(child: Text('No books found.'))
                : Scrollbar(
                    controller: _scrollController,
                    thumbVisibility: true,
                    child: ListView.separated(
                      controller: _scrollController,
                      itemCount: books.length,
                      separatorBuilder: (context, index) =>
                          const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final book = books[index];
                        return ListTile(
                          leading: CircleAvatar(child: Text(book.title[0])),
                          title: Text(
                            book.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            book.author,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                          ),
                          onTap: () => Navigator.pushNamed(
                            context,
                            '/details',
                            arguments: book.id,
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
