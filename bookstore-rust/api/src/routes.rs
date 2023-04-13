use actix_web::{
    delete, get, HttpResponse, post, Result, web,
};
use chrono::NaiveDate;
use uuid::Uuid;

use crate::dtos::{Book, CreateBook, CreateBookResponse};

use super::AppState;

#[get("/books/{id}")]
pub(super) async fn get_book(_data: web::Data<AppState>, id: web::Path<Uuid>) -> web::Json<Book> {
    web::Json(Book {
        id: id.into_inner(),
        title: "The Hobbit".to_string(),
        author: "Steve Klabnik".to_string(),
        publisher: "No Starch Press".to_string(),
        release_date: NaiveDate::from_ymd_opt(2014, 5, 14).unwrap(),
    })
}

#[post("/books")]
pub(super) async fn create_book(_data: web::Data<AppState>, _book: web::Json<CreateBook>) -> web::Json<CreateBookResponse> {
    println!("Creating book: {:?}", _book);
    web::Json(CreateBookResponse {
        id: Uuid::new_v4(),
    })
}

#[derive(Debug, serde::Deserialize)]
pub struct LimitParams {
    pub limit: Option<i32>,
}

#[get("/books")]
pub(super) async fn get_books(data: web::Data<AppState>, query: web::Query<LimitParams>) -> web::Json<Vec<Book>> {
    let books_limit = query.limit.unwrap_or(1000);
    let books = vec![
        Book {
            id: Uuid::new_v4(),
            title: format!("XXXX {}", books_limit).to_string(),
            author: "ZZZZ".to_string(),
            publisher: "AAAA".to_string(),
            release_date: Default::default(),
        },
        Book {
            id: Uuid::new_v4(),
            title: format!("QQQ {}", books_limit).to_string(),
            author: "QQQ".to_string(),
            publisher: "QQQ".to_string(),
            release_date: Default::default(),
        }];
    web::Json(books)
}

#[delete("/books/{id}")]
pub(super) async fn delete_book(_data: web::Data<AppState>, _id: web::Path<Uuid>) -> Result<HttpResponse> {
    Ok(HttpResponse::NoContent().finish())
}

#[delete("/books")]
pub(super) async fn delete_all_book(_data: web::Data<AppState>) -> Result<HttpResponse> {
    Ok(HttpResponse::NoContent().finish())
}





