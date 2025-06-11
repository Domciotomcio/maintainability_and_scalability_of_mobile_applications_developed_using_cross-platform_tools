import '../models/comment.dart';
import '../models/user.dart';

class MockCommentService {
  static final List<User> _users = List.generate(
    100,
    (i) => User(
      id: '${i + 1}',
      name: 'User${i + 1}',
      email: 'user${i + 1}@example.com',
    ),
  );

  static final List<Comment> _comments = List.generate(
    10000,
    (i) => Comment(
      id: '${i + 1}',
      bookId: '${(i % 1000) + 1}',
      author: _users[i % _users.length].name,
      content: 'This is a comment #${i + 1} for book ${(i % 1000) + 1}.',
      createdAt: DateTime.now().subtract(Duration(minutes: i)),
    ),
  );

  static List<Comment> getCommentsForBook(String bookId) =>
      _comments.where((c) => c.bookId == bookId).toList();

  static void addComment(Comment comment) {
    _comments.insert(0, comment);
  }
}
