use rocket::serde::{Deserialize, Serialize};
use uuid::Uuid;
#[derive(Debug, Serialize, Deserialize)]
pub struct Book {
    #[serde(default = "get_uuid")]
    pub id: String,
    pub title: String,
    pub author: String,
    #[serde(rename = "releaseDate")]
    pub release_date: String,
    pub publisher: String,
}

fn get_uuid() -> String {
    Uuid::new_v4().to_string()
}
