package com.example.sensor_app

import androidx.compose.runtime.Composable
import com.example.sensor.SensorDataDisplay

@Composable
actual fun getPlatformSensorData(): String {
    val sensorData = SensorDataDisplay().getSensorData()
    return buildString {
        appendLine("Accelerometer: ${sensorData.accelerometer}")
        appendLine("Gyroscope: ${sensorData.gyroscope}")
        appendLine("Magnetometer: ${sensorData.magnetometer}")
        appendLine("GPS: ${sensorData.gps}")
        appendLine("Compass: ${sensorData.compass}")
        appendLine("Light: ${sensorData.light}")
        appendLine("Proximity: ${sensorData.proximity}")
        appendLine("Microphone: ${sensorData.microphone}")
        appendLine("Bluetooth: ${sensorData.bluetooth}")
        appendLine("Camera: ${sensorData.camera?.size ?: 0} bytes")
    }
}
