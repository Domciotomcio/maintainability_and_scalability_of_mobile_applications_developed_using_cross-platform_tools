package com.example.complex_app.models

import kotlinx.serialization.Serializable

@Serializable
data class Book(
    val id: String,
    val title: String,
    val author: String,
    val description: String,
    val userId: String
)
