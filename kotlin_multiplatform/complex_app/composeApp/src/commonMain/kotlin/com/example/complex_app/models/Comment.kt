package com.example.complex_app.models

import kotlinx.serialization.Serializable

@Serializable
data class Comment(
    val id: String,
    val bookId: String,
    val userId: String,
    val content: String,
    val timestamp: Long
)
