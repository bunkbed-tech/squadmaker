@file:OptIn(ExperimentalLayoutApi::class, ExperimentalMaterial3Api::class,
    ExperimentalResourceApi::class
)

import androidx.compose.foundation.layout.ExperimentalLayoutApi
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.ui.window.ComposeUIViewController
import org.jetbrains.compose.resources.ExperimentalResourceApi

actual fun getPlatformName(): String = "iOS"

fun MainViewController() = ComposeUIViewController { AppIOS() }