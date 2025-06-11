package com.example.complex_app.services

import com.example.complex_app.models.Book

object MockBookService {
    private val books = List(10000) {
        Book(
            id = it.toString(),
            title = "Book $it",
            author = "Author ${it % 100}",
            description = "Description for Book $it",
            userId = (it % 100).toString()
        )
    }
    fun getBooks(query: String? = null): List<Book> =
        books.filter { query == null || it.title.contains(query, true) || it.author.contains(query, true) }
    fun getBook(id: String): Book? = books.find { it.id == id }
    fun getBooksByUser(userId: String): List<Book> = books.filter { it.userId == userId }
}
