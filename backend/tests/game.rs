use squadmaker_backend::services::{fetch_leagues_games, fetch_game, create_game, Game, CreateGameBody};
use squadmaker_backend::state::AppState;
use actix_web::{test, web, App, http::StatusCode, http::header::ContentType};
use bytes::Bytes;
use time::macros::datetime;

#[sqlx::test(fixtures("users", "leagues"))]
async fn test_fetch_leagues_games_is_ok_but_empty(pool: sqlx::PgPool) {
    let app = test::init_service(
        App::new()
            .app_data(web::Data::new(AppState { db: pool }))
            .service(fetch_leagues_games)
    ).await;
    let request = test::TestRequest::with_uri("/leagues/1/games").to_request();
    let response = test::call_service(&app, request).await;

    assert_eq!(response.status(), StatusCode::OK);

    let result = test::read_body(response).await;
    assert_eq!(result, Bytes::from_static(b"[]"))
}

#[sqlx::test(fixtures("users", "leagues", "games"))]
async fn test_fetch_leagues_games_is_filled(pool: sqlx::PgPool) {
    let app = test::init_service(
        App::new()
            .app_data(web::Data::new(AppState { db: pool }))
            .service(fetch_leagues_games)
    ).await;
    let request = test::TestRequest::with_uri(&format!("/leagues/1/games")).to_request();
    let response = test::call_service(&app, request).await;

    assert_eq!(response.status(), StatusCode::OK);

    let games: Vec<Game> = test::read_body_json(response).await;
    let game = games.first().unwrap();
    assert_eq!(game.id, 1);
    assert_eq!(game.opponent_name, String::from("the bad guys"));
    assert_eq!(game.game_location, String::from("the ball field"));
    assert_eq!(game.start_datetime, datetime!(2022-05-06 14:30:00+02:00));
    assert_eq!(game.league_id, 1);
    assert_eq!(game.your_score, 0);
    assert_eq!(game.opponent_score, 0);
    assert_eq!(game.group_photo, None);
}

#[sqlx::test(fixtures("users", "leagues", "games"))]
async fn test_fetch_game_is_filled(pool: sqlx::PgPool) {
    let app = test::init_service(
        App::new()
            .app_data(web::Data::new(AppState { db: pool }))
            .service(fetch_game)
    ).await;
    let request = test::TestRequest::with_uri(&format!("/games/1")).to_request();
    let response = test::call_service(&app, request).await;

    assert_eq!(response.status(), StatusCode::OK);

    let game: Game = test::read_body_json(response).await;
    assert_eq!(game.id, 1);
    assert_eq!(game.opponent_name, String::from("the bad guys"));
    assert_eq!(game.game_location, String::from("the ball field"));
    assert_eq!(game.start_datetime, datetime!(2022-05-06 14:30:00+02:00));
    assert_eq!(game.league_id, 1);
    assert_eq!(game.your_score, 0);
    assert_eq!(game.opponent_score, 0);
    assert_eq!(game.group_photo, None);
}

#[sqlx::test(fixtures("users", "leagues"))]
async fn test_create_game_is_ok_and_filled(pool: sqlx::PgPool) {
    let app = test::init_service(
        App::new()
            .app_data(web::Data::new(AppState { db: pool }))
            .service(create_game)
    ).await;
    let payload = CreateGameBody {
        opponent_name: String::from("the bad guys"),
        game_location: String::from("the ball field"),
        start_datetime: datetime!(2022-05-06 14:30:00+02:00),
    };
    let request = test::TestRequest::post()
        .uri("/leagues/1/games")
        .insert_header(ContentType::json())
        .set_json(&payload)
        .to_request();
    let response = test::call_service(&app, request).await;

    assert_eq!(response.status(), StatusCode::OK);

    let game: Game = test::read_body_json(response).await;
    assert_eq!(game.id, 1);
    assert_eq!(game.opponent_name, String::from("the bad guys"));
    assert_eq!(game.game_location, String::from("the ball field"));
    assert_eq!(game.start_datetime, datetime!(2022-05-06 14:30:00+02:00));
    assert_eq!(game.league_id, 1);
    assert_eq!(game.your_score, 0);
    assert_eq!(game.opponent_score, 0);
    assert_eq!(game.group_photo, None);
}

#[sqlx::test(fixtures("users", "leagues"))]
async fn test_create_game_fails_without_required_field(pool: sqlx::PgPool) {
    let app = test::init_service(
        App::new()
            .app_data(web::Data::new(AppState { db: pool }))
            .service(create_game)
    ).await;
    let payload = r#"{
        "opponent_name": "the bad guys",
        "game_location": "the ball field"
    }"#.as_bytes();
    let request = test::TestRequest::post()
        .uri("/leagues/1/games")
        .insert_header(ContentType::json())
        .set_payload(payload)
        .to_request();
    let response = test::call_service(&app, request).await;

    assert_eq!(response.status(), StatusCode::BAD_REQUEST);

    let error = test::read_body(response).await;
    assert!(error.starts_with(b"Json deserialize error: missing field `start_datetime`"))
}

// TODO: this test should eventually fail because people should be told that extra fields are wrong
#[sqlx::test(fixtures("users", "leagues"))]
async fn test_create_game_succeeds_with_extra_field(pool: sqlx::PgPool) {
    let app = test::init_service(
        App::new()
            .app_data(web::Data::new(AppState { db: pool }))
            .service(create_game)
    ).await;
    let payload = r#"{
        "opponent_name": "the bad guys",
        "game_location": "the ball field",
        "start_datetime": "2022-05-06T14:30+02:00",
        "abcd": 1
    }"#.as_bytes();
    let request = test::TestRequest::post()
        .uri("/leagues/1/games")
        .insert_header(ContentType::json())
        .set_payload(payload)
        .to_request();
    let response = test::call_service(&app, request).await;
    assert_eq!(response.status(), StatusCode::OK);

    let game: Game = test::read_body_json(response).await;
    assert_eq!(game.id, 1);
    assert_eq!(game.opponent_name, String::from("the bad guys"));
    assert_eq!(game.game_location, String::from("the ball field"));
    assert_eq!(game.start_datetime, datetime!(2022-05-06 14:30:00+02:00));
    assert_eq!(game.league_id, 1);
    assert_eq!(game.your_score, 0);
    assert_eq!(game.opponent_score, 0);
    assert_eq!(game.group_photo, None);
}
