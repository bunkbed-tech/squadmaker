import androidx.compose.foundation.Image
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.foundation.layout.height
import androidx.compose.ui.unit.dp
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.ExperimentalLayoutApi
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.aspectRatio
import androidx.compose.foundation.layout.consumeWindowInsets
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.AccountBox
import androidx.compose.material.icons.filled.Delete
import androidx.compose.material.icons.filled.Edit
import androidx.compose.material.icons.filled.Favorite
import androidx.compose.material.icons.filled.KeyboardArrowDown
import androidx.compose.material.icons.filled.KeyboardArrowUp
import androidx.compose.material.icons.filled.List
import androidx.compose.material.icons.filled.Menu
import androidx.compose.material.icons.filled.Person
import androidx.compose.material.icons.filled.PlayArrow
import androidx.compose.material.icons.filled.Search
import androidx.compose.material3.Button
import androidx.compose.material3.Divider
import androidx.compose.material3.DrawerValue
import androidx.compose.material3.ElevatedCard
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.ExtendedFloatingActionButton
import androidx.compose.material3.FabPosition
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.ModalDrawerSheet
import androidx.compose.material3.ModalNavigationDrawer
import androidx.compose.material3.NavigationBar
import androidx.compose.material3.Scaffold
import androidx.compose.material3.TopAppBar
import androidx.compose.material3.NavigationBarItem
import androidx.compose.material3.NavigationDrawerItem
import androidx.compose.material3.rememberDrawerState
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.ui.Alignment
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.clipToBounds
import androidx.compose.ui.graphics.RectangleShape
import kotlinx.coroutines.launch
import org.jetbrains.compose.resources.ExperimentalResourceApi
import org.jetbrains.compose.resources.painterResource

enum class Gender {
    Man,
}
data class Player(
    val id: Int,
    val created_at: String,
    var name: String,
    var gender: Gender,
    var pronouns: String?,
    var birthday: String?,
    var phone: String,
    var email: String,
    var place_from: String?,
    var photo: String?,
    val score_all_time: Int,
    val score_avg_per_game: Float?
)

data class Game(
    val id: Int,
    val created_at: String,
    var opponent_name: String,
    var game_location: String,
    var start_datetime: String,
    var league_id: Int,
    var your_score: Int,
    var opponent_score: Int,
    var group_photo: String?,
)

@Composable
fun AppIOS() {
    Text("Hello World", modifier = Modifier.padding(16.dp))
}

@ExperimentalMaterial3Api
@ExperimentalResourceApi
@Composable
fun Card(
    player: Player? = null,
    game: Game? = null,
) {
    ElevatedCard(
        onClick = { /* Do something */ },
        modifier = Modifier.fillMaxWidth().height(100.dp).padding(20.dp, 0.dp)
    ) {
        Row(
            modifier = Modifier.fillMaxSize(),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.SpaceBetween
        ) {
            Image(
                painter = painterResource("compose-multiplatform.xml"),
                contentDescription = "Player picture",
                modifier = Modifier
                    .size(80.dp)
                    .clip(CircleShape)
            )
            Column() {
                if (player != null) {
                    Text(player.name)
                    Text(player.phone)
                    Text(player.email)
                } else if (game != null) {
                    Text(game.opponent_name)
                    Text(game.start_datetime)
                    Text(game.game_location)
                } else {
                    Text("Not a valid player or game")
                }
            }
            IconButton(onClick = { }) {
                Icon(
                    imageVector = Icons.Filled.Edit,
                    contentDescription = "Edit Player",
                )
            }
        }
    }
    Divider(Modifier.padding(50.dp, 10.dp))
}

expect fun getPlatformName(): String