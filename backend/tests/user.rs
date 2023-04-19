//use squadmaker_backend::services::{fetch_users};
use actix_web::{test, web, App, HttpResponse, http::StatusCode, http::header::ContentType};
use bytes::Bytes;
use serde::{Serialize, Deserialize};

#[derive(Serialize, Deserialize)]
pub struct Person {
    id: String,
    name: String
}

// Example
#[actix_web::test]
async fn test_init_service() {
    let app = test::init_service(
        App::new()
            .service(web::resource("/test").to(|| async { "OK" }))
    ).await;

    // Create request object
    let req = test::TestRequest::with_uri("/test").to_request();

    // Execute application
    let res = app.call(req).await.unwrap();
    assert_eq!(res.status(), StatusCode::OK);
}

#[actix_web::test]
async fn test_add_person() {
    let mut app = test::init_service(
        App::new().service(
            web::resource("/people")
                .route(web::post().to(|person: web::Json<Person>| async {
                    HttpResponse::Ok()
                        .json(person)})
                    ))
    ).await;

    let payload = r#"{"id":"12345","name":"User name"}"#.as_bytes();

    let req = test::TestRequest::post()
        .uri("/people")
        .insert_header(ContentType::json())
        .set_payload(payload)
        .to_request();

    let result: Person = test::call_and_read_body_json(&mut app, req).await;
    assert_eq!(result.id, "12345")
}

// Example
#[actix_web::test]
async fn test_response() {
    let app = test::init_service(
        App::new()
            .service(web::resource("/test").to(|| async {
                HttpResponse::Ok()
            }))
    ).await;

    // Create request object
    let req = test::TestRequest::with_uri("/test").to_request();

    // Call application
    let res = test::call_service(&app, req).await;
    assert_eq!(res.status(), StatusCode::OK);
}

// Example
#[actix_web::test]
async fn test_index() {
    let app = test::init_service(
        App::new().service(
            web::resource("/index.html")
                .route(web::post().to(|| async {
                    HttpResponse::Ok().body("welcome!")
                })))
    ).await;

    let req = test::TestRequest::post()
        .uri("/index.html")
        .insert_header(ContentType::json())
        .to_request();

    let result = test::call_and_read_body(&app, req).await;
    assert_eq!(result, Bytes::from_static(b"welcome!"));
}

#[actix_web::test]
async fn test_index2() {
    let app = test::init_service(
        App::new().service(
            web::resource("/index.html")
                .route(web::post().to(|| async {
                    HttpResponse::Ok().body("welcome!")
                })))
    ).await;

    let req = test::TestRequest::post()
        .uri("/index.html")
        .insert_header(ContentType::json())
        .to_request();

    let res = test::call_service(&app, req).await;
    let result = test::read_body(res).await;
    assert_eq!(result, Bytes::from_static(b"welcome!"));
}

#[actix_web::test]
async fn test_post_person() {
    let mut app = test::init_service(
        App::new().service(
            web::resource("/people")
                .route(web::post().to(|person: web::Json<Person>| async {
                    HttpResponse::Ok()
                        .json(person)})
                    ))
    ).await;

    let payload = r#"{"id":"12345","name":"User name"}"#.as_bytes();

    let res = test::TestRequest::post()
        .uri("/people")
        .insert_header(ContentType::json())
        .set_payload(payload)
        .send_request(&mut app)
        .await;

    assert!(res.status().is_success());

    let result: Person = test::read_body_json(res).await;
    assert_eq!(result.id, "12345");
}