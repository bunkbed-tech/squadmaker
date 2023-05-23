import androidx.compose.foundation.layout.ExperimentalLayoutApi
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.runtime.Composable
import org.jetbrains.compose.resources.ExperimentalResourceApi

actual fun getPlatformName(): String = "Android"

@ExperimentalMaterial3Api
@ExperimentalLayoutApi
@ExperimentalResourceApi
@Composable
fun MainView() = App()
