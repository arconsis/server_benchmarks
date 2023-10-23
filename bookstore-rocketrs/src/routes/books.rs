use crate::models::book::Book;
use crate::models::repo::Repo;
use rocket::serde::json::Json;
use rocket::State;
use sea_orm::DatabaseConnection;

#[get("/")]
pub fn index() -> &'static str {
    "Hello world"
}

#[post("/books", format = "application/json", data = "<book>")]
pub async fn create_book(db: &State<DatabaseConnection>, repo: &State<Repo>, book: Json<Book>) {
    let db = db as &DatabaseConnection;
    repo.create_book(db, book.0).await;
}

#[get("/books?<limit>")]
pub async fn get_books(db: &State<DatabaseConnection>, repo: &State<Repo>, limit: i32) -> Json<Vec<Book>> {
    let db = db as &DatabaseConnection;
    let books = repo.get_books(db, limit).await;
    Json(books)
}

#[get("/books/<id>")]
pub async fn get_book(db: &State<DatabaseConnection>, repo: &State<Repo>, id: &str) -> Json<Book> {
    let db = db as &DatabaseConnection;
    let book = repo.get_book(db, id).await;
    Json(book)
}

#[delete("/books")]
pub async fn delete_books(db: &State<DatabaseConnection>, repo: &State<Repo>) {
    let db = db as &DatabaseConnection;
    repo.delete_all(db).await;
}

#[delete("/books/<id>")]
pub async fn delete_book(db: &State<DatabaseConnection>, repo: &State<Repo>, id: &str) {
    let db = db as &DatabaseConnection;
    repo.delete(db, id).await;
}
