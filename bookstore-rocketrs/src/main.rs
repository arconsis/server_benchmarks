mod db;
mod models;
mod routes;

#[macro_use]
extern crate rocket;
use crate::models::repo::Repo;
use db::setup;
use migration::{cli, Migrator};
use routes::books::*;

#[launch]
async fn rocket() -> _ {
    let db = match setup::set_up_db().await {
        Ok(db) => db,
        Err(err) => panic!("Could not connect: {}", err),
    };
    
    cli::run_cli(Migrator).await;
    rocket::build()
        .mount(
            "/",
            routes![
                index,
                create_book,
                get_book,
                get_books,
                delete_book,
                delete_books
            ],
        )
        .manage(db)
        .manage(Repo::new())
}
