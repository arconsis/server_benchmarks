use sea_orm::*;
use sea_orm::prelude::Uuid;

use ::entity::{book, book::Entity as Book};

pub struct Mutation;

impl Mutation {
    pub async fn create_book(db: &DatabaseConnection, book_model: book::Model) -> Result<Uuid, DbErr> {
        let mut active_model = book_model.into_active_model();
        active_model.id = Default::default(); // Need to reset id to default
        active_model.insert(db).await.map(|insert| insert.id)
    }

    pub async fn delete_book_by_id(db: &DbConn, id: Uuid) -> Result<DeleteResult, DbErr> {
        Book::delete_by_id(id).exec(db).await
    }

    pub async fn delete_all_books(db: &DbConn) -> Result<DeleteResult, DbErr> {
        Book::delete_many().exec(db).await
    }
}

