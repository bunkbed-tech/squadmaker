use std::str::FromStr;

use actix_web::{
    get, post,
    web::{Data, Json, Path},
    Responder, HttpResponse
};
use serde::{Deserialize, Serialize};
use sqlx::{query_as, FromRow};
use time::OffsetDateTime;

use crate::{
    state::AppState,
    enums::TrophyType,
};

#[derive(Serialize, FromRow, Deserialize)]
pub struct Trophy {
    pub id: i32,
    pub created_at: OffsetDateTime,
    pub player_id: i32,
    pub trophy_type: TrophyType,
}

#[derive(Deserialize, Serialize)]
pub struct CreateTrophyBody {
    pub trophy_type: String,
}

#[get("/trophies")]
pub async fn fetch_trophies(state: Data<AppState>) -> impl Responder {
    let res: Result<Vec<Trophy>, _> = query_as("SELECT * FROM trophy").fetch_all(&state.db).await;
    match res {
        Ok(trophies) => HttpResponse::Ok().json(trophies),
        Err(_) => HttpResponse::NotFound().json("No trophies found"),
    }
}

#[post("/players/{id}/trophies")]
pub async fn create_trophy(state: Data<AppState>, path: Path<i32>, body: Json<CreateTrophyBody>) -> impl Responder {
    let id = path.into_inner();
    let res: Result<Trophy, _> = query_as(include_str!("../../migrations/services/trophy/create_trophy.sql"))
        .bind(id)
        .bind(TrophyType::from_str(&body.trophy_type.to_string()).unwrap())
        .fetch_one(&state.db)
        .await;
    match res {
        Ok(trophy) => HttpResponse::Ok().json(trophy),
        Err(_) => HttpResponse::InternalServerError().json("Failed to create trophy"),
    }
}
