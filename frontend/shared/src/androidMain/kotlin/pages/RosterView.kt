package pages

import Player
import androidx.compose.foundation.layout.ExperimentalLayoutApi
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.consumeWindowInsets
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.runtime.Composable
import components.Card
import org.jetbrains.compose.resources.ExperimentalResourceApi

@OptIn(
    ExperimentalLayoutApi::class,
    ExperimentalMaterial3Api::class,
    ExperimentalResourceApi::class
)
@Composable
fun RosterView(
    innerPadding: PaddingValues,
    player: Player
) {
    LazyColumn(
        // consume insets as scaffold doesn't do it by default
        modifier = androidx.compose.ui.Modifier.consumeWindowInsets(innerPadding),
        contentPadding = innerPadding
    ) {
        items(count = 100) {
            Card(player = player)
        }
    }
}