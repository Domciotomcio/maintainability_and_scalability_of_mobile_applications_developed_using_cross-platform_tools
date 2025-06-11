package com.example.sensor

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.location.Location
import android.location.LocationListener
import android.location.LocationManager
import android.os.Bundle
import com.example.accelerometer.Accelerometer
import com.example.gyroscope.Gyroscope
import com.example.magnetometer.Magnetometer
import com.example.gps.GPS
import com.example.compass.Compass
import com.example.lightsensor.LightSensor
import com.example.proximitysensor.ProximitySensor
import com.example.microphone.Microphone
import com.example.bluetooth.Bluetooth
import com.example.camera.Camera

// Helper classes for each sensor
class AndroidAccelerometer(private val context: Context) : Accelerometer, SensorEventListener {
    private var lastValue: Triple<Float, Float, Float> = Triple(0f, 0f, 0f)
    private val sensorManager = context.getSystemService(Context.SENSOR_SERVICE) as SensorManager
    private val sensor = sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER)
    init { sensorManager.registerListener(this, sensor, SensorManager.SENSOR_DELAY_NORMAL) }
    override fun onSensorChanged(event: SensorEvent?) {
        event?.let { lastValue = Triple(it.values[0], it.values[1], it.values[2]) }
    }
    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {}
    override fun getAcceleration() = lastValue
}

class AndroidGyroscope(private val context: Context) : Gyroscope, SensorEventListener {
    private var lastValue: Triple<Float, Float, Float> = Triple(0f, 0f, 0f)
    private val sensorManager = context.getSystemService(Context.SENSOR_SERVICE) as SensorManager
    private val sensor = sensorManager.getDefaultSensor(Sensor.TYPE_GYROSCOPE)
    init { sensorManager.registerListener(this, sensor, SensorManager.SENSOR_DELAY_NORMAL) }
    override fun onSensorChanged(event: SensorEvent?) {
        event?.let { lastValue = Triple(it.values[0], it.values[1], it.values[2]) }
    }
    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {}
    override fun getRotation() = lastValue
}

class AndroidMagnetometer(private val context: Context) : Magnetometer, SensorEventListener {
    private var lastValue: Triple<Float, Float, Float> = Triple(0f, 0f, 0f)
    private val sensorManager = context.getSystemService(Context.SENSOR_SERVICE) as SensorManager
    private val sensor = sensorManager.getDefaultSensor(Sensor.TYPE_MAGNETIC_FIELD)
    init { sensorManager.registerListener(this, sensor, SensorManager.SENSOR_DELAY_NORMAL) }
    override fun onSensorChanged(event: SensorEvent?) {
        event?.let { lastValue = Triple(it.values[0], it.values[1], it.values[2]) }
    }
    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {}
    override fun getMagneticField() = lastValue
}

class AndroidGPS(private val context: Context) : GPS, LocationListener {
    private var lastLocation: Pair<Double, Double> = Pair(0.0, 0.0)
    private val locationManager = context.getSystemService(Context.LOCATION_SERVICE) as LocationManager
    init {
        try {
            locationManager.requestLocationUpdates(LocationManager.GPS_PROVIDER, 1000L, 1f, this)
        } catch (e: SecurityException) {}
    }
    override fun onLocationChanged(location: Location) {
        lastLocation = Pair(location.latitude, location.longitude)
    }
    override fun onStatusChanged(provider: String?, status: Int, extras: Bundle?) {}
    override fun onProviderEnabled(provider: String) {}
    override fun onProviderDisabled(provider: String) {}
    override fun getCurrentLocation() = lastLocation
}

actual class SensorDataDisplay(private val context: Context) {
    private val accelerometer = AndroidAccelerometer(context)
    private val gyroscope = AndroidGyroscope(context)
    private val magnetometer = AndroidMagnetometer(context)
    private val gps = AndroidGPS(context)
    private val compass = object : Compass {
        override fun getOrientation(): Float {
            val sensorManager = context.getSystemService(Context.SENSOR_SERVICE) as SensorManager
            val accelerometer = sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER)
            val magnetometer = sensorManager.getDefaultSensor(Sensor.TYPE_MAGNETIC_FIELD)
            val gravity = FloatArray(3)
            val geomagnetic = FloatArray(3)
            val rotationMatrix = FloatArray(9)
            val orientation = FloatArray(3)
            var haveGravity = false
            var haveMagnet = false
            val listener = object : SensorEventListener {
                override fun onSensorChanged(event: SensorEvent) {
                    when (event.sensor.type) {
                        Sensor.TYPE_ACCELEROMETER -> {
                            System.arraycopy(event.values, 0, gravity, 0, 3)
                            haveGravity = true
                        }
                        Sensor.TYPE_MAGNETIC_FIELD -> {
                            System.arraycopy(event.values, 0, geomagnetic, 0, 3)
                            haveMagnet = true
                        }
                    }
                    if (haveGravity && haveMagnet) {
                        SensorManager.getRotationMatrix(rotationMatrix, null, gravity, geomagnetic)
                        SensorManager.getOrientation(rotationMatrix, orientation)
                    }
                }
                override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {}
            }
            sensorManager.registerListener(listener, accelerometer, SensorManager.SENSOR_DELAY_UI)
            sensorManager.registerListener(listener, magnetometer, SensorManager.SENSOR_DELAY_UI)
            // Return azimuth in degrees (orientation[0] is azimuth in radians)
            return Math.toDegrees(orientation[0].toDouble()).toFloat()
        }
    }
    private val lightSensor = object : LightSensor {
        override fun getLightIntensity(): Float {
            val sensorManager = context.getSystemService(Context.SENSOR_SERVICE) as SensorManager
            val sensor = sensorManager.getDefaultSensor(Sensor.TYPE_LIGHT)
            var value = 0f
            val listener = object : SensorEventListener {
                override fun onSensorChanged(event: SensorEvent) {
                    value = event.values[0]
                }
                override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {}
            }
            sensorManager.registerListener(listener, sensor, SensorManager.SENSOR_DELAY_UI)
            return value
        }
    }
    private val proximitySensor = object : ProximitySensor {
        override fun getProximity(): Float {
            val sensorManager = context.getSystemService(Context.SENSOR_SERVICE) as SensorManager
            val sensor = sensorManager.getDefaultSensor(Sensor.TYPE_PROXIMITY)
            var value = 0f
            val listener = object : SensorEventListener {
                override fun onSensorChanged(event: SensorEvent) {
                    value = event.values[0]
                }
                override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {}
            }
            sensorManager.registerListener(listener, sensor, SensorManager.SENSOR_DELAY_UI)
            return value
        }
    }
    private val microphone = object : Microphone {
        override fun getAudioLevel(): Float {
            // Simple implementation using AudioRecord to get RMS value
            val bufferSize = android.media.AudioRecord.getMinBufferSize(
                android.media.MediaRecorder.AudioSource.MIC,
                android.media.AudioFormat.CHANNEL_IN_MONO,
                android.media.AudioFormat.ENCODING_PCM_16BIT
            )
            val audioRecord = android.media.AudioRecord(
                android.media.MediaRecorder.AudioSource.MIC,
                44100,
                android.media.AudioFormat.CHANNEL_IN_MONO,
                android.media.AudioFormat.ENCODING_PCM_16BIT,
                bufferSize
            )
            val buffer = ShortArray(bufferSize)
            audioRecord.startRecording()
            audioRecord.read(buffer, 0, bufferSize)
            audioRecord.stop()
            audioRecord.release()
            // Calculate RMS (root mean square) for audio level
            val rms = Math.sqrt(buffer.map { it * it.toDouble() }.average())
            return rms.toFloat()
        }
    }
    private val bluetooth = object : Bluetooth {
        override fun getDeviceInfo(): String {
            val bluetoothAdapter = android.bluetooth.BluetoothAdapter.getDefaultAdapter()
            return bluetoothAdapter?.bondedDevices?.joinToString("\n") { it.name + ": " + it.address } ?: "No Bluetooth Adapter"
        }
    }
    private val camera = object : Camera {
        override fun captureImage(): ByteArray {
            // Camera2 API requires UI and permissions, so return stub for now
            return ByteArray(0)
        }
    }

    actual fun getSensorData(): SensorData {
        return SensorData(
            accelerometer = accelerometer.getAcceleration(),
            gyroscope = gyroscope.getRotation(),
            magnetometer = magnetometer.getMagneticField(),
            gps = gps.getCurrentLocation(),
            compass = compass.getOrientation(),
            light = lightSensor.getLightIntensity(),
            proximity = proximitySensor.getProximity(),
            microphone = microphone.getAudioLevel(),
            bluetooth = bluetooth.getDeviceInfo(),
            camera = camera.captureImage()
        )
    }
}
