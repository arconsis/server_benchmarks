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
pub async fn get_books(db: &State<DatabaseConnection>, repo: &State<Repo>, limit: Option<u8>) -> Json<Vec<Book>> {
    let db = db as &DatabaseConnection;
    let books = repo.get_books(db).await;
    Json(books)
}

#[get("/books/<id>")]
pub async fn get_book<'r>(db: &'r State<Repo>, id: &str) -> Json<&'r Book> {
    Json(db.get_book(id))
}

#[delete("/books")]
pub async fn delete_books(db: &State<Repo>) {}

#[delete("/books/<id>")]
pub async fn delete_book<'r>(db: &'r State<Repo>, id: &str) {}
