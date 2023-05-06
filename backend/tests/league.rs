use squadmaker_backend::services::{fetch_leagues, fetch_league, create_league, League, CreateLeagueBody};
use squadmaker_backend::state::AppState;
use squadmaker_backend::enums::Sport;
use actix_web::{test, web, App, http::StatusCode, http::header::ContentType};
use bytes::Bytes;

#[sqlx::test(fixtures("users"))]
async fn test_fetch_leagues_is_ok_but_empty(pool: sqlx::PgPool) {
    let app = test::init_service(
        App::new()
            .app_data(web::Data::new(AppState { db: pool }))
            .service(fetch_leagues)
    ).await;
    let request = test::TestRequest::with_uri("/users/1/leagues").to_request();
    let response = test::call_service(&app, request).await;

    assert_eq!(response.status(), StatusCode::OK);

    let result = test::read_body(response).await;
    assert_eq!(result, Bytes::from_static(b"[]"))
}

#[sqlx::test(fixtures("users", "leagues"))]
async fn test_fetch_league_is_filled(pool: sqlx::PgPool) {
    let app = test::init_service(
        App::new()
            .app_data(web::Data::new(AppState { db: pool }))
            .service(fetch_league)
    ).await;
    let request = test::TestRequest::with_uri(&format!("/users/1/leagues/1")).to_request();
    let response = test::call_service(&app, request).await;

    assert_eq!(response.status(), StatusCode::OK);

    let league: League = test::read_body_json(response).await;
    assert_eq!(league.id, 1);
    assert_eq!(league.name, String::from("the league"));
    assert_eq!(league.team_name, String::from("joezinhos"));
    assert_eq!(league.sport, Sport::kickball);
    assert_eq!(league.captain_id, 1);
    assert_eq!(league.games_won, 0);
    assert_eq!(league.games_lost, 0);
    assert_eq!(league.games_played, 0);
}

#[sqlx::test(fixtures("users"))]
async fn test_create_league_is_ok_and_filled(pool: sqlx::PgPool) {
    let app = test::init_service(
        App::new()
            .app_data(web::Data::new(AppState { db: pool }))
            .service(create_league)
    ).await;
    let payload = CreateLeagueBody {
        name: String::from("the league"),
        team_name: String::from("joezinhos"),
        sport: Sport::kickball,
    };
    let request = test::TestRequest::post()
        .uri("/users/1/leagues")
        .insert_header(ContentType::json())
        .set_json(&payload)
        .to_request();
    let response = test::call_service(&app, request).await;

    assert_eq!(response.status(), StatusCode::OK);

    let league: League = test::read_body_json(response).await;
    assert_eq!(league.id, 1);
    assert_eq!(league.name, payload.name);
    assert_eq!(league.team_name, payload.team_name);
    assert_eq!(league.sport, payload.sport);
    assert_eq!(league.captain_id, 1);
    assert_eq!(league.games_won, 0);
    assert_eq!(league.games_lost, 0);
    assert_eq!(league.games_played, 0);
}

#[sqlx::test(fixtures("users"))]
async fn test_create_league_fails_without_required_field(pool: sqlx::PgPool) {
    let app = test::init_service(
        App::new()
            .app_data(web::Data::new(AppState { db: pool }))
            .service(create_league)
    ).await;
    let payload = r#"{
        "name": "the league",
        "team_name": "joezinhos"
    }"#.as_bytes();
    let request = test::TestRequest::post()
        .uri("/users/1/leagues")
        .insert_header(ContentType::json())
        .set_payload(payload)
        .to_request();
    let response = test::call_service(&app, request).await;

    assert_eq!(response.status(), StatusCode::BAD_REQUEST);

    let error = test::read_body(response).await;
    assert!(error.starts_with(b"Json deserialize error: missing field `sport`"))
}

// TODO: this test should eventually fail because people should be told that extra fields are wrong
#[sqlx::test(fixtures("users"))]
async fn test_create_league_succeeds_with_extra_field(pool: sqlx::PgPool) {
    let app = test::init_service(
        App::new()
            .app_data(web::Data::new(AppState { db: pool }))
            .service(create_league)
    ).await;
    let payload = r#"{
        "name": "the league",
        "team_name": "joezinhos",
        "sport": "kickball",
        "extra": 0
    }"#.as_bytes();
    let request = test::TestRequest::post()
        .uri("/users/1/leagues")
        .insert_header(ContentType::json())
        .set_payload(payload)
        .to_request();
    let response = test::call_service(&app, request).await;

    assert_eq!(response.status(), StatusCode::OK);

    let league: League = test::read_body_json(response).await;
    assert_eq!(league.id, 1);
    assert_eq!(league.name, String::from("the league"));
    assert_eq!(league.team_name, String::from("joezinhos"));
    assert_eq!(league.sport, Sport::kickball);
    assert_eq!(league.captain_id, 1);
    assert_eq!(league.games_won, 0);
    assert_eq!(league.games_lost, 0);
    assert_eq!(league.games_played, 0);
}
