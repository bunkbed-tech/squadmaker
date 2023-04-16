use serde::Serialize;
use sqlx::Type;
use strum_macros::EnumString;

pub enum Sport {
    Kickball,
    Baseball,
    Softball,
}

pub enum ScoreName {
    Run,
}

pub enum TrophyType {
    PerfectAttendance,
    HighScoreGame,
    HighScoreLeague,
    HatTrick,
}

#[derive(Debug, Type, EnumString, Serialize)]
#[sqlx(type_name = "gender", rename_all = "snake_case")]
#[strum(serialize_all = "snake_case")]
pub enum Gender {
    Man,
    Woman,
    Other,
}
