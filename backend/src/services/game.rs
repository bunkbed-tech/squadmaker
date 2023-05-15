use actix_web::{
    get, post,
    web::{Data, Json, Path},
    Responder, HttpResponse
};
use serde::{Deserialize, Serialize};
use sqlx::{query_as, FromRow};
use time::{OffsetDateTime, serde::iso8601};

use crate::{state::AppState};

#[derive(Serialize, FromRow, Deserialize)]
pub struct Game {
    pub id: i32,
    pub created_at: OffsetDateTime,
    pub opponent_name: String,
    pub game_location: String,
    pub start_datetime: OffsetDateTime,
    pub league_id: i32,
    pub your_score: i32,
    pub opponent_score: i32,
    pub group_photo: Option<String>,
}

#[derive(Deserialize, Serialize)]
pub struct CreateGameBody {
    pub opponent_name: String,
    pub game_location: String,
    #[serde(with = "iso8601")]
    pub start_datetime: OffsetDateTime,
}

#[get("/leagues/{league_id}/games")]
pub async fn fetch_leagues_games(state: Data<AppState>, path: Path<i32>) -> impl Responder {
    let league_id = path.into_inner();
    let res: Result<Vec<Game>, _> = query_as("SELECT * FROM game where league_id = $1")
        .bind(league_id)
        .fetch_all(&state.db)
        .await;
    match res {
        Ok(games) => HttpResponse::Ok().json(games),
        Err(_) => HttpResponse::NotFound().json(&format!("No games found for league id '{league_id}'")),
    }
}

#[post("/leagues/{league_id}/games")]
pub async fn create_game(state: Data<AppState>, body: Json<CreateGameBody>, path: Path<i32>) -> impl Responder {
    let league_id = path.into_inner();
    let res: Result<Game, _> = query_as(include_str!("../../migrations/services/game/create_game.sql"))
        .bind(&body.opponent_name)
        .bind(&body.game_location)
        .bind(&body.start_datetime)
        .bind(league_id)
        .fetch_one(&state.db)
        .await;
    match res {
        Ok(game) => HttpResponse::Ok().json(game),
        Err(_) => HttpResponse::InternalServerError().json("Failed to create game"),
    }
}

#[get("/games/{game_id}")]
pub async fn fetch_game(state: Data<AppState>, path: Path<i32>) -> impl Responder {
    let game_id = path.into_inner();
    let res: Result<Game, _> = query_as("SELECT * FROM game where id = $1")
        .bind(game_id)
        .fetch_one(&state.db)
        .await;
    match res {
        Ok(game) => HttpResponse::Ok().json(game),
        Err(_) => HttpResponse::InternalServerError().json(format!("No game found for game id '{game_id}'")),
    }
}
