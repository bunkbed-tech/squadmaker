use std::str::FromStr;

use actix_web::{
    get, post,
    web::{Data, Json, Path},
    Responder, HttpResponse
};
use serde::{Deserialize, Serialize};
use sqlx::{query_as, FromRow};
use time::OffsetDateTime;

use crate::{state::AppState, enums::Sport};

#[derive(Serialize, FromRow, Deserialize)]
pub struct League {
    pub id: i32,
    pub created_at: OffsetDateTime,
    pub name: String,
    pub team_name: String,
    pub sport: Sport,
    pub cost: f32,
    pub captain_id: i32,
    pub games_won: i32,
    pub games_lost: i32,
    pub games_played: i32,
}

#[derive(Deserialize, Serialize)]
pub struct CreateLeagueBody {
    pub name: String,
    pub team_name: String,
    pub sport: Sport,
    pub cost: f32,
}

#[get("/users/{captain_id}/leagues")]
pub async fn fetch_leagues(state: Data<AppState>, path: Path<i32>) -> impl Responder {
    let captain_id = path.into_inner();
    let res: Result<Vec<League>, _> = query_as("SELECT * FROM league WHERE captain_id = $1")
        .bind(captain_id)
        .fetch_all(&state.db)
        .await;
    match res {
        Ok(leagues) => HttpResponse::Ok().json(leagues),
        Err(_) => HttpResponse::NotFound().json("No leagues found"),
    }
}

#[get("/users/{captain_id}/leagues/{league_id}")]
pub async fn fetch_league(state: Data<AppState>, path: Path<(i32, i32)>) -> impl Responder {
    let (_, league_id) = path.into_inner();
    let res: Result<League, _> = query_as("SELECT * FROM league WHERE id = $1")
        .bind(league_id)
        .fetch_one(&state.db)
        .await;
    match res {
        Ok(league) => HttpResponse::Ok().json(league),
        Err(_) => HttpResponse::NotFound().json("League not found"),
    }
}

#[post("/users/{captain_id}/leagues")]
pub async fn create_league(state: Data<AppState>, path: Path<i32>, body: Json<CreateLeagueBody>) -> impl Responder {
    let captain_id = path.into_inner();
    let res: Result<League, _> = query_as(include_str!("../../migrations/services/league/create_league.sql"))
        .bind(&body.name)
        .bind(&body.team_name)
        .bind(Sport::from_str(&body.sport.to_string()).unwrap())
        .bind(&body.cost)
        .bind(captain_id)
        .fetch_one(&state.db)
        .await;
    match res {
        Ok(league) => HttpResponse::Ok().json(league),
        Err(_) => HttpResponse::InternalServerError().json("Failed to create league"),
    }
}
