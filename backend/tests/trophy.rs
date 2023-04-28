use squadmaker_backend::services::{fetch_trophies, create_trophy, Trophy, CreateTrophyBody};
use squadmaker_backend::state::AppState;
use squadmaker_backend::enums::TrophyType;
use actix_web::{test, web, App, http::StatusCode, http::header::ContentType};
use bytes::Bytes;

#[sqlx::test]
async fn test_fetch_trophies_is_ok_but_empty(pool: sqlx::PgPool) {
    let app = test::init_service(
        App::new()
            .app_data(web::Data::new(AppState { db: pool }))
            .service(fetch_trophies)
    ).await;
    let request = test::TestRequest::with_uri("/trophies").to_request();
    let response = test::call_service(&app, request).await;

    assert_eq!(response.status(), StatusCode::OK);

    let result = test::read_body(response).await;
    assert_eq!(result, Bytes::from_static(b"[]"))
}

#[sqlx::test(fixtures("players"))]
async fn test_create_trophy_is_ok_and_filled(pool: sqlx::PgPool) {
    let app = test::init_service(
        App::new()
            .app_data(web::Data::new(AppState { db: pool }))
            .service(create_trophy)
    ).await;
    let payload = CreateTrophyBody { trophy_type: String::from("hat_trick") };

    let player_id = 1;
    let request = test::TestRequest::post()
        .uri(&format!("/players/{player_id}/trophies"))
        .insert_header(ContentType::json())
        .set_json(&payload)
        .to_request();
    let response = test::call_service(&app, request).await;

    assert_eq!(response.status(), StatusCode::OK);

    let trophy: Trophy = test::read_body_json(response).await;
    assert_eq!(trophy.id, 1);
    assert_eq!(trophy.player_id, player_id);
    assert_eq!(trophy.trophy_type, TrophyType::HatTrick);
}

#[sqlx::test(fixtures("players"))]
async fn test_create_trophy_fails_without_required_field(pool: sqlx::PgPool) {
    let app = test::init_service(
        App::new()
            .app_data(web::Data::new(AppState { db: pool }))
            .service(create_trophy)
    ).await;
    let payload = r#"{}"#.as_bytes();
    let request = test::TestRequest::post()
        .uri("/players/1/trophies")
        .insert_header(ContentType::json())
        .set_payload(payload)
        .to_request();
    let response = test::call_service(&app, request).await;

    assert_eq!(response.status(), StatusCode::BAD_REQUEST);

    let error = test::read_body(response).await;
    assert!(error.starts_with(b"Json deserialize error: missing field `trophy_type`"))
}

// TODO: this test should eventually fail because people should be told that extra fields are wrong
#[sqlx::test(fixtures("players"))]
async fn test_create_trophy_succeeds_with_extra_field(pool: sqlx::PgPool) {
    let app = test::init_service(
        App::new()
            .app_data(web::Data::new(AppState { db: pool }))
            .service(create_trophy)
    ).await;
    let player_id = 1;
    let payload = r#"{
        "trophy_type": "hat_trick",
        "abcd": 0
    }"#.as_bytes();
    let request = test::TestRequest::post()
        .uri(&format!("/players/1/trophies"))
        .insert_header(ContentType::json())
        .set_payload(payload)
        .to_request();
    let response = test::call_service(&app, request).await;

    assert_eq!(response.status(), StatusCode::OK);

    let trophy: Trophy = test::read_body_json(response).await;
    assert_eq!(trophy.id, 1);
    assert_eq!(trophy.player_id, player_id);
    assert_eq!(trophy.trophy_type, TrophyType::HatTrick);
}
