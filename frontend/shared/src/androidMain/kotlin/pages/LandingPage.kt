package pages

import Greeting
import androidx.compose.foundation.Image
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material3.Button
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.unit.dp
import kotlinx.coroutines.launch
import org.jetbrains.compose.resources.ExperimentalResourceApi
import org.jetbrains.compose.resources.painterResource

@OptIn(ExperimentalResourceApi::class)
@Composable
fun LandingPage(
    onRegisterClick: () -> Unit,
    onSignInClick: () -> Unit
) {
    val scope = rememberCoroutineScope()
    var text by remember { mutableStateOf("Loading") }
    Column(
        modifier = Modifier.fillMaxSize(),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {
        LaunchedEffect(true) {
            scope.launch {
                text = try {
                    Greeting().greeting()
                } catch (e: Exception) {
                    e.localizedMessage ?: "error"
                }
            }
        }
        Text(text)
        Image(
            painter = painterResource("compose-multiplatform.xml"),
            contentDescription = "Player picture",
            modifier = Modifier
                .size(240.dp)
                .clip(CircleShape)
        )
        Button(onClick = onRegisterClick) {
            Text("Register")
        }
        Button(onClick = onSignInClick){
            Text("Sign In")
        }
    }
}