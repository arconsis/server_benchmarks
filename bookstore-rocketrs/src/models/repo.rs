
use entity::{prelude::*, *};
use sea_orm::{DatabaseConnection, ActiveValue, EntityTrait};
use uuid::Uuid;
use super::book::Book;

pub struct Repo {
    books: Vec<Book>,
}

impl Repo {
    pub fn new() -> Self {
        Repo {
            books: vec![
                Book {
                    id: "1".to_string(),
                    title: "Title1".to_string(),
                    author: "Tomislav".to_string(),
                    release_date: "1937-09-21".to_string(),
                    publisher: "George Allen & Unwin".to_string(),
                },
                Book {
                    id: "2".to_string(),
                    title: "Title2".to_string(),
                    author: "Tomislav".to_string(),
                    release_date: "1937-09-21".to_string(),
                    publisher: "George Allen & Unwin".to_string(),
                },
                Book {
                    id: "3".to_string(),
                    title: "Title3".to_string(),
                    author: "Tomislav".to_string(),
                    release_date: "1937-09-21".to_string(),
                    publisher: "George Allen & Unwin".to_string(),
                },
            ],
        }
    }

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

    pub async fn get_books(&self, db: &DatabaseConnection) -> Vec<Book> {
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
            .collect::<Vec<Book>>()
    }
    pub fn get_book(&self, id: &str) -> &Book {
        match &self.books.iter().find(|book| book.id == id) {
            Some(x) => x,
            None => panic!("Could not find the book with id: {}", id),
        }
    }
    pub fn delete(&mut self, id: &str) {
        let option = &self.books.iter().position(|x| x.id == id);
        let index = match option {
            Some(x) => x,
            None => panic!("Could not find the book with id: {}", id),
        };
        _ = &self.books.remove(*index);
    }
    pub async fn delete_all(&mut self) {
        self.books = vec![];
    }
}
