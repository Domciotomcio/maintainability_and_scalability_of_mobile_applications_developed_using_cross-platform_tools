package com.example.gyroscope

interface Gyroscope {
    fun getRotation(): Triple<Float, Float, Float>
}
