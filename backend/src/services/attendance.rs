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
pub struct Attendance {
    pub id: i32,
    pub created_at: OffsetDateTime,
    pub game_id: i32,
    pub teammate_id: i32,
}

#[derive(Deserialize, Serialize)]
pub struct CreateAttendanceBody {
    pub teammate_id: i32,
}

#[get("/games/{game_id}/attendance")]
pub async fn fetch_games_attendance(state: Data<AppState>, path: Path<i32>) -> impl Responder {
    let game_id = path.into_inner();
    let res: Result<Vec<Attendance>, _> = query_as("SELECT * FROM attendance WHERE game_id = $1")
        .bind(game_id)
        .fetch_all(&state.db)
        .await;
    match res {
        Ok(attendance) => HttpResponse::Ok().json(attendance),
        Err(_) => HttpResponse::NotFound().json(&format!("No attendance found for game id '{game_id}'")),
    }
}

#[get("/teammates/{teammate_id}/attendance")]
pub async fn fetch_teammates_attendance(state: Data<AppState>, path: Path<i32>) -> impl Responder {
    let teammate_id = path.into_inner();
    let res: Result<Vec<Attendance>, _> = query_as("SELECT * FROM attendance WHERE teammate_id = $1")
        .bind(teammate_id)
        .fetch_all(&state.db)
        .await;
    match res {
        Ok(attendance) => HttpResponse::Ok().json(attendance),
        Err(_) => HttpResponse::NotFound().json(&format!("No attendance found for teammate id '{teammate_id}'")),
    }
}

#[post("/games/{game_id}/attendance")]
pub async fn create_attendance(state: Data<AppState>, path: Path<i32>, body: Json<CreateAttendanceBody>) -> impl Responder {
    let game_id = path.into_inner();
    let res: Result<Attendance, _> = query_as(include_str!("../../migrations/services/attendance/create_attendance.sql"))
        .bind(game_id)
        .bind(&body.teammate_id)
        .fetch_one(&state.db)
        .await;
    match res {
        Ok(attendance) => HttpResponse::Ok().json(attendance),
        Err(_) => HttpResponse::InternalServerError().json("Failed to create attendance"),
    }
}
