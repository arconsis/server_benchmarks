use chrono::NaiveDate;
use serde::{Deserialize, Serialize};
use uuid::Uuid;

use entity::book;

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

// Method to map the Book dto to book:Model
impl From<CreateBook> for book::Model {
    fn from(dto: CreateBook) -> Self {
        Self {
            id: Default::default(),
            title: dto.title,
            publisher: dto.publisher,
            author: dto.author,
            release_date: dto.release_date,
        }
    }
}

// Method to map the book:Model to Book dto
impl From<book::Model> for Book {
    fn from(model: book::Model) -> Self {
        Self {
            id: model.id,
            title: model.title,
            publisher: model.publisher,
            author: model.author,
            release_date: model.release_date,
        }
    }
}



