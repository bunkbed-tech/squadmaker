use squadmaker_backend::services::{fetch_players, fetch_player, create_player, Player, CreatePlayerBody};
use squadmaker_backend::state::AppState;
use squadmaker_backend::enums::Gender;
use actix_web::{test, web, App, http::StatusCode, http::header::ContentType};
use bytes::Bytes;

#[sqlx::test]
async fn test_fetch_players_is_ok_but_empty(pool: sqlx::PgPool) {
    let app = test::init_service(
        App::new()
            .app_data(web::Data::new(AppState { db: pool }))
            .service(fetch_players)
    ).await;
    let request = test::TestRequest::with_uri("/players").to_request();
    let response = test::call_service(&app, request).await;

    assert_eq!(response.status(), StatusCode::OK);

    let result = test::read_body(response).await;
    assert_eq!(result, Bytes::from_static(b"[]"))
}

#[sqlx::test(fixtures("players"))]
async fn test_fetch_player_is_filled(pool: sqlx::PgPool) {
    let app = test::init_service(
        App::new()
            .app_data(web::Data::new(AppState { db: pool }))
            .service(fetch_player)
    ).await;
    let player_id = 1;
    let request = test::TestRequest::with_uri(&format!("/players/{player_id}")).to_request();
    let response = test::call_service(&app, request).await;

    assert_eq!(response.status(), StatusCode::OK);

    let player: Player = test::read_body_json(response).await;
    assert_eq!(player.id, 1);
    assert_eq!(player.name, String::from("joe"));
    assert_eq!(player.gender, Gender::Man);
    assert_eq!(player.phone, String::from("+11234567890"));
    assert_eq!(player.email, String::from("joe@joe.joe"));
    assert_eq!(player.pronouns, Some(String::from("he/him/his")));
    assert_eq!(player.birthday, Some(String::from("01/01/0001")));
    assert_eq!(player.photo, Some(String::from("joe@starbucks.jpg")));
    assert_eq!(player.place_from, Some(String::from("bethlehem")));
}

#[sqlx::test]
async fn test_create_player_is_ok_and_filled(pool: sqlx::PgPool) {
    let app = test::init_service(
        App::new()
            .app_data(web::Data::new(AppState { db: pool }))
            .service(create_player)
    ).await;
    let payload = CreatePlayerBody {
        name: String::from("Joe"),
        gender: String::from("man"),
        phone: String::from("+11234567890"),
        email: String::from("joe@joe.joe"),
        pronouns: None,
        birthday: None,
        photo: None,
        place_from: None,
    };
    let request = test::TestRequest::post()
        .uri("/players")
        .insert_header(ContentType::json())
        .set_json(&payload)
        .to_request();
    let response = test::call_service(&app, request).await;

    assert_eq!(response.status(), StatusCode::OK);

    let player: Player = test::read_body_json(response).await;
    assert_eq!(player.id, 1);
    assert_eq!(player.name, payload.name);
    assert_eq!(player.gender, Gender::Man);
    assert_eq!(player.phone, payload.phone);
    assert_eq!(player.email, payload.email);
    assert_eq!(player.pronouns, payload.pronouns);
    assert_eq!(player.birthday, payload.birthday);
    assert_eq!(player.photo, payload.photo);
    assert_eq!(player.place_from, payload.place_from);
}

#[sqlx::test]
async fn test_create_player_fails_without_required_field(pool: sqlx::PgPool) {
    let app = test::init_service(
        App::new()
            .app_data(web::Data::new(AppState { db: pool }))
            .service(create_player)
    ).await;
    let payload = r#"{
        "gender": "man",
        "phone": "+11234567890",
        "email": "joe@joe.joe"
    }"#.as_bytes();
    let request = test::TestRequest::post()
        .uri("/players")
        .insert_header(ContentType::json())
        .set_payload(payload)
        .to_request();
    let response = test::call_service(&app, request).await;

    assert_eq!(response.status(), StatusCode::BAD_REQUEST);

    let error = test::read_body(response).await;
    assert!(error.starts_with(b"Json deserialize error: missing field `name`"))
}

// TODO: this test should eventually fail because people should be told that extra fields are wrong
#[sqlx::test]
async fn test_create_player_succeeds_with_extra_field(pool: sqlx::PgPool) {
    let app = test::init_service(
        App::new()
            .app_data(web::Data::new(AppState { db: pool }))
            .service(create_player)
    ).await;
    let payload = r#"{
        "name": "joe",
        "gender": "man",
        "phone": "+11234567890",
        "email": "joe@joe.joe",
        "extra": 0
    }"#.as_bytes();
    let request = test::TestRequest::post()
        .uri("/players")
        .insert_header(ContentType::json())
        .set_payload(payload)
        .to_request();
    let response = test::call_service(&app, request).await;

    assert_eq!(response.status(), StatusCode::OK);

    let player: Player = test::read_body_json(response).await;
    assert_eq!(player.id, 1);
    assert_eq!(player.name, "joe");
    assert_eq!(player.email, "joe@joe.joe");
    assert_eq!(player.gender, Gender::Man);
    assert_eq!(player.phone, "+11234567890");
}
