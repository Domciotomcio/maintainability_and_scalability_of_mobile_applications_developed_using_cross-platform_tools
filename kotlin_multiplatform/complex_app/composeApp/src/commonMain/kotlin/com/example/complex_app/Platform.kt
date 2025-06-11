package com.example.complex_app

interface Platform {
    val name: String
}

expect fun getPlatform(): Platform