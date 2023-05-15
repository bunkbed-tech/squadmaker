use squadmaker_backend::services::{fetch_leagues_teammates, fetch_teammate, create_teammate, Teammate};
use squadmaker_backend::state::AppState;
use actix_web::{test, web, App, http::StatusCode, http::header::ContentType};
use bytes::Bytes;

#[sqlx::test(fixtures("users", "leagues"))]
async fn test_fetch_leagues_teammates_passes_if_empty(pool: sqlx::PgPool) {
    let app = test::init_service(
        App::new()
            .app_data(web::Data::new(AppState { db: pool }))
            .service(fetch_leagues_teammates)
    ).await;
    let request = test::TestRequest::with_uri("/leagues/1/teammates").to_request();
    let response = test::call_service(&app, request).await;

    assert_eq!(response.status(), StatusCode::OK);

    let result = test::read_body(response).await;
    assert_eq!(result, Bytes::from_static(b"[]"))
}

#[sqlx::test(fixtures("users", "leagues", "players", "teammates"))]
async fn test_fetch_leagues_teammates_passes(pool: sqlx::PgPool) {
    let app = test::init_service(
        App::new()
            .app_data(web::Data::new(AppState { db: pool }))
            .service(fetch_leagues_teammates)
    ).await;
    let request = test::TestRequest::with_uri(&format!("/leagues/1/teammates")).to_request();
    let response = test::call_service(&app, request).await;

    assert_eq!(response.status(), StatusCode::OK);

    let teammates: Vec<Teammate> = test::read_body_json(response).await;
    let teammate = teammates.first().unwrap();
    assert_eq!(teammate.id, 1);
    assert_eq!(teammate.player_id, 1);
    assert_eq!(teammate.league_id, 1);
    assert_eq!(teammate.paid, Some(true));
}

#[sqlx::test(fixtures("users", "leagues", "players", "teammates"))]
async fn test_fetch_teammate_passes(pool: sqlx::PgPool) {
    let app = test::init_service(
        App::new()
            .app_data(web::Data::new(AppState { db: pool }))
            .service(fetch_teammate)
    ).await;
    let request = test::TestRequest::with_uri(&format!("/leagues/1/teammates/players/1")).to_request();
    let response = test::call_service(&app, request).await;

    assert_eq!(response.status(), StatusCode::OK);

    let teammate: Teammate = test::read_body_json(response).await;
    assert_eq!(teammate.id, 1);
    assert_eq!(teammate.player_id, 1);
    assert_eq!(teammate.league_id, 1);
    assert_eq!(teammate.paid, Some(true));
}

#[sqlx::test(fixtures("users", "leagues", "players"))]
async fn test_create_teammate_fails_without_required_field(pool: sqlx::PgPool) {
    let app = test::init_service(
        App::new()
            .app_data(web::Data::new(AppState { db: pool }))
            .service(create_teammate)
    ).await;
    let payload = r#"{
        "paid": true
    }"#.as_bytes();
    let request = test::TestRequest::post()
        .uri("/leagues/1/teammates")
        .insert_header(ContentType::json())
        .set_payload(payload)
        .to_request();
    let response = test::call_service(&app, request).await;

    assert_eq!(response.status(), StatusCode::BAD_REQUEST);

    let error = test::read_body(response).await;
    assert!(error.starts_with(b"Json deserialize error: missing field `player_id`"))
}

#[sqlx::test(fixtures("users", "leagues", "players"))]
async fn test_create_teammate_passes_with_extra_field(pool: sqlx::PgPool) {
    let app = test::init_service(
        App::new()
            .app_data(web::Data::new(AppState { db: pool }))
            .service(create_teammate)
    ).await;
    let payload = r#"{
        "player_id": 1,
        "paid": false,
        "abcd": 1
    }"#.as_bytes();
    let request = test::TestRequest::post()
        .uri("/leagues/1/teammates")
        .insert_header(ContentType::json())
        .set_payload(payload)
        .to_request();
    let response = test::call_service(&app, request).await;

    assert_eq!(response.status(), StatusCode::OK);

    let teammate: Teammate = test::read_body_json(response).await;
    assert_eq!(teammate.id, 1);
    assert_eq!(teammate.player_id, 1);
    assert_eq!(teammate.league_id, 1);
    assert_eq!(teammate.paid, Some(false));
}

#[sqlx::test(fixtures("users", "leagues", "players"))]
async fn test_create_teammate_passes_for_free_league(pool: sqlx::PgPool) {
    let app = test::init_service(
        App::new()
            .app_data(web::Data::new(AppState { db: pool }))
            .service(create_teammate)
    ).await;
    let payload = r#"{
        "player_id": 1
    }"#.as_bytes();
    let request = test::TestRequest::post()
        .uri("/leagues/1/teammates")
        .insert_header(ContentType::json())
        .set_payload(payload)
        .to_request();
    let response = test::call_service(&app, request).await;

    assert_eq!(response.status(), StatusCode::OK);

    let teammate: Teammate = test::read_body_json(response).await;
    assert_eq!(teammate.id, 1);
    assert_eq!(teammate.player_id, 1);
    assert_eq!(teammate.league_id, 1);
    assert_eq!(teammate.paid, None);
}

#[sqlx::test(fixtures("users", "leagues", "players"))]
async fn test_create_teammate_passes_with_optionals(pool: sqlx::PgPool) {
    let app = test::init_service(
        App::new()
            .app_data(web::Data::new(AppState { db: pool }))
            .service(create_teammate)
    ).await;
    let payload = r#"{
        "player_id": 1,
        "paid": true
    }"#.as_bytes();
    let request = test::TestRequest::post()
        .uri("/leagues/1/teammates")
        .insert_header(ContentType::json())
        .set_payload(payload)
        .to_request();
    let response = test::call_service(&app, request).await;

    assert_eq!(response.status(), StatusCode::OK);

    let teammate: Teammate = test::read_body_json(response).await;
    assert_eq!(teammate.id, 1);
    assert_eq!(teammate.player_id, 1);
    assert_eq!(teammate.league_id, 1);
    assert_eq!(teammate.paid, Some(true));
}
