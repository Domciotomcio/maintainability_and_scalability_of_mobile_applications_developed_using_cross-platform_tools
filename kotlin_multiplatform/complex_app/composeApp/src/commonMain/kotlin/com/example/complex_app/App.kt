package com.example.complex_app

import androidx.compose.animation.AnimatedVisibility
import androidx.compose.foundation.Image
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.safeContentPadding
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import org.jetbrains.compose.resources.painterResource
import org.jetbrains.compose.ui.tooling.preview.Preview

import complex_app.composeapp.generated.resources.Res
import complex_app.composeapp.generated.resources.compose_multiplatform
import com.example.complex_app.views.*

sealed class Screen {
    object BookList : Screen()
    data class BookDetail(val bookId: String) : Screen()
    object User : Screen()
    object Settings : Screen()
}

@Composable
@Preview
fun App() {
    MaterialTheme {
        var currentScreen by remember { mutableStateOf<Screen>(Screen.BookList) }
        Scaffold(
            topBar = {
                TopAppBar(
                    title = { Text("Book App") },
                    navigationIcon = if (currentScreen != Screen.BookList) {
                        {
                            IconButton(onClick = { currentScreen = Screen.BookList }) {
                                Icon(Icons.Default.ArrowBack, contentDescription = "Back")
                            }
                        }
                    } else null,
                    actions = {
                        IconButton(onClick = { currentScreen = Screen.User }) {
                            Icon(Icons.Default.Person, contentDescription = "User")
                        }
                        IconButton(onClick = { currentScreen = Screen.Settings }) {
                            Icon(Icons.Default.Settings, contentDescription = "Settings")
                        }
                    }
                )
            }
        ) { padding ->
            when (val screen = currentScreen) {
                is Screen.BookList -> BookListView(
                    onBookSelected = { id -> currentScreen = Screen.BookDetail(id) },
                    modifier = Modifier.fillMaxSize().padding(padding)
                )
                is Screen.BookDetail -> BookDetailView(
                    bookId = screen.bookId,
                    onBack = { currentScreen = Screen.BookList },
                    modifier = Modifier.fillMaxSize().padding(padding)
                )
                is Screen.User -> UserView(
                    userId = "0", // TODO: Replace with actual user id
                    onBookSelected = { id -> currentScreen = Screen.BookDetail(id) },
                    modifier = Modifier.fillMaxSize().padding(padding)
                )
                is Screen.Settings -> SettingsView(
                    modifier = Modifier.fillMaxSize().padding(padding)
                )
            }
        }
    }
}