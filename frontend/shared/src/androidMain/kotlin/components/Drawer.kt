package components

import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Button
import androidx.compose.material3.Divider
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.ModalDrawerSheet
import androidx.compose.material3.NavigationDrawerItem
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun Drawer(
    isSignOutClicked: () -> Unit
) {
    ModalDrawerSheet {
        Row {
            Text("Drawer title", modifier = Modifier.padding(16.dp))
            Button(onClick = isSignOutClicked) {
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