package com.example.sensor_app

interface Platform {
    val name: String
}

expect fun getPlatform(): Platform