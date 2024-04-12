use rocket::serde::{Deserialize, Serialize};

#[derive(Debug, Serialize, Deserialize)]
pub struct Book {
    #[serde(default)]
    pub id: String,
    pub title: String,
    pub author: String,
    #[serde(rename = "releaseDate")]
    pub release_date: String,
    pub publisher: String,
}
