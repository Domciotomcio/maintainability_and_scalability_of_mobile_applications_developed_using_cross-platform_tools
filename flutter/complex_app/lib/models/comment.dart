class Comment {
  final String id;
  final String bookId;
  final String author;
  final String content;
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.bookId,
    required this.author,
    required this.content,
    required this.createdAt,
  });
}
