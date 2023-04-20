use std::env;

use actix_http::StatusCode;
use actix_web::{App, Error, HttpRequest, HttpResponse, HttpServer, Result, web};

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

    let db_user = env::var("DB_USER").expect("DB_USER is not set in .env file");
    let db_pass = env::var("DB_PASSWORD").expect("DB_PASSWORD is not set in .env file");
    let db_host = env::var("DB_HOST").expect("DB_HOST is not set in .env file");
    let db_port = env::var("DB_PORT").expect("DB_PORT is not set in .env file");
    let db_name = env::var("DB_NAME").expect("DB_NAME is not set in .env file");
    let host = env::var("HOST").unwrap_or("0.0.0.0".to_string());
    let port = env::var("PORT").unwrap_or("3000".to_string());
    let db_url = format!("postgresql://{db_user}:{db_pass}@{db_host}:{db_port}/{db_name}");
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
            .service(web::scope("/actix").configure(init))
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
    cfg.service(routes::health_check);
    cfg.service(routes::health_live_check);
    cfg.service(routes::health_ready_check);
}


pub fn main() {
    let result = start();

    if let Some(err) = result.err() {
        println!("Error: {err}");
    }
}