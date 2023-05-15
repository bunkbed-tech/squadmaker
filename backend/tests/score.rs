use squadmaker_backend::services::{fetch_game_scores, fetch_player_scores, fetch_league_scores, create_score, Score};
use squadmaker_backend::state::AppState;
use actix_web::{test, web, App, http::StatusCode, http::header::ContentType};
use bytes::Bytes;

#[sqlx::test(fixtures("users", "leagues", "games", "players"))]
async fn test_fetch_game_scores_passes_if_empty(pool: sqlx::PgPool) {
    let app = test::init_service(
        App::new()
            .app_data(web::Data::new(AppState { db: pool }))
            .service(fetch_game_scores)
    ).await;
    let request = test::TestRequest::with_uri("/games/1/scores").to_request();
    let response = test::call_service(&app, request).await;

    assert_eq!(response.status(), StatusCode::OK);

    let result = test::read_body(response).await;
    assert_eq!(result, Bytes::from_static(b"[]"))
}

#[sqlx::test(fixtures("users", "leagues", "games", "players", "scores"))]
async fn test_fetch_player_scores_passes(pool: sqlx::PgPool) {
    let app = test::init_service(
        App::new()
            .app_data(web::Data::new(AppState { db: pool }))
            .service(fetch_player_scores)
    ).await;
    let request = test::TestRequest::with_uri(&format!("/players/1/scores")).to_request();
    let response = test::call_service(&app, request).await;

    assert_eq!(response.status(), StatusCode::OK);

    let scores: Vec<Score> = test::read_body_json(response).await;
    let scores = scores.first().unwrap();
    assert_eq!(scores.id, 1);
    assert_eq!(scores.player_id, 1);
    assert_eq!(scores.game_id, 1);
    assert_eq!(scores.score_type_id, 1);
}

#[sqlx::test(fixtures("users", "leagues", "games", "players", "scores"))]
async fn test_fetch_league_scores_passes(pool: sqlx::PgPool) {
    let app = test::init_service(
        App::new()
            .app_data(web::Data::new(AppState { db: pool }))
            .service(fetch_league_scores)
    ).await;
    let request = test::TestRequest::with_uri(&format!("/leagues/1/scores")).to_request();
    let response = test::call_service(&app, request).await;

    assert_eq!(response.status(), StatusCode::OK);

    let scores: Vec<Score> = test::read_body_json(response).await;
    let scores = scores.first().unwrap();
    assert_eq!(scores.id, 1);
    assert_eq!(scores.player_id, 1);
    assert_eq!(scores.game_id, 1);
    assert_eq!(scores.score_type_id, 1);
}


#[sqlx::test(fixtures("users", "leagues", "games", "players"))]
async fn test_create_score_fails_without_required_field(pool: sqlx::PgPool) {
    let app = test::init_service(
        App::new()
            .app_data(web::Data::new(AppState { db: pool }))
            .service(create_score)
    ).await;
    let payload = r#"{
        "player_id": 1
    }"#.as_bytes();
    let request = test::TestRequest::post()
        .uri("/games/1/scores")
        .insert_header(ContentType::json())
        .set_payload(payload)
        .to_request();
    let response = test::call_service(&app, request).await;

    assert_eq!(response.status(), StatusCode::BAD_REQUEST);

    let error = test::read_body(response).await;
    assert!(error.starts_with(b"Json deserialize error: missing field `score_type_id`"))
}

#[sqlx::test(fixtures("users", "leagues", "games", "players"))]
async fn test_create_score_passes_with_extra_field(pool: sqlx::PgPool) {
    let app = test::init_service(
        App::new()
            .app_data(web::Data::new(AppState { db: pool }))
            .service(create_score)
    ).await;
    let payload = r#"{
        "player_id": 1,
        "score_type_id": 1,
        "abcd": 1
    }"#.as_bytes();
    let request = test::TestRequest::post()
        .uri("/games/1/scores")
        .insert_header(ContentType::json())
        .set_payload(payload)
        .to_request();
    let response = test::call_service(&app, request).await;

    assert_eq!(response.status(), StatusCode::OK);

    let score: Score = test::read_body_json(response).await;
    assert_eq!(score.id, 1);
    assert_eq!(score.player_id, 1);
    assert_eq!(score.game_id, 1);
    assert_eq!(score.score_type_id, 1);
}
