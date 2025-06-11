package com.example.sensor_app

import android.content.Context
import androidx.compose.runtime.Composable
import androidx.compose.ui.platform.LocalContext
import com.example.sensor.SensorDataDisplay

@Composable
actual fun getPlatformSensorData(): String {
    val context = LocalContext.current
    val sensorData = SensorDataDisplay(context).getSensorData()
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
