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

@ExperimentalLayoutApi
@ExperimentalMaterial3Api
@ExperimentalResourceApi
@Composable
fun App() {
    var selectedPage by remember { mutableStateOf("Roster") }
    val drawerState = rememberDrawerState(initialValue = DrawerValue.Closed)
    val scope = rememberCoroutineScope()
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
        ModalNavigationDrawer(
            drawerState = drawerState,
            drawerContent = {
                ModalDrawerSheet {
                    Text("Drawer title", modifier = Modifier.padding(16.dp))
                    Divider()
                    NavigationDrawerItem(
                        label = { Text(text = "Drawer Item") },
                        selected = false,
                        onClick = { /*TODO*/ }
                    )
                    // ...other drawer items
                }
            }
        ) {
            // Screen content
            Scaffold(
                topBar = {
                    TopAppBar(
                        title = { Text(selectedPage) },
                        actions = {
                            if (selectedPage == "Play") {
                                Button(
                                    onClick = {}
                                ) {
                                    Text("Players")
                                }
                                Button(
                                    onClick = {}
                                ) {
                                    Text("Batting")
                                }
                                Button(
                                    onClick = {}
                                ) {
                                    Text("Fielding")
                                }
                            } else {
                                IconButton(onClick = { }) {
                                    Icon(
                                        imageVector = Icons.Filled.Search,
                                        contentDescription = "Search",
                                    )
                                }
                                IconButton(onClick = { }) {
                                    Icon(
                                        imageVector = Icons.Filled.AccountBox,
                                        contentDescription = "Sort",
                                    )
                                }
                                IconButton(onClick = { }) {
                                    Icon(
                                        imageVector = Icons.Filled.List,
                                        contentDescription = "Filter",
                                    )
                                }
                            }
                        }
                    )
                },
                bottomBar = {
                    NavigationBar {
                        NavigationBarItem(
                            icon = { Icon(Icons.Filled.Menu, contentDescription = "Sidebar") },
                            selected = selectedPage == "Sidebar",
                            onClick = {
                                scope.launch{
                                    drawerState.apply{
                                        if (isClosed) open() else close()
                                    }
                                }
                            }
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
                            modifier = Modifier.padding(
                                20.dp,
                                innerPadding.calculateTopPadding(),
                                20.dp,
                                innerPadding.calculateBottomPadding() + 20.dp
                            ),
                            horizontalAlignment = Alignment.CenterHorizontally,
                            verticalArrangement = Arrangement.spacedBy(20.dp)
                        ) {
                            Row(
                                modifier = Modifier
                                    .fillMaxWidth()
                                    .height(60.dp),
                                verticalAlignment = Alignment.CenterVertically,
                                horizontalArrangement = Arrangement.SpaceBetween
                            ) {
                                Box(
                                    modifier = Modifier
                                        .fillMaxHeight()
                                        .border(
                                            width = 5.dp,
                                            color = MaterialTheme.colorScheme.primary,
                                            shape = RoundedCornerShape(10.dp, 10.dp, 0.dp, 0.dp)
                                        )
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
                                            shape = RoundedCornerShape(10.dp, 10.dp, 0.dp, 0.dp)
                                        )
                                        .padding(10.dp),
                                    contentAlignment = Alignment.Center
                                ) {
                                    Text("1", style = MaterialTheme.typography.titleLarge)
                                }
                            }
                            Box(
                                modifier = Modifier
                                    .fillMaxWidth()
                                    .weight(1f)
                                    .border(
                                        width = 5.dp,
                                        color = MaterialTheme.colorScheme.primary,
                                        shape = RoundedCornerShape(0.dp, 0.dp, 10.dp, 10.dp)
                                    )
                                    .clip(RoundedCornerShape(0.dp, 0.dp, 10.dp, 10.dp)),
                                contentAlignment = Alignment.CenterStart
                            ) {
                                LazyColumn(
                                    // consume insets as scaffold doesn't do it by default
//                            modifier = Modifier.consumeWindowInsets(innerPadding),
//                                contentPadding = Pa20.dp
                                    verticalArrangement = Arrangement.spacedBy(0.dp)
                                ) {
                                    items(count = 100) {
                                        Row(
                                            modifier = Modifier
                                                .fillMaxWidth()
                                                .padding(10.dp, 0.dp, 0.dp, 0.dp),
                                            horizontalArrangement = Arrangement.SpaceBetween,
                                            verticalAlignment = Alignment.CenterVertically
                                        ) {
                                            Text("Joe Schmoe")
                                            IconButton(
                                                onClick = { },
                                                modifier = Modifier.border(
                                                    width = 1.dp,
                                                    color = MaterialTheme.colorScheme.primary,
                                                    shape = RectangleShape
                                                )
                                            ) {
                                                Icon(
                                                    imageVector = Icons.Filled.Delete,
                                                    contentDescription = "Delete Player from Lineup",
                                                )
                                            }
                                        }
                                    }
                                }
                            }
                            Divider(
                                modifier = Modifier
                                    .fillMaxWidth()
                                    .padding(40.dp, 0.dp)
                            )
                            Row(
                                modifier = Modifier.fillMaxWidth(),
                                verticalAlignment = Alignment.CenterVertically,
                                horizontalArrangement = Arrangement.SpaceAround
                            ) {
                                Column() {
                                    IconButton(onClick = { }) {
                                        Icon(
                                            imageVector = Icons.Filled.KeyboardArrowUp,
                                            contentDescription = "Increment Home Score",
                                        )
                                    }
                                    IconButton(onClick = { }) {
                                        Icon(
                                            imageVector = Icons.Filled.KeyboardArrowDown,
                                            contentDescription = "Decrement Home Score",
                                        )
                                    }
                                }
                                Text("1-2", style = MaterialTheme.typography.headlineLarge)
                                Column() {
                                    IconButton(onClick = { }) {
                                        Icon(
                                            imageVector = Icons.Filled.KeyboardArrowUp,
                                            contentDescription = "Increment Away Score",
                                        )
                                    }
                                    IconButton(onClick = { }) {
                                        Icon(
                                            imageVector = Icons.Filled.KeyboardArrowDown,
                                            contentDescription = "Decrement Away Score",
                                        )
                                    }
                                }
                            }
                            Button(
                                onClick = { },
                            ) {
                                Text("End Game")
                            }
                        }
                    }
                }
            )
        }
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