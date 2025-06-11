import 'package:flutter/material.dart';
import '../services/mock_book_service.dart';
import '../services/mock_comment_service.dart';
import '../models/comment.dart';

class BookDetailsView extends StatelessWidget {
  const BookDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final String bookId =
        ModalRoute.of(context)?.settings.arguments as String? ?? '1';
    final book = MockBookService.getBookById(bookId);
    if (book == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Book Details'),
          leading: Navigator.canPop(context)
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  tooltip: 'Back',
                  onPressed: () => Navigator.maybePop(context),
                )
              : null,
        ),
        body: const Center(child: Text('Book not found.')),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Details'),
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                tooltip: 'Back',
                onPressed: () => Navigator.maybePop(context),
              )
            : null,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 40,
                child: Text(
                  book.title[0],
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              book.title,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.person, size: 20),
                const SizedBox(width: 8),
                Text(
                  book.author,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              book.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.bookmark_add_outlined),
                  label: const Text('Add to My Books'),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Added "${book.title}" to My Books (mock)',
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 16),
                OutlinedButton.icon(
                  icon: const Icon(Icons.share),
                  label: const Text('Share'),
                  onPressed: () {
                    // Placeholder for share functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Share "${book.title}" (mock)')),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 40),
            Text('Comments', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            _CommentsSection(bookId: book.id),
          ],
        ),
      ),
    );
  }
}

class _CommentsSection extends StatefulWidget {
  final String bookId;
  const _CommentsSection({required this.bookId});

  @override
  State<_CommentsSection> createState() => _CommentsSectionState();
}

class _CommentsSectionState extends State<_CommentsSection> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final comments = MockCommentService.getCommentsForBook(widget.bookId);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: 'Add a comment...',
                  border: OutlineInputBorder(),
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                final text = _controller.text.trim();
                if (text.isNotEmpty) {
                  MockCommentService.addComment(
                    Comment(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      bookId: widget.bookId,
                      author: 'You',
                      content: text,
                      createdAt: DateTime.now(),
                    ),
                  );
                  setState(() {
                    _controller.clear();
                  });
                }
              },
              child: const Text('Post'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        comments.isEmpty
            ? const Text('No comments yet.')
            : ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: comments.length,
                separatorBuilder: (context, i) => const Divider(height: 1),
                itemBuilder: (context, i) {
                  final c = comments[i];
                  return ListTile(
                    leading: CircleAvatar(child: Text(c.author[0])),
                    title: Text(c.author),
                    subtitle: Text(c.content),
                    trailing: Text(
                      '${c.createdAt.year}-${c.createdAt.month.toString().padLeft(2, '0')}-${c.createdAt.day.toString().padLeft(2, '0')}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  );
                },
              ),
      ],
    );
  }
}
