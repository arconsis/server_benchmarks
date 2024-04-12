
use entity::{prelude::*, *};
use sea_orm::{DatabaseConnection, ActiveValue, EntityTrait};
use uuid::Uuid;
use super::book::Book;

pub struct Repo;

impl Repo {
    pub fn new() -> Self { Self {  } }

    pub async fn create_book(&self, db: &DatabaseConnection, book: Book) {
        let entity = book_entity::ActiveModel {
            id: ActiveValue::Set(Uuid::new_v4().to_string().to_owned()),
            title: ActiveValue::Set(book.title.to_owned()),
            author: ActiveValue::Set(book.author.to_owned()),
            release_date: ActiveValue::Set(book.release_date.to_owned()),
            publisher: ActiveValue::Set(book.publisher.to_owned()),
            ..Default::default()
        };
        let _ = BookEntity::insert(entity).exec(db).await;
    }

    pub async fn get_books(&self, db: &DatabaseConnection, limit: i32) -> Vec<Book> {
        let result = match BookEntity::find().all(db).await {
            Ok(x) => x,
            Err(_) => vec![],
        };
        result
            .into_iter()
            .map(|b| Book {
                id: b.id,
                title: b.title,
                author: b.author,
                release_date: b.release_date,
                publisher: b.publisher,
            })
            .take(limit as usize)
            .collect::<Vec<Book>>()
    }
    pub async fn get_book(&self, db: &DatabaseConnection, id: &str) -> Book {
        let result = match BookEntity::find_by_id(id.to_string()).one(db).await {
            Ok(x) => x,
            Err(_) => panic!("Could not find a book")
        };

        result.map(|b| Book {
            id: b.id,
            title: b.title,
            author: b.author,
            release_date: b.release_date,
            publisher: b.publisher,
        }).expect("msg")
    }
    pub async fn delete(&self, db: &DatabaseConnection, id: &str) {
        _ = BookEntity::delete_by_id(id.to_string()).exec(db).await;
    }
    pub async fn delete_all(&self, db: &DatabaseConnection) {
        _ = BookEntity::delete_many().exec(db).await;
    }
}
