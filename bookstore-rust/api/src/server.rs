use std::env;

use actix_http::StatusCode;
use actix_web::{
    App, Error, HttpRequest, HttpResponse, HttpServer, Result, web,
};

use bookstore_core::{
    sea_orm::{Database, DatabaseConnection}
};
use migration::{Migrator, MigratorTrait};
use migration::sea_orm::ConnectOptions;

use crate::routes;

#[derive(Debug, Clone)]
pub struct AppState {
    pub conn: DatabaseConnection,
}

async fn not_found(_data: web::Data<AppState>, _request: HttpRequest) -> Result<HttpResponse, Error> {
    Ok(HttpResponse::build(StatusCode::NOT_FOUND)
        .content_type("text/html; charset=utf-8")
        .body("<h1>Error 404 in bookstore</h1>"))
}

fn get_config_from_env() -> (String, String) {
    dotenvy::dotenv().ok();
    let db_url = env::var("DATABASE_URL").expect("DATABASE_URL is not set in .env file");
    let host = env::var("HOST").expect("HOST is not set in .env file");
    let port = env::var("PORT").expect("PORT is not set in .env file");
    let server_url = format!("{host}:{port}");
    (db_url, server_url)
}

// establish connection to database and apply migrations
async fn configure_database(db_url: &String) -> DatabaseConnection {
    let mut opt = ConnectOptions::new(db_url.to_owned());
    opt.sqlx_logging(false); // Disabling SQLx log

    let conn = Database::connect(opt).await.unwrap();
    Migrator::up(&conn, None).await.unwrap();
    conn
}

#[actix_web::main]
async fn start() -> std::io::Result<()> {
    env::set_var("RUST_LOG", "info");
    tracing_subscriber::fmt::init();
    let (db_url, server_url) = get_config_from_env();
    let conn = configure_database(&db_url).await;
    let state = AppState { conn };

    println!("Starting server at {server_url}");
    HttpServer::new(move || {
        App::new()
            .app_data(web::Data::new(state.clone()))
            .default_service(web::route().to(not_found))
            .service(web::scope("/api").configure(init))
    })
        .bind(&server_url)?
        .run()
        .await?;

    Ok(())
}


fn init(cfg: &mut web::ServiceConfig) {
    cfg.service(routes::get_book_by_id);
    cfg.service(routes::create_book);
    cfg.service(routes::get_books);
    cfg.service(routes::delete_all_book);
    cfg.service(routes::delete_book_by_id);
}


pub fn main() {
    let result = start();

    if let Some(err) = result.err() {
        println!("Error: {err}");
    }
}