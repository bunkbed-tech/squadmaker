use squadmaker_backend::services::{fetch_games_attendance, fetch_teammates_attendance, create_attendance, Attendance};
use squadmaker_backend::state::AppState;
use actix_web::{test, web, App, http::StatusCode, http::header::ContentType};
use bytes::Bytes;

#[sqlx::test(fixtures("users", "leagues", "games", "players"))]
async fn test_fetch_games_attendance_passes_if_empty(pool: sqlx::PgPool) {
    let app = test::init_service(
        App::new()
            .app_data(web::Data::new(AppState { db: pool }))
            .service(fetch_games_attendance)
    ).await;
    let request = test::TestRequest::with_uri("/games/1/attendance").to_request();
    let response = test::call_service(&app, request).await;

    assert_eq!(response.status(), StatusCode::OK);

    let result = test::read_body(response).await;
    assert_eq!(result, Bytes::from_static(b"[]"))
}

#[sqlx::test(fixtures("users", "leagues", "games", "players", "teammates", "attendance"))]
async fn test_fetch_games_attendance_passes(pool: sqlx::PgPool) {
    let app = test::init_service(
        App::new()
            .app_data(web::Data::new(AppState { db: pool }))
            .service(fetch_games_attendance)
    ).await;
    let request = test::TestRequest::with_uri(&format!("/games/1/attendance")).to_request();
    let response = test::call_service(&app, request).await;

    assert_eq!(response.status(), StatusCode::OK);

    let attendance: Vec<Attendance> = test::read_body_json(response).await;
    let attendance = attendance.first().unwrap();
    assert_eq!(attendance.id, 1);
    assert_eq!(attendance.game_id, 1);
    assert_eq!(attendance.teammate_id, 1);
}

#[sqlx::test(fixtures("users", "leagues", "games", "players", "teammates", "attendance"))]
async fn test_fetch_teammates_attendance_passes(pool: sqlx::PgPool) {
    let app = test::init_service(
        App::new()
            .app_data(web::Data::new(AppState { db: pool }))
            .service(fetch_teammates_attendance)
    ).await;
    let request = test::TestRequest::with_uri(&format!("/teammates/1/attendance")).to_request();
    let response = test::call_service(&app, request).await;

    assert_eq!(response.status(), StatusCode::OK);

    let attendance: Vec<Attendance> = test::read_body_json(response).await;
    let attendance = attendance.first().unwrap();
    assert_eq!(attendance.id, 1);
    assert_eq!(attendance.game_id, 1);
    assert_eq!(attendance.teammate_id, 1);
}

#[sqlx::test(fixtures("users", "leagues", "games", "players", "teammates"))]
async fn test_create_attendance_fails_without_required_field(pool: sqlx::PgPool) {
    let app = test::init_service(
        App::new()
            .app_data(web::Data::new(AppState { db: pool }))
            .service(create_attendance)
    ).await;
    let payload = r#"{}"#.as_bytes();
    let request = test::TestRequest::post()
        .uri("/games/1/attendance")
        .insert_header(ContentType::json())
        .set_payload(payload)
        .to_request();
    let response = test::call_service(&app, request).await;

    assert_eq!(response.status(), StatusCode::BAD_REQUEST);

    let error = test::read_body(response).await;
    assert!(error.starts_with(b"Json deserialize error: missing field `teammate_id`"))
}

#[sqlx::test(fixtures("users", "leagues", "games", "players", "teammates"))]
async fn test_create_attendance_passes_with_extra_field(pool: sqlx::PgPool) {
    let app = test::init_service(
        App::new()
            .app_data(web::Data::new(AppState { db: pool }))
            .service(create_attendance)
    ).await;
    let payload = r#"{
        "teammate_id": 1,
        "abcd": 1
    }"#.as_bytes();
    let request = test::TestRequest::post()
        .uri("/games/1/attendance")
        .insert_header(ContentType::json())
        .set_payload(payload)
        .to_request();
    let response = test::call_service(&app, request).await;

    assert_eq!(response.status(), StatusCode::OK);

    let attendance: Attendance = test::read_body_json(response).await;
    assert_eq!(attendance.id, 1);
    assert_eq!(attendance.game_id, 1);
    assert_eq!(attendance.teammate_id, 1);
}
