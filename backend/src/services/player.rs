use std::str::FromStr;

use actix_web::{
    get, post,
    web::{Data, Json},
    Responder, HttpResponse
};
use serde::{Deserialize, Serialize};
use sqlx::{query_as, FromRow};
use time::OffsetDateTime;

use crate::{state::AppState, enums::Gender};

#[derive(Serialize, FromRow, Deserialize)]
pub struct Player {
    pub id: i32,
    pub created_at: OffsetDateTime,
    pub name: String,
    pub gender: Gender,
    pub pronouns: Option<String>,
    pub birthday: Option<String>,
    pub phone: String,
    pub email: String,
    pub place_from: Option<String>,
    pub photo: Option<String>,
    pub score_all_time: i32,
    pub score_avg_per_game: Option<f32>,
    pub games_attended: i32,
}

#[derive(Deserialize, Serialize)]
pub struct CreatePlayerBody {
    pub name: String,
    pub gender: String,
    pub phone: String,
    pub email: String,
    pub pronouns: Option<String>,
    pub birthday: Option<String>,
    pub place_from: Option<String>,
    pub photo: Option<String>,
}

#[get("/players")]
pub async fn fetch_players(state: Data<AppState>) -> impl Responder {
    let res: Result<Vec<Player>, _> = query_as("SELECT * FROM player").fetch_all(&state.db).await;
    match res {
        Ok(players) => HttpResponse::Ok().json(players),
        Err(_) => HttpResponse::NotFound().json("No players found"),
    }
}

#[post("/players")]
pub async fn create_player(state: Data<AppState>, body: Json<CreatePlayerBody>) -> impl Responder {
    let res: Result<Player, _> = query_as(include_str!("../../migrations/services/player/create_player.sql"))
        .bind(body.name.to_string())
        .bind(Gender::from_str(&body.gender.to_string()).unwrap())
        .bind(&body.phone)
        .bind(&body.email)
        .bind(&body.pronouns)
        .bind(&body.birthday)
        .bind(&body.place_from)
        .bind(&body.photo)
        .fetch_one(&state.db)
        .await;
    match res {
        Ok(player) => HttpResponse::Ok().json(player),
        Err(_) => HttpResponse::InternalServerError().json("Failed to create player"),
    }
}
