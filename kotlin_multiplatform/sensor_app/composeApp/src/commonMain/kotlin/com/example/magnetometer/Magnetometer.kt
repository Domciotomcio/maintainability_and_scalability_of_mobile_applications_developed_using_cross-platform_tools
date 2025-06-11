package com.example.magnetometer

interface Magnetometer {
    fun getMagneticField(): Triple<Float, Float, Float>
}
