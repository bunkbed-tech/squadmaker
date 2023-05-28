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
import androidx.compose.foundation.layout.aspectRatio
import androidx.compose.foundation.layout.consumeWindowInsets
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Edit
import androidx.compose.material.icons.filled.Favorite
import androidx.compose.material.icons.filled.Menu
import androidx.compose.material.icons.filled.Person
import androidx.compose.material.icons.filled.PlayArrow
import androidx.compose.material3.Divider
import androidx.compose.material3.ElevatedCard
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.ExtendedFloatingActionButton
import androidx.compose.material3.FabPosition
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.NavigationBar
import androidx.compose.material3.Scaffold
import androidx.compose.material3.TopAppBar
import androidx.compose.material3.NavigationBarItem
import androidx.compose.ui.Alignment
import androidx.compose.ui.draw.clip
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

@ExperimentalLayoutApi
@ExperimentalMaterial3Api
@ExperimentalResourceApi
@Composable
fun App() {
    var selectedPage by remember { mutableStateOf("Roster") }
    val player by remember { mutableStateOf(Player(
        id = 1,
        created_at = "2023/05/28",
        name = "Joe Schmoe",
        gender = Gender.Man,
        pronouns = "He/Him/His",
        birthday = "2000/05/27",
        phone = "+11234567890",
        email = "joe@joe.joe",
        place_from = "Joe Land",
        photo = "joe.starbucks.jpg",
        score_all_time = 0,
        score_avg_per_game = null
    )) }
    val game by remember { mutableStateOf(Game(
        id = 1,
        created_at = "2023/05/28",
        opponent_name = "The Schmoes",
        game_location = "Schmoe Land",
        start_datetime = "2023-05-28T19:00+02:00",
        league_id = 1,
        your_score = 1,
        opponent_score = 2,
        group_photo = "team.mp4",
    ))}
    MyApplicationTheme {
        Scaffold(
            topBar = {
                TopAppBar(
                    title = { Text(selectedPage) },
                )
            },
            bottomBar = {
                NavigationBar {
                    NavigationBarItem(
                        icon = { Icon(Icons.Filled.Menu, contentDescription = "Sidebar") },
                        selected = selectedPage == "Sidebar",
                        onClick = { }
                    )
                    NavigationBarItem(
                        icon = { Icon(Icons.Filled.Person, contentDescription = "Roster") },
                        label = { Text("Roster") },
                        selected = selectedPage == "Roster",
                        onClick = { selectedPage = "Roster" }
                    )
                    NavigationBarItem(
                        icon = { Icon(Icons.Filled.Favorite, contentDescription = "Games") },
                        label = { Text("Games") },
                        selected = selectedPage == "Games",
                        onClick = { selectedPage = "Games" }
                    )
                    NavigationBarItem(
                        icon = { Icon(Icons.Filled.PlayArrow, contentDescription = "Play") },
                        label = { Text("Play") },
                        selected = selectedPage == "Play",
                        onClick = { selectedPage = "Play" }
                    )
                }
            },
            floatingActionButtonPosition = FabPosition.End,
            floatingActionButton = {
                ExtendedFloatingActionButton(
                    onClick = { /* fab click handler */ }
                ) {
                    Text("Inc")
                }
            },
            content = { innerPadding ->
                if (selectedPage == "Roster") {
                    LazyColumn(
                        // consume insets as scaffold doesn't do it by default
                        modifier = Modifier.consumeWindowInsets(innerPadding),
                        contentPadding = innerPadding
                    ) {
                        items(count = 100) {
                            Card(player = player)
                        }
                    }
                } else if (selectedPage == "Games") {
                    LazyColumn(
                        // consume insets as scaffold doesn't do it by default
                        modifier = Modifier.consumeWindowInsets(innerPadding),
                        contentPadding = innerPadding
                    ) {
                        items(count = 100) {
                            Card(game = game)
                        }
                    }
                } else if (selectedPage == "Play") {
                    Column(
                        modifier = Modifier.padding(innerPadding)
                    ) {
                        Row(
                            modifier = Modifier
                                .fillMaxWidth()
                                .height(60.dp),
                            verticalAlignment = Alignment.CenterVertically,
                            horizontalArrangement = Arrangement.SpaceAround
                        ) {
                            Box(
                                modifier = Modifier
                                    .fillMaxHeight()
                                    .border(
                                        width = 5.dp,
                                        color = MaterialTheme.colorScheme.primary,
                                        shape = RoundedCornerShape(10.dp, 10.dp, 0.dp, 0.dp))
                                    .padding(10.dp),
                                contentAlignment = Alignment.CenterStart
                            ) {
                                Column() {
                                    Text(game.opponent_name)
                                    Text(game.start_datetime)
                                }
                            }
                            Box(
                                modifier = Modifier
                                    .fillMaxHeight()
                                    .aspectRatio(1F)
                                    .border(
                                        width = 5.dp,
                                        color = MaterialTheme.colorScheme.primary,
                                        shape = RoundedCornerShape(10.dp, 10.dp, 0.dp, 0.dp))
                                    .padding(10.dp),
                                contentAlignment = Alignment.Center
                            ) {
                                Text("1", style = MaterialTheme.typography.titleLarge)
                            }
                        }
                    }
                }
            }
        )
    }
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