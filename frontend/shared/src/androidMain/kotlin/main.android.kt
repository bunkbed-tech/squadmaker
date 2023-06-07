import androidx.compose.foundation.layout.ExperimentalLayoutApi
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.padding
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.AccountBox
import androidx.compose.material.icons.filled.List
import androidx.compose.material.icons.filled.Search
import androidx.compose.material3.Button
import androidx.compose.material3.Divider
import androidx.compose.material3.DrawerValue
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.ExtendedFloatingActionButton
import androidx.compose.material3.FabPosition
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.ModalDrawerSheet
import androidx.compose.material3.ModalNavigationDrawer
import androidx.compose.material3.NavigationDrawerItem
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.material3.rememberDrawerState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import components.BottomBar
import kotlinx.coroutines.launch
import org.jetbrains.compose.resources.ExperimentalResourceApi
import pages.GamesView
import pages.LandingPage
import pages.PlayView
import pages.RegisterPage
import pages.RosterView
import pages.SignInPage

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
    var isSignedIn by remember { mutableStateOf(false) }
    var isRegistering by remember { mutableStateOf(false) }
    var isSigningIn by remember { mutableStateOf(false) }
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
        if (isSignedIn) {
            ModalNavigationDrawer(
                drawerState = drawerState,
                drawerContent = {
                    ModalDrawerSheet {
                        Row {
                            Text("Drawer title", modifier = Modifier.padding(16.dp))
                            Button(
                                onClick = {
                                    isSignedIn = false
                                    scope.launch{
                                        drawerState.apply{
                                            if (isClosed) open() else close()
                                        }
                                    }
                                }
                            ) {
                                Text("Sign Out")
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
                        BottomBar(
                            view = selectedPage,
                            onDrawerClick = {
                                scope.launch{
                                    drawerState.apply{
                                        if (isClosed) open() else close()
                                    }
                                }
                            },
                            onViewClick = { _view -> selectedPage = _view }
                        )
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
                        when (selectedPage) {
                            "Roster" -> RosterView(innerPadding = innerPadding, player = player)
                            "Games" -> GamesView(innerPadding = innerPadding, game = game)
                            "Play" -> PlayView(innerPadding = innerPadding, game = game)
                        }
                    }
                )
            }
        } else {
            if (isRegistering) {
                RegisterPage(
                    onCancelClick = { isRegistering = false },
                    onRegisterClick = {
                        isSignedIn = true
                        isRegistering = false
                    },
                )
            } else if (isSigningIn) {
                SignInPage(
                    onCancelClick = { isSigningIn = false },
                    onSignInClick = {
                        isSignedIn = true
                        isSigningIn = false
                    },
                )
            } else {
                LandingPage(
                    onRegisterClick = { isRegistering = true },
                    onSignInClick = { isSigningIn = true },
                )
            }
        }
    }
}
