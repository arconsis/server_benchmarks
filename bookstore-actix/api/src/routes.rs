use actix_web::{delete, get, HttpResponse, post, Responder, Result, web};
use actix_web::error::{ErrorInternalServerError, ErrorNotFound};
use uuid::Uuid;

use bookstore_core::Mutation;
use bookstore_core::Query;
use entity::book;

use crate::dtos::{Book, CreateBook, CreateBookResponse, HealthCheckResponse};
use crate::server::AppState;

#[get("/books/{id}")]
pub async fn get_book_by_id(data: web::Data<AppState>, path_id: web::Path<Uuid>) -> Result<web::Json<Book>> {
    let conn = &data.conn;
    return match Query::find_book_by_id(conn, path_id.into_inner()).await {
        Ok(result) => match result {
            Some(model) => Ok(web::Json(Book::from(model))),
            None => Err(ErrorNotFound("No book found!"))
        },
        Err(err) => Err(ErrorInternalServerError(err)),
    };
}

#[post("/books")]
pub async fn create_book(data: web::Data<AppState>, json_book: web::Json<CreateBook>) -> Result<web::Json<CreateBookResponse>> {
    let conn = &data.conn;
    let book_model = book::Model::from(json_book.into_inner());
    return match Mutation::create_book(conn, book_model).await {
        Ok(id) => Ok(web::Json(CreateBookResponse { id })),
        Err(err) => Err(ErrorInternalServerError(err)),
    };
}

#[derive(Debug, serde::Deserialize)]
pub struct LimitParams {
    pub limit: Option<u64>,
}

#[get("/books")]
pub async fn get_books(data: web::Data<AppState>, query: web::Query<LimitParams>) -> Result<web::Json<Vec<Book>>> {
    let conn = &data.conn;
    return match Query::get_books(conn, query.limit).await {
        Ok(result) => Ok(web::Json(result.into_iter().map(|model| Book::from(model)).collect())),
        Err(err) => Err(ErrorInternalServerError(err)),
    };
}

#[delete("/books/{id}")]
pub async fn delete_book_by_id(data: web::Data<AppState>, path_id: web::Path<Uuid>) -> Result<HttpResponse> {
    let conn = &data.conn;
    return match Mutation::delete_book_by_id(conn, path_id.into_inner()).await {
        Ok(_result) => Ok(HttpResponse::NoContent().finish()),
        Err(err) => Err(ErrorInternalServerError(err)),
    };
}

#[delete("/books")]
pub async fn delete_all_book(data: web::Data<AppState>) -> Result<HttpResponse> {
    let conn = &data.conn;
    return match Mutation::delete_all_books(conn).await {
        Ok(_result) => Ok(HttpResponse::NoContent().finish()),
        Err(err) => Err(ErrorInternalServerError(err)),
    };
}

#[get("/a/health")]
pub async fn health_check() -> impl Responder {
    health_up_response()
}

#[get("/a/health/live")]
pub async fn health_live_check() -> impl Responder {
    health_up_response()
}

#[get("/a/health/ready")]
pub async fn health_ready_check() -> impl Responder {
    health_up_response()
}

fn health_up_response() -> HttpResponse {
    let response = HealthCheckResponse {
        status: "UP".to_string(),
    };
    HttpResponse::Ok().json(response)
}




