use rocket::serde::{Deserialize, Serialize};
#[derive(Serialize, Deserialize)]
pub struct Book {
    pub id: String,
    pub title: String,
}
