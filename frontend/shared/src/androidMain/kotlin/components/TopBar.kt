package components

import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.AccountBox
import androidx.compose.material.icons.filled.List
import androidx.compose.material.icons.filled.Search
import androidx.compose.material3.Button
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun TopBar(
    view: String
) {
    TopAppBar(
        title = { Text(view) },
        actions = {
            if (view == "Play") {
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
}