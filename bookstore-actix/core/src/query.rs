use sea_orm::*;
use sea_orm::prelude::Uuid;

use ::entity::{book, book::Entity as Book};

pub struct Query;

impl Query {
    pub async fn find_book_by_id(db: &DbConn, id: Uuid) -> Result<Option<book::Model>, DbErr> {
        Book::find_by_id(id).one(db).await
    }

    pub async fn get_books(db: &DbConn, limit: Option<u64>) -> Result<Vec<book::Model>, DbErr> {
        Book::find()
            .limit(limit)
            .all(db)
            .await
    }
}