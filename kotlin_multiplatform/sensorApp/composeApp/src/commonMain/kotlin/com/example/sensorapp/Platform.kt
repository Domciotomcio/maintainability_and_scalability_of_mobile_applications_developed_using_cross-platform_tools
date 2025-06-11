package com.example.sensorapp

interface Platform {
    val name: String
}

expect fun getPlatform(): Platform