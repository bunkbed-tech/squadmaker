use squadmaker_backend::services::{fetch_score_types, ScoreType};
use squadmaker_backend::state::AppState;
use squadmaker_backend::enums::{ScoreName, Sport};
use actix_web::{test, web, App, http::StatusCode};

#[sqlx::test]
async fn test_fetch_score_types_returns_all(pool: sqlx::PgPool) {
    let app = test::init_service(
        App::new()
            .app_data(web::Data::new(AppState { db: pool }))
            .service(fetch_score_types)
    ).await;

    let request = test::TestRequest::with_uri("/score_types/softball").to_request();
    let response = test::call_service(&app, request).await;

    assert_eq!(response.status(), StatusCode::OK);

    let score_types: Vec<ScoreType> = test::read_body_json(response).await;
    assert_eq!(score_types.len(), 1);
    let score_type = score_types.first().unwrap();
    assert_eq!(score_type.id, 3);
    assert_eq!(score_type.sport, Sport::softball);
    assert_eq!(score_type.name, ScoreName::Run);
}

