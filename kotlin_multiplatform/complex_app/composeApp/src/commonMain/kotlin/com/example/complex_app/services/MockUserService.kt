package com.example.complex_app.services

import com.example.complex_app.models.User

object MockUserService {
    private val users = List(100) {
        User(
            id = it.toString(),
            name = "User $it"
        )
    }
    fun getUser(id: String): User? = users.find { it.id == id }
    fun getAllUsers(): List<User> = users
}
