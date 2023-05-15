use actix_web::{
    get, post,
    web::{Data, Json, Path},
    Responder, HttpResponse
};
use serde::{Deserialize, Serialize};
use sqlx::{query_as, FromRow};
use time::OffsetDateTime;

use crate::{state::AppState};

#[derive(Serialize, FromRow, Deserialize)]
pub struct Score {
    pub id: i32,
    pub created_at: OffsetDateTime,
    pub game_id: i32,
    pub player_id: i32,
    pub score_type_id: i32,
}

#[derive(Deserialize, Serialize)]
pub struct CreateScoreBody {
    pub player_id: i32,
    pub score_type_id: i32,
}

#[get("/games/{game_id}/scores")]
pub async fn fetch_game_scores(state: Data<AppState>, path: Path<i32>) -> impl Responder {
    let game_id = path.into_inner();
    let res: Result<Vec<Score>, _> = query_as("SELECT * FROM score WHERE game_id = $1")
        .bind(game_id)
        .fetch_all(&state.db)
        .await;
    match res {
        Ok(scores) => HttpResponse::Ok().json(scores),
        Err(_) => HttpResponse::NotFound().json(&format!("No scores found for game id '{game_id}'")),
    }
}

#[get("/players/{player_id}/scores")]
pub async fn fetch_player_scores(state: Data<AppState>, path: Path<i32>) -> impl Responder {
    let player_id = path.into_inner();
    let res: Result<Vec<Score>, _> = query_as("SELECT * FROM score WHERE player_id = $1")
        .bind(player_id)
        .fetch_all(&state.db)
        .await;
    match res {
        Ok(scores) => HttpResponse::Ok().json(scores),
        Err(_) => HttpResponse::NotFound().json(&format!("No scores found for player id '{player_id}'")),
    }
}

#[get("/leagues/{league_id}/scores")]
pub async fn fetch_league_scores(state: Data<AppState>, path: Path<i32>) -> impl Responder {
    let league_id = path.into_inner();
    let res: Result<Vec<Score>, _> = query_as(
        "SELECT score.*
        FROM score 
        JOIN game ON score.game_id = game.id 
        WHERE game.league_id = $1"
    )
        .bind(league_id)
        .fetch_all(&state.db)
        .await;
    match res {
        Ok(scores) => HttpResponse::Ok().json(scores),
        Err(_) => HttpResponse::NotFound().json(&format!("No scores found for league id '{league_id}'")),
    }
}

#[post("/games/{game_id}/scores")]
pub async fn create_score(state: Data<AppState>, path: Path<i32>, body: Json<CreateScoreBody>) -> impl Responder {
    let game_id = path.into_inner();
    let res: Result<Score, _> = query_as(include_str!("../../migrations/services/score/create_score.sql"))
        .bind(game_id)
        .bind(&body.player_id)
        .bind(&body.score_type_id)
        .fetch_one(&state.db)
        .await;
    match res {
        Ok(score) => HttpResponse::Ok().json(score),
        Err(_) => HttpResponse::InternalServerError().json("Failed to create score"),
    }
}
