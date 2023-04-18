//use squadmaker_backend::services::{fetch_users};
use actix_web::{test, web, App, HttpResponse, http::StatusCode};

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
