use squadmaker_backend::services::{fetch_users, create_user, User, CreateUserBody};
use squadmaker_backend::state::AppState;
use actix_web::{test, web, App, http::StatusCode, http::header::ContentType};
use bytes::Bytes;
use dotenv::dotenv;
use sqlx::{postgres::PgPoolOptions};
use std::env::var;

#[allow(dead_code)]
async fn get_pool() -> sqlx::PgPool {
    dotenv().ok();
    let database_url = var("DATABASE_URL").expect("DATABASE_URL must be set in .env");
    PgPoolOptions::new()
        .max_connections(5)
        .connect(&database_url)
        .await
        .expect("Error building a connection pool")
}

#[sqlx::test]
async fn test_user_table_exists(pool: sqlx::PgPool) -> sqlx::Result<()> {
    let mut conn = pool.acquire().await?;

    sqlx::query("SELECT * FROM user")
        .fetch_one(&mut conn)
        .await?;
    
    Ok(())
}

#[sqlx::test]
async fn test_fetch_users_is_ok_but_empty(pool: sqlx::PgPool) {
    let app = test::init_service(
        App::new()
            .app_data(web::Data::new(AppState { db: pool}))
            .service(fetch_users)
    ).await;
    let request = test::TestRequest::with_uri("/users").to_request();
    let response = test::call_service(&app, request).await;

    assert_eq!(response.status(), StatusCode::OK);

    let result = test::read_body(response).await;
    assert_eq!(result, Bytes::from_static(b"[]"))
}

#[sqlx::test]
async fn test_create_user_is_ok_and_filled(pool: sqlx::PgPool) {
    let app = test::init_service(
        App::new()
            .app_data(web::Data::new(AppState { db: pool}))
            .service(create_user)
    ).await;
    let payload = CreateUserBody {
        name: String::from("Joe"),
        email: String::from("joe@joe.joe"),
        username: String::from("j03"),
        password_hash: String::from("password"),
        avatar: String::from("jo@starbucks.jpg"),
    };
    let request = test::TestRequest::post()
        .uri("/users")
        .insert_header(ContentType::json())
        .set_json(&payload)
        .to_request();
    let response = test::call_service(&app, request).await;

    assert_eq!(response.status(), StatusCode::OK);

    let user: User = test::read_body_json(response).await;
//  assert_eq!(user.id, 1);
    assert_eq!(user.name, payload.name);
    assert_eq!(user.email, payload.email);
    assert_eq!(user.username, payload.username);
    assert_eq!(user.avatar, payload.avatar);
}

#[sqlx::test]
async fn test_create_user_fails_without_required_field(pool: sqlx::PgPool) {
    let app = test::init_service(
        App::new()
            .app_data(web::Data::new(AppState { db: pool }))
            .service(create_user)
    ).await;
    let payload = r#"{
        "email": "joe@joe.joe",
        "username": "j03",
        "password_hash": "password",
        "avatar": "jo@starbucks.jpg"
    }"#.as_bytes();
    let request = test::TestRequest::post()
        .uri("/users")
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
async fn test_create_user_succeeds_with_extra_field(pool: sqlx::PgPool) {
    let app = test::init_service(
        App::new()
            .app_data(web::Data::new(AppState { db: pool }))
            .service(create_user)
    ).await;
    let payload = r#"{
        "name": "joe",
        "email": "joe@joe.joe",
        "username": "j03",
        "password_hash": "password",
        "avatar": "jo@starbucks.jpg",
        "abcd": 0
    }"#.as_bytes();
    let request = test::TestRequest::post()
        .uri("/users")
        .insert_header(ContentType::json())
        .set_payload(payload)
        .to_request();
    let response = test::call_service(&app, request).await;

    assert_eq!(response.status(), StatusCode::OK);

    let user: User = test::read_body_json(response).await;
//  assert_eq!(user.id, 1);
    assert_eq!(user.name, "joe");
    assert_eq!(user.email, "joe@joe.joe");
    assert_eq!(user.username, "j03");
    assert_eq!(user.avatar, "jo@starbucks.jpg");
}
