package com.example.complex_app.views

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import com.example.complex_app.models.Book
import com.example.complex_app.models.Comment
import com.example.complex_app.services.MockBookService
import com.example.complex_app.services.MockCommentService
import com.example.complex_app.services.MockUserService
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.material3.SnackbarHost
import androidx.compose.material3.SnackbarHostState
import androidx.compose.runtime.rememberCoroutineScope
import kotlinx.coroutines.launch

@Composable
fun BookDetailView(bookId: String, onBack: () -> Unit, modifier: Modifier) {
    val book = remember { MockBookService.getBook(bookId) }
    val comments = remember { MockCommentService.getCommentsForBook(bookId) }
    var newComment by remember { mutableStateOf("") }
    val snackbarHostState = remember { SnackbarHostState() }
    val coroutineScope = rememberCoroutineScope()
    Column(modifier = modifier.padding(16.dp)) {
        if (book != null) {
            Text(book.title, style = MaterialTheme.typography.titleLarge, modifier = Modifier.semantics { contentDescription = "Book Title: ${book.title}" })
            Text("by ${book.author}", style = MaterialTheme.typography.bodyMedium, modifier = Modifier.semantics { contentDescription = "Book Author: ${book.author}" })
            Text(book.description, style = MaterialTheme.typography.bodySmall, modifier = Modifier.padding(vertical = 8.dp).semantics { contentDescription = "Book Description" })
            Divider()
            Text("Comments", style = MaterialTheme.typography.titleMedium, modifier = Modifier.padding(top = 8.dp).semantics { contentDescription = "Comments Section" })
            LazyColumn(modifier = Modifier.weight(1f, fill = false)) {
                items(comments.size) { idx ->
                    val comment = comments[idx]
                    val user = MockUserService.getUser(comment.userId)
                    Column(Modifier.padding(vertical = 4.dp).semantics { contentDescription = "Comment by ${user?.name ?: "User"}" }) {
                        Text(user?.name ?: "User", style = MaterialTheme.typography.labelMedium)
                        Text(comment.content, style = MaterialTheme.typography.bodySmall)
                    }
                }
            }
            OutlinedTextField(
                value = newComment,
                onValueChange = { newComment = it },
                label = { Text("Add a comment") },
                modifier = Modifier.fillMaxWidth().semantics { contentDescription = "Add Comment Field" },
                singleLine = false
            )
            Button(
                onClick = {
                    if (newComment.isNotBlank()) {
                        MockCommentService.addComment(
                            Comment(
                                id = "new", bookId = bookId, userId = "0", content = newComment, timestamp = System.currentTimeMillis()
                            )
                        )
                        newComment = ""
                        coroutineScope.launch {
                            snackbarHostState.showSnackbar("Comment posted")
                        }
                    }
                },
                modifier = Modifier.padding(top = 8.dp).semantics { contentDescription = "Post Comment Button" }
            ) {
                Text("Post")
            }
        } else {
            Text("Book not found", style = MaterialTheme.typography.titleMedium, modifier = Modifier.semantics { contentDescription = "Book Not Found" })
            Button(onClick = onBack, modifier = Modifier.padding(top = 8.dp).semantics { contentDescription = "Back Button" }) { Text("Back") }
            LaunchedEffect(Unit) {
                coroutineScope.launch {
                    snackbarHostState.showSnackbar("Book not found")
                }
            }
        }
        SnackbarHost(hostState = snackbarHostState, modifier = Modifier.align(Alignment.CenterHorizontally))
    }
}
