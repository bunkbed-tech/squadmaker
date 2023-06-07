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