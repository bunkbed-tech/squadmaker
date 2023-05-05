use serde::{Serialize, Deserialize};
use sqlx::Type;
use strum_macros::{Display, EnumString};

#[allow(non_camel_case_types)]
#[derive(Debug, Type, EnumString, Serialize, Deserialize, PartialEq, Display)]
#[sqlx(type_name = "sport", rename_all = "snake_case")]
#[strum(serialize_all = "snake_case")]
pub enum Sport {
    kickball,
    baseball,
    softball,
}

#[derive(Debug, Type, EnumString, Serialize, Deserialize, PartialEq)]
#[sqlx(type_name = "score_name", rename_all = "snake_case")]
#[strum(serialize_all = "snake_case")]
pub enum ScoreName {
    Run,
}

#[derive(Debug, Type, EnumString, Serialize, Deserialize, PartialEq)]
#[sqlx(type_name = "trophy_type", rename_all = "snake_case")]
#[strum(serialize_all = "snake_case")]
pub enum TrophyType {
    PerfectAttendance,
    HighScoreGame,
    HighScoreLeague,
    HatTrick,
}

#[derive(Debug, Type, EnumString, Serialize, Deserialize, PartialEq)]
#[sqlx(type_name = "gender", rename_all = "snake_case")]
#[strum(serialize_all = "snake_case")]
pub enum Gender {
    Man,
    Woman,
    Other,
}
