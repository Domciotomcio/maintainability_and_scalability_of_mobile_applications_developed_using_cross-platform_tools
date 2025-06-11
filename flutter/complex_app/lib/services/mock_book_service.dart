import '../models/book.dart';

class MockBookService {
  static final List<Book> _books = List.generate(
    10000,
    (i) => Book(
      id: '${i + 1}',
      title: 'Book Title ${i + 1}',
      author: 'Author ${i % 100 + 1}',
      description: 'Description for Book ${i + 1}',
    ),
  );

  static List<Book> getBooks() => _books;
  static Book? getBookById(String id) =>
      _books.firstWhere((b) => b.id == id, orElse: () => _books[0]);
}
