package com.example.complex_app.services

import com.example.complex_app.models.Comment
import kotlin.random.Random

object MockCommentService {
    private val comments = List(10000) {
        Comment(
            id = it.toString(),
            bookId = (it % 1000).toString(),
            userId = (it % 100).toString(),
            content = "Comment $it on Book ${(it % 1000)}",
            timestamp = System.currentTimeMillis() - Random.nextLong(0, 10000000)
        )
    }
    fun getCommentsForBook(bookId: String): List<Comment> = comments.filter { it.bookId == bookId }
    fun addComment(comment: Comment) { /* no-op for mock */ }
}
