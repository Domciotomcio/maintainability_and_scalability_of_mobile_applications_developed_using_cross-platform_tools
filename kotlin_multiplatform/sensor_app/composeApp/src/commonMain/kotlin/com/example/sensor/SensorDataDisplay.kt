package com.example.sensor

// Data class to hold all sensor values
data class SensorData(
    val accelerometer: Triple<Float, Float, Float>?,
    val gyroscope: Triple<Float, Float, Float>?,
    val magnetometer: Triple<Float, Float, Float>?,
    val gps: Pair<Double, Double>?,
    val compass: Float?,
    val light: Float?,
    val proximity: Float?,
    val microphone: Float?,
    val bluetooth: String?,
    val camera: ByteArray?
)

// Expect class for multiplatform implementation
expect class SensorDataDisplay() {
    fun getSensorData(): SensorData
}
