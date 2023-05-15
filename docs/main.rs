// Examples from actix.rs

use actix_web::{get, post, web, guard, App, HttpResponse, HttpServer, Responder};
use std::time::Duration;
use std::sync::Mutex;
use std::thread;
use openssl::ssl::{SslAcceptor, SslFiletype, SslMethod};

struct AppState {
    app_name: String,
    counter: Mutex<i32>,
}

async fn index() -> impl Responder {
    "Hello world HTML!"
}

async fn manual_hello() -> impl Responder {
    HttpResponse::Ok().body("Hey there!")
}


#[get("/hello")]
async fn hello() -> impl Responder {
    thread::sleep(Duration::from_secs(15));
    HttpResponse::Ok().body("Hello world!")
}

#[post("/echo")]
async fn echo(req_body: String) -> impl Responder {
    HttpResponse::Ok().body(req_body)
}

#[get("/")]
async fn home(data: web::Data<AppState>) -> String {
    let app_name = &data.app_name;
    format!("Hello {app_name}!")
}


async fn counter(data: web::Data<AppState>) -> String {
    let mut counter = data.counter.lock().unwrap();
    *counter += 1;

    format!("Request number: {counter}")
}

fn scoped_config(cfg: &mut web::ServiceConfig) {
    cfg.service(
        web::resource("/test")
            .route(web::get().to(|| async { HttpResponse::Ok().body("test") }))
            .route(web::head().to(HttpResponse::MethodNotAllowed)),
    );
}

fn config(cfg: &mut web::ServiceConfig) {
    cfg.service(
        web::resource("/app1")
            .route(web::get().to(|| async { HttpResponse::Ok().body("app") }))
            .route(web::head().to(HttpResponse::MethodNotAllowed)),
    );
}


#[actix_web::main]
async fn main() -> std::io::Result<()> {
    let state = web::Data::new(AppState {
        app_name: String::from("Actix Web"),
        counter: Mutex::new(0),
    });
    let mut builder = SslAcceptor::mozilla_intermediate(SslMethod::tls()).unwrap();
    builder
        .set_private_key_file("key.pem", SslFiletype::PEM)
        .unwrap();
    builder.set_certificate_chain_file("cert.pem").unwrap();

    HttpServer::new(move || {
        App::new()
            .app_data(state.clone())
            .service(home)
            .service(hello)
            .service(echo)
            .service(web::scope("/app").route("/index.html", web::get().to(index)))
            .route("/hey", web::get().to(manual_hello))
            .route("/counter", web::get().to(counter))
            .service(
                web::scope("/guard")
                    .guard(guard::Host("localhost"))
                    .route("", web::to(|| async { HttpResponse::Ok().body("www") }))
            )
            .service(
                web::scope("/guard")
                    .guard(guard::Host("127.0.0.1"))
                    .route("", web::to(|| async { HttpResponse::Ok().body("user") }))
            )
            .route("/guard", web::to(HttpResponse::Ok))
            .configure(config)
            .service(web::scope("/api").configure(scoped_config))
    })
    .workers(4)
    .bind_openssl("127.0.0.1:8080", builder)?
    .run()
    .await
}
