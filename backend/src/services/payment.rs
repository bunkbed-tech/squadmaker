use actix_web::{
    get, post,
    web::{Data, Path},
    Responder, HttpResponse
};
use serde::{Deserialize, Serialize};
use sqlx::{query_as, FromRow};
use time::OffsetDateTime;

use crate::{state::AppState};

#[derive(Serialize, FromRow, Deserialize)]
pub struct Payment {
    pub id: i32,
    pub created_at: OffsetDateTime,
    pub player_id: i32,
    pub league_id: i32,
    pub paid: bool,
}

#[get("/leagues/{league_id}/payments")]
pub async fn fetch_leagues_payments(state: Data<AppState>, path: Path<i32>) -> impl Responder {
    let league_id = path.into_inner();
    let res: Result<Vec<Payment>, _> = query_as("SELECT * FROM payment WHERE league_id = $1")
        .bind(league_id)
        .fetch_all(&state.db)
        .await;
    match res {
        Ok(payments) => HttpResponse::Ok().json(payments),
        Err(_) => HttpResponse::NotFound().json(&format!("No games found for league id '{league_id}'")),
    }
}

#[post("/leagues/{league_id}/payments/players/{player_id}")]
pub async fn create_payment(state: Data<AppState>, path: Path<(i32, i32)>) -> impl Responder {
    let (league_id, player_id) = path.into_inner();
    let res: Result<Payment, _> = query_as(include_str!("../../migrations/services/payment/create_payment.sql"))
        .bind(league_id)
        .bind(player_id)
        .bind(true)
        .fetch_one(&state.db)
        .await;
    match res {
        Ok(payment) => HttpResponse::Ok().json(payment),
        Err(_) => HttpResponse::InternalServerError().json("Failed to create payment"),
    }
}

#[get("/leagues/{league_id}/payments/players/{player_id}")]
pub async fn fetch_payment(state: Data<AppState>, path: Path<(i32, i32)>) -> impl Responder {
    let (league_id, player_id) = path.into_inner();
    let res: Result<Payment, _> = query_as("SELECT * FROM payment WHERE league_id = $1 AND player_id = $2")
        .bind(league_id)
        .bind(player_id)
        .fetch_one(&state.db)
        .await;
    match res {
        Ok(payment) => HttpResponse::Ok().json(payment),
        Err(_) => {
            let message = format!("No payment to league id '{league_id}' found for player id '{player_id}'");
            HttpResponse::InternalServerError().json(message)
        },
    }
}
