package components

import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Favorite
import androidx.compose.material.icons.filled.Menu
import androidx.compose.material.icons.filled.Person
import androidx.compose.material.icons.filled.PlayArrow
import androidx.compose.material3.Icon
import androidx.compose.material3.NavigationBar
import androidx.compose.material3.NavigationBarItem
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable

@Composable
fun BottomBar(
    view: String,
    onDrawerClick: () -> Unit,
    onViewClick: (String) -> Unit,
) {
    NavigationBar {
        NavigationBarItem(
            icon = { Icon(Icons.Filled.Menu, contentDescription = "Sidebar") },
            selected = view == "Sidebar",
            onClick = onDrawerClick
        )
        NavigationBarItem(
            icon = { Icon(Icons.Filled.Person, contentDescription = "Roster") },
            label = { Text("Roster") },
            selected = view == "Roster",
            onClick = { onViewClick("Roster") }
        )
        NavigationBarItem(
            icon = { Icon(Icons.Filled.Favorite, contentDescription = "Games") },
            label = { Text("Games") },
            selected = view == "Games",
            onClick = { onViewClick("Games") }
        )
        NavigationBarItem(
            icon = { Icon(Icons.Filled.PlayArrow, contentDescription = "Play") },
            label = { Text("Play") },
            selected = view == "Play",
            onClick = { onViewClick("Play") }
        )
    }
}