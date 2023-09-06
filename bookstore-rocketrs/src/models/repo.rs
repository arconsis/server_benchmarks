use crate::models::book::Book;
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
                },
                Book {
                    id: "2".to_string(),
                    title: "Title2".to_string(),
                },
                Book {
                    id: "3".to_string(),
                    title: "Title3".to_string(),
                },
            ],
        }
    }
    pub fn get_books(&self) -> &Vec<Book> {
        &self.books
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
        self.books = vec![Book {
            id: "1".to_string(),
            title: "Title1".to_string(),
        }];
    }
}
