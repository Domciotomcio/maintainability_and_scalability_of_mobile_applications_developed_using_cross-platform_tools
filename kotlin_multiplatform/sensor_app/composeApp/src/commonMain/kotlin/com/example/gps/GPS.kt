package com.example.gps

interface GPS {
    fun getCurrentLocation(): Pair<Double, Double>
}
