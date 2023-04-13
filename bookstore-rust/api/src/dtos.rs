use chrono::NaiveDate;
use serde::{Deserialize, Serialize};
use uuid::Uuid;

#[derive(Debug, Serialize, Deserialize)]
pub struct Book {
    pub id: Uuid,
    pub title: String,
    pub author: String,
    pub publisher: String,
    pub release_date: NaiveDate,
}


#[derive(Debug, Serialize, Deserialize)]
pub struct CreateBook {
    pub title: String,
    pub author: String,
    pub publisher: String,
    pub release_date: NaiveDate,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct CreateBookResponse {
    pub id: Uuid,
}