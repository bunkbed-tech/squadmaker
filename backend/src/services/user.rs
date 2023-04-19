use actix_web::{
    get, post,
    web::{Data, Json},
    Responder, HttpResponse
};
use serde::{Deserialize, Serialize};
use sqlx::{query_as, FromRow};
use time::OffsetDateTime;

use crate::state::AppState;

#[derive(Serialize, FromRow, Deserialize)]
pub struct User {
    pub id: i32,
    pub created_at: OffsetDateTime,
    pub name: String,
    pub email: String,
    pub username: String,
    pub avatar: String,
}

#[derive(Deserialize, Serialize)]
pub struct CreateUserBody {
    pub name: String,
    pub email: String,
    pub username: String,
    pub password_hash: String,
    pub avatar: String,
}

#[get("/users")]
pub async fn fetch_users(state: Data<AppState>) -> impl Responder {
    let res: Result<Vec<User>, _> = query_as("SELECT * FROM \"user\"").fetch_all(&state.db).await;
    match res {
        Ok(users) => HttpResponse::Ok().json(users),
        Err(_) => HttpResponse::NotFound().json("No users found"),
    }
}

#[post("/users")]
pub async fn create_user(state: Data<AppState>, body: Json<CreateUserBody>) -> impl Responder {
    let res: Result<User, _> = query_as(include_str!("../../sql/services/user/create_user.sql"))
        .bind(&body.name)
        .bind(&body.email)
        .bind(&body.username)
        .bind(&body.password_hash)
        .bind(&body.avatar)
        .fetch_one(&state.db)
        .await;
    match res {
        Ok(user) => HttpResponse::Ok().json(user),
        Err(_) => HttpResponse::InternalServerError().json("Failed to create user"),
    }
}
