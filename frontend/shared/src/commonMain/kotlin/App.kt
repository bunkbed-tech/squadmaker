import androidx.compose.runtime.Composable
import io.ktor.client.HttpClient
import io.ktor.client.request.get
import io.ktor.client.statement.*

expect fun getPlatformName(): String

@Composable
expect fun App()

class Greeting {
    private val client = HttpClient()

    suspend fun greeting(): String {
        val response = client.get("http://127.0.0.1:8080")
        return response.bodyAsText()
    }
}