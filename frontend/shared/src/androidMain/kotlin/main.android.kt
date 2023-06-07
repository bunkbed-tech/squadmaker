import androidx.compose.foundation.Image
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.ExperimentalLayoutApi
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.aspectRatio
import androidx.compose.foundation.layout.consumeWindowInsets
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.AccountBox
import androidx.compose.material.icons.filled.Delete
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
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.ExtendedFloatingActionButton
import androidx.compose.material3.FabPosition
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.ModalDrawerSheet
import androidx.compose.material3.ModalNavigationDrawer
import androidx.compose.material3.NavigationBar
import androidx.compose.material3.NavigationBarItem
import androidx.compose.material3.NavigationDrawerItem
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TextField
import androidx.compose.material3.TopAppBar
import androidx.compose.material3.rememberDrawerState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.RectangleShape
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.text.input.PasswordVisualTransformation
import androidx.compose.ui.text.input.VisualTransformation
import androidx.compose.ui.unit.dp
import kotlinx.coroutines.launch
import org.jetbrains.compose.resources.ExperimentalResourceApi
import org.jetbrains.compose.resources.painterResource
import components.Card

actual fun getPlatformName(): String = "Android"

@ExperimentalMaterial3Api
@ExperimentalLayoutApi
@ExperimentalResourceApi
@Composable
fun MainView() = App()

@ExperimentalLayoutApi
@ExperimentalMaterial3Api
@ExperimentalResourceApi
@Composable
actual fun App() {
    var selectedPage by remember { mutableStateOf("Roster") }
    var isLoggedIn by remember { mutableStateOf(false) }
    var isRegistering by remember { mutableStateOf(false) }
    var isLoggingIn by remember { mutableStateOf(false) }
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
    ))
    }
    MyApplicationTheme {
        if (isLoggedIn) {
            ModalNavigationDrawer(
                drawerState = drawerState,
                drawerContent = {
                    ModalDrawerSheet {
                        Row() {
                            Text("Drawer title", modifier = Modifier.padding(16.dp))
                            Button(
                                onClick = {isLoggedIn = false}
                            ) {
                                Text("Log Out")
                            }
                        }
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
        } else {
            if (isRegistering) {
                var username by rememberSaveable { mutableStateOf("") }
                var name by rememberSaveable { mutableStateOf("") }
                var email by rememberSaveable { mutableStateOf("") }
                var password by rememberSaveable { mutableStateOf("") }
                var passwordHidden by rememberSaveable { mutableStateOf(true) }

                Column(
                    modifier = Modifier.fillMaxSize(),
                    horizontalAlignment = Alignment.CenterHorizontally,
                    verticalArrangement = Arrangement.Center
                ) {
                    TextField(
                        onValueChange = { username = it },
                        value = username,
                        label = { Text("Username") },
                        placeholder = { Text("e.g. joe_schmoe") },
                    )
                    TextField(
                        onValueChange = { name = it },
                        value = name,
                        label = { Text("Full Name") },
                        placeholder = { Text("e.g. Joe Schmoe") },
                    )
                    TextField(
                        onValueChange = { email = it },
                        value = email,
                        label = { Text("Email") },
                        placeholder = { Text("e.g. joe@schmoe.co") },
                    )
                    TextField(
                        value = password,
                        onValueChange = { password = it },
                        singleLine = true,
                        label = { Text("Password") },
                        visualTransformation =
                            if (passwordHidden) PasswordVisualTransformation() else VisualTransformation.None,
                        keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Password),
                        trailingIcon = {
                            IconButton(onClick = { passwordHidden = !passwordHidden }) {
                                val visibilityIcon =
                                    if (passwordHidden) Icons.Filled.Person else Icons.Filled.Favorite
                                // Please provide localized description for accessibility services
                                val description = if (passwordHidden) "Show password" else "Hide password"
                                Icon(imageVector = visibilityIcon, contentDescription = description)
                            }
                        }
                    )
                    Row() {
                        Button(
                            onClick = {isRegistering = false}
                        ) {
                            Text("Cancel")
                        }
                        Button(
                            onClick = {
                                isLoggedIn = true
                                isRegistering = false
                            }
                        ) {
                            Text("Sign Up")
                        }
                    }
                }
            } else if (isLoggingIn) {
                var username by rememberSaveable { mutableStateOf("") }
                var password by rememberSaveable { mutableStateOf("") }
                var passwordHidden by rememberSaveable { mutableStateOf(true) }

                Column(
                    modifier = Modifier.fillMaxSize(),
                    horizontalAlignment = Alignment.CenterHorizontally,
                    verticalArrangement = Arrangement.Center
                ) {
                    TextField(
                        onValueChange = { username = it },
                        value = username,
                        label = { Text("Username") },
                        placeholder = { Text("e.g. joe_schmoe") },
                    )
                    TextField(
                        value = password,
                        onValueChange = { password = it },
                        singleLine = true,
                        label = { Text("Password") },
                        visualTransformation =
                        if (passwordHidden) PasswordVisualTransformation() else VisualTransformation.None,
                        keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Password),
                        trailingIcon = {
                            IconButton(onClick = { passwordHidden = !passwordHidden }) {
                                val visibilityIcon =
                                    if (passwordHidden) Icons.Filled.Person else Icons.Filled.Favorite
                                // Please provide localized description for accessibility services
                                val description = if (passwordHidden) "Show password" else "Hide password"
                                Icon(imageVector = visibilityIcon, contentDescription = description)
                            }
                        }
                    )
                    Row() {
                        Button(
                            onClick = {isLoggingIn = false}
                        ) {
                            Text("Cancel")
                        }
                        Button(
                            onClick = {
                                isLoggedIn = true
                                isLoggingIn = false
                            }
                        ) {
                            Text("Log In")
                        }
                    }
                }
            } else {
                Column(
                    modifier = Modifier.fillMaxSize(),
                    horizontalAlignment = Alignment.CenterHorizontally,
                    verticalArrangement = Arrangement.Center
                ) {
                    Image(
                        painter = painterResource("compose-multiplatform.xml"),
                        contentDescription = "Player picture",
                        modifier = Modifier
                            .size(240.dp)
                            .clip(CircleShape)
                    )
                    Button(
                        onClick = {isRegistering = true}
                    ) {
                        Text("Sign Up")
                    }
                    Button(
                        onClick = {isLoggingIn = true}
                    ) {
                        Text("Sign In")
                    }
                }
            }
        }
    }
}
