use std::env::var;

use actix_web::{web::Data, App, HttpServer};
use dotenv::dotenv;
use sqlx::{postgres::PgPoolOptions};

use squadmaker_backend::{
    state::AppState,
    services::{
        user::{create_user, fetch_users},
        player::{create_player, fetch_players},
        score_type::fetch_score_types,
        league::{create_league, fetch_league, fetch_leagues},
        game::{create_game, fetch_leagues_games, fetch_game},
        teammate::{create_teammate, fetch_leagues_teammates, fetch_teammate},
        score::{fetch_game_scores, fetch_player_scores, fetch_league_scores, create_score},
        attendance::{fetch_games_attendance, fetch_teammates_attendance, create_attendance}
    },
};

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    dotenv().ok();
    let database_url = var("DATABASE_URL").expect("DATABASE_URL must be set in .env");
    let pool = PgPoolOptions::new()
        .max_connections(5)
        .connect(&database_url)
        .await
        .expect("Error building a connection pool");

    HttpServer::new(move || {
        App::new()
            .app_data(Data::new(AppState { db: pool.clone() }))
            .service(fetch_users)
            .service(create_user)
            .service(fetch_players)
            .service(create_player)
            .service(fetch_score_types)
            .service(fetch_league)
            .service(fetch_leagues)
            .service(create_league)
            .service(create_game)
            .service(fetch_leagues_games)
            .service(fetch_game)
            .service(create_teammate)
            .service(fetch_teammate)
            .service(fetch_leagues_teammates)
            .service(fetch_game_scores)
            .service(fetch_player_scores)
            .service(fetch_league_scores)
            .service(create_score)
            .service(fetch_games_attendance)
            .service(fetch_teammates_attendance)
            .service(create_attendance)
    })
    .bind(("127.0.0.1", 8080))?
    .run()
    .await
}
