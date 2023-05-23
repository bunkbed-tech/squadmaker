import androidx.compose.foundation.Image
import androidx.compose.foundation.layout.Arrangement
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
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.ExperimentalLayoutApi
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.consumeWindowInsets
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material.icons.Icons
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
import androidx.compose.material3.NavigationBar
import androidx.compose.material3.Scaffold
import androidx.compose.material3.TopAppBar
import androidx.compose.material3.NavigationBarItem
import androidx.compose.ui.Alignment
import androidx.compose.ui.draw.clip
import org.jetbrains.compose.resources.ExperimentalResourceApi
import org.jetbrains.compose.resources.painterResource

@ExperimentalLayoutApi
@ExperimentalMaterial3Api
@ExperimentalResourceApi
@Composable
fun App() {
    var selectedPage by remember { mutableStateOf("Roster") }
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
                            Card()
                        }
                    }
                } else {
                    Text("Nothing to see here")
                }
            }
        )
    }
}

@ExperimentalMaterial3Api
@ExperimentalResourceApi
@Composable
fun Card() {
    ElevatedCard(
        onClick = { /* Do something */ },
        modifier = Modifier.fillMaxWidth().height(100.dp).padding(20.dp, 0.dp)
    ) {
        Row(
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.Start
        ) {
            Image(
                painter = painterResource("compose-multiplatform.xml"),
                contentDescription = "Player picture",
                modifier = Modifier
                    .size(40.dp)
                    .clip(CircleShape)
            )
            Box(Modifier.fillMaxSize()) {
                Text("Clickable", Modifier.align(Alignment.Center))
            }
        }
    }
    Divider(Modifier.padding(50.dp, 10.dp))
}

expect fun getPlatformName(): String