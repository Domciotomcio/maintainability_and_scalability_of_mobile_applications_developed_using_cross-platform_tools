package com.example.complex_app.models

import kotlinx.serialization.Serializable

@Serializable
data class User(
    val id: String,
    val name: String
)
