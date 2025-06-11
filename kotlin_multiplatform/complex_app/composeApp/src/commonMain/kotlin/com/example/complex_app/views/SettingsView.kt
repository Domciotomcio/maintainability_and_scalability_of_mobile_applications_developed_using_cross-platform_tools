package com.example.complex_app.views

import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.runtime.remember
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.getValue
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.unit.dp

@Composable
fun SettingsView(modifier: Modifier) {
    Column(modifier = modifier.padding(16.dp)) {
        Text("Settings", style = MaterialTheme.typography.titleLarge, modifier = Modifier.semantics { contentDescription = "Settings Title" })
        Spacer(Modifier.height(16.dp))
        // Example settings options
        var notificationsEnabled by remember { mutableStateOf(true) }
        var showNotificationSnackbar by remember { mutableStateOf(false) }
        Row(
            Modifier
                .fillMaxWidth()
                .padding(vertical = 8.dp),
            horizontalArrangement = Arrangement.SpaceBetween
        ) {
            Text("Enable Notifications", modifier = Modifier.semantics { contentDescription = "Enable Notifications" })
            Switch(
                checked = notificationsEnabled,
                onCheckedChange = {
                    notificationsEnabled = it
                    showNotificationSnackbar = true
                },
                modifier = Modifier.semantics { contentDescription = if (notificationsEnabled) "Notifications On" else "Notifications Off" }
            )
        }
        var darkThemeEnabled by remember { mutableStateOf(false) }
        Row(
            Modifier
                .fillMaxWidth()
                .padding(vertical = 8.dp),
            horizontalArrangement = Arrangement.SpaceBetween
        ) {
            Text("Dark Theme", modifier = Modifier.semantics { contentDescription = "Dark Theme" })
            Switch(
                checked = darkThemeEnabled,
                onCheckedChange = { darkThemeEnabled = it },
                modifier = Modifier.semantics { contentDescription = if (darkThemeEnabled) "Dark Theme On" else "Dark Theme Off" }
            )
        }
        // Responsive padding for larger screens
        Spacer(Modifier.weight(1f))
        Divider(Modifier.padding(vertical = 8.dp))
        Text("App version: 1.0.0", style = MaterialTheme.typography.bodySmall, modifier = Modifier.align(Alignment.End).semantics { contentDescription = "App Version 1.0.0" })
        // Snackbar for notifications toggle
        if (showNotificationSnackbar) {
            Snackbar(
                action = {
                    TextButton(onClick = { showNotificationSnackbar = false }) { Text("Dismiss") }
                },
                modifier = Modifier.padding(8.dp)
            ) {
                Text(if (notificationsEnabled) "Notifications enabled" else "Notifications disabled")
            }
        }
    }
}
