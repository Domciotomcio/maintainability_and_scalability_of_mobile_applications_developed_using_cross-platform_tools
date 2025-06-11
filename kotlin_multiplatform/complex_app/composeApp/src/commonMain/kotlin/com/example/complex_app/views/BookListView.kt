package com.example.complex_app.views

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.text.BasicTextField
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.unit.dp
import com.example.complex_app.models.Book
import com.example.complex_app.services.MockBookService
import kotlinx.coroutines.launch

@Composable
fun BookListView(onBookSelected: (String) -> Unit, modifier: Modifier) {
    var search by remember { mutableStateOf("") }
    val books = remember(search) { MockBookService.getBooks(search) }
    val snackbarHostState = remember { SnackbarHostState() }
    val coroutineScope = rememberCoroutineScope()
    Column(modifier = modifier.padding(16.dp)) {
        OutlinedTextField(
            value = search,
            onValueChange = { search = it },
            label = { Text("Search books") },
            modifier = Modifier
                .fillMaxWidth()
                .semantics { contentDescription = "Search Books Field" },
            singleLine = true
        )
        Spacer(Modifier.height(8.dp))
        LazyColumn(modifier = Modifier.fillMaxSize()) {
            items(books.size) { idx ->
                val book = books[idx]
                Card(
                    onClick = {
                        onBookSelected(book.id)
                        coroutineScope.launch {
                            snackbarHostState.showSnackbar("Selected: ${book.title}")
                        }
                    },
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(vertical = 4.dp)
                        .semantics { contentDescription = "Book: ${book.title} by ${book.author}" }
                ) {
                    Column(Modifier.padding(12.dp)) {
                        Text(book.title, style = MaterialTheme.typography.titleMedium)
                        Text("by ${book.author}", style = MaterialTheme.typography.bodyMedium)
                    }
                }
            }
        }
        SnackbarHost(hostState = snackbarHostState, modifier = Modifier.align(Alignment.CenterHorizontally))
    }
}
