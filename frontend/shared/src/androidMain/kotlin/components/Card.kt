package components

import androidx.compose.foundation.Image
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Edit
import androidx.compose.material3.Divider
import androidx.compose.material3.ElevatedCard
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.unit.dp
import org.jetbrains.compose.resources.ExperimentalResourceApi
import org.jetbrains.compose.resources.painterResource

import Player
import Game

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