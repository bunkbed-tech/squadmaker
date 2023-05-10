use squadmaker_backend::services::{fetch_leagues_payments, fetch_payment, create_payment, Payment};
use squadmaker_backend::state::AppState;
use actix_web::{test, web, App, http::StatusCode, http::header::ContentType};
use bytes::Bytes;

#[sqlx::test(fixtures("users", "leagues"))]
async fn test_fetch_leagues_payments_is_ok_but_empty(pool: sqlx::PgPool) {
    let app = test::init_service(
        App::new()
            .app_data(web::Data::new(AppState { db: pool }))
            .service(fetch_leagues_payments)
    ).await;
    let request = test::TestRequest::with_uri("/leagues/1/payments").to_request();
    let response = test::call_service(&app, request).await;

    assert_eq!(response.status(), StatusCode::OK);

    let result = test::read_body(response).await;
    assert_eq!(result, Bytes::from_static(b"[]"))
}

#[sqlx::test(fixtures("users", "leagues", "players", "payments"))]
async fn test_fetch_leagues_payments_is_filled(pool: sqlx::PgPool) {
    let app = test::init_service(
        App::new()
            .app_data(web::Data::new(AppState { db: pool }))
            .service(fetch_leagues_payments)
    ).await;
    let request = test::TestRequest::with_uri(&format!("/leagues/1/payments")).to_request();
    let response = test::call_service(&app, request).await;

    assert_eq!(response.status(), StatusCode::OK);

    let payments: Vec<Payment> = test::read_body_json(response).await;
    let payment = payments.first().unwrap();
    assert_eq!(payment.id, 1);
    assert_eq!(payment.player_id, 1);
    assert_eq!(payment.league_id, 1);
    assert_eq!(payment.paid, true);
}

#[sqlx::test(fixtures("users", "leagues", "players", "payments"))]
async fn test_fetch_payment_is_filled(pool: sqlx::PgPool) {
    let app = test::init_service(
        App::new()
            .app_data(web::Data::new(AppState { db: pool }))
            .service(fetch_payment)
    ).await;
    let request = test::TestRequest::with_uri(&format!("/leagues/1/payments/players/1")).to_request();
    let response = test::call_service(&app, request).await;

    assert_eq!(response.status(), StatusCode::OK);

    let payment: Payment = test::read_body_json(response).await;
    assert_eq!(payment.id, 1);
    assert_eq!(payment.player_id, 1);
    assert_eq!(payment.league_id, 1);
    assert_eq!(payment.paid, true);
}

#[sqlx::test(fixtures("users", "leagues", "players"))]
async fn test_create_payment_is_ok_and_filled(pool: sqlx::PgPool) {
    let app = test::init_service(
        App::new()
            .app_data(web::Data::new(AppState { db: pool }))
            .service(create_payment)
    ).await;
    let request = test::TestRequest::post()
        .uri("/leagues/1/payments/players/1")
        .insert_header(ContentType::json())
        .to_request();
    let response = test::call_service(&app, request).await;

    assert_eq!(response.status(), StatusCode::OK);

    let payment: Payment = test::read_body_json(response).await;
    assert_eq!(payment.id, 1);
    assert_eq!(payment.player_id, 1);
    assert_eq!(payment.league_id, 1);
    assert_eq!(payment.paid, true);
}

