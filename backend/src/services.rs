use actix_web::{
    get, post,
    web::{Data, Json, Path},
    Responder, HttpResponse
};
use serde::{Deserialize, Serialize};
use sqlx::{self, FromRow};
use crate::AppState;

#[derive(Serialize, FromRow)]
struct User {
    id: i64,
    first_name: String,
    last_name: String,
}

#[derive(Serialize, FromRow)]
struct Article {
    id: i64,
    title: String,
    content: String,
    created_by: i64,
}

#[derive(Deserialize)]
pub struct CreateArticleBody {
    pub title: String,
    pub content: String,
}

#[derive(Deserialize)]
pub struct CreateUserBody {
    pub first_name: String,
    pub last_name: String,
}

#[get("/users")]
pub async fn fetch_users(state: Data<AppState>) -> impl Responder {
    match sqlx::query_file_as!(User, "sql/fetch_users.sql")
        .fetch_all(&state.db)
        .await
    {
        Ok(users) => HttpResponse::Ok().json(users),
        Err(_) => HttpResponse::NotFound().json("No users found"),
    }
}

#[get("/users/{id}/articles")]
pub async fn fetch_user_articles(state: Data<AppState>, path: Path<i64>) -> impl Responder {
    let id: i64 = path.into_inner();

    match sqlx::query_file_as!(Article, "sql/fetch_user_articles.sql", id)
        .fetch_all(&state.db)
        .await
    {
        Ok(articles) => HttpResponse::Ok().json(articles),
        Err(_) => HttpResponse::NotFound().json("No articles found"),
    }
}

#[post("/users")]
pub async fn create_user(state: Data<AppState>, body: Json<CreateUserBody>) -> impl Responder {
    let first_name = body.first_name.to_string();
    let last_name = body.last_name.to_string();

    match sqlx::query_file_as!(User, "sql/create_user.sql", first_name, last_name)
        .fetch_one(&state.db)
        .await
    {
        Ok(user) => HttpResponse::Ok().json(user),
        Err(_) => HttpResponse::InternalServerError().json("Failed to create user"),
    }
}

#[post("/users/{id}/articles")]
pub async fn create_user_article(state: Data<AppState>, path: Path<i64>, body: Json<CreateArticleBody>) -> impl Responder {
    let id: i64 = path.into_inner();
    let title = body.title.to_string();
    let content = body.content.to_string();

    match sqlx::query_file_as!(Article, "sql/create_user_article.sql", title, content, id)
        .fetch_one(&state.db)
        .await
    {
        Ok(article) => HttpResponse::Ok().json(article),
        Err(_) => HttpResponse::InternalServerError().json("Failed to create user article"),
    }
}
