@file:OptIn(ExperimentalLayoutApi::class, ExperimentalMaterial3Api::class,
    ExperimentalResourceApi::class
)

import androidx.compose.foundation.layout.ExperimentalLayoutApi
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.compose.ui.window.ComposeUIViewController
import org.jetbrains.compose.resources.ExperimentalResourceApi

actual fun getPlatformName(): String = "iOS"

@Composable
actual fun App() {
    Text("Hello World", modifier = Modifier.padding(16.dp))
}

fun MainViewController() = ComposeUIViewController { App() }