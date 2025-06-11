package com.example.complex_app.views

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import com.example.complex_app.services.MockBookService

@Composable
fun UserView(userId: String, onBookSelected: (String) -> Unit, modifier: Modifier) {
    val books = remember { MockBookService.getBooksByUser(userId) }
    Column(modifier = modifier.padding(16.dp)) {
        Text("My Books", style = MaterialTheme.typography.titleLarge)
        // TODO: Add accessibility contentDescription
        LazyColumn(modifier = Modifier.fillMaxSize()) {
            items(books.size) { idx ->
                val book = books[idx]
                Card(
                    onClick = { onBookSelected(book.id) },
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(vertical = 4.dp),
                    // TODO: Add contentDescription for accessibility
                ) {
                    Column(Modifier.padding(12.dp)) {
                        Text(book.title, style = MaterialTheme.typography.titleMedium)
                        Text("by ${book.author}", style = MaterialTheme.typography.bodyMedium)
                    }
                }
            }
        }
        // TODO: Add snackbar for actions (e.g., book selected)
    }
}
