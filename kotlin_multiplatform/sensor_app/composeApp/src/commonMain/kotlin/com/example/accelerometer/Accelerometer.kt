package com.example.accelerometer

interface Accelerometer {
    fun getAcceleration(): Triple<Float, Float, Float>
}
