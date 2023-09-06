mod models;
mod routes;

#[macro_use]
extern crate rocket;
use routes::books::{index, get_book, get_books, delete_book, delete_books};
use crate::models::repo::Repo;

#[launch]
async fn rocket() -> _ {
    rocket::build()
        .mount(
            "/",
            routes![index, get_book, get_books, delete_book, delete_books],
        )
        .manage(Repo::new())
}
