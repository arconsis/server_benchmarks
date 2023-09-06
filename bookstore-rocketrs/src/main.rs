use rocket::serde::{json::Json, Serialize, Deserialize};
use rocket::State;
#[macro_use]
extern crate rocket;

#[get("/")]
fn index() -> &'static str {
    "Hello world"
}

#[post("/books", format = "application/json", data = "<book>")]
async fn create_book(db: &State<Repo>, book: Json<Book>) {

}

#[get("/books?<limit>")]
async fn get_books(db: &State<Repo>, limit: Option<u8>) -> Json<&Vec<Book>> {
    let books = db.get_books();
    Json(books)
}

#[get("/books/<id>")]
async fn get_book<'r>(db: &'r State<Repo>, id: &str) -> Json<&'r Book> {
    Json(db.get_book(id))
}

#[delete("/books")]
async fn delete_books(db: &State<Repo>) {
    
}

#[delete("/books/<id>")]
async fn delete_book<'r>(db: &'r State<Repo>, id: &str) {
    
}

#[derive(Serialize, Deserialize)]
struct Book {
    id: String,
    title: String,
}

struct Repo {
    books: Vec<Book>,
}

impl Repo {
    fn get_books(&self) -> &Vec<Book> {
        &self.books
    }
    fn get_book(&self, id: &str) -> &Book {
        match &self.books.iter().find(|book| book.id == id) {
            Some(x) => x,
            None => panic!("Could not find the book with id: {}", id)
        }
    }
    fn delete(&mut self, id: &str) {
        let option = &self.books.iter().position(|x| x.id == id);
        let index = match option {
            Some(x) => x,
            None => panic!("Could not find the book with id: {}", id)
        };
        _ = &self.books.remove(*index);
    }
    async fn delete_all(&mut self) {
        self.books = vec![Book { id: "1".to_string(), title: "Title1".to_string() }];
    }
}

#[launch]
async fn rocket() -> _ {
    rocket::build()
    .mount(
        "/",
        routes![index, get_book, get_books, delete_book, delete_books],
    ).manage(Repo { 
        books: vec![
            Book { id: "1".to_string(), title: "Title1".to_string() },
            Book { id: "2".to_string(), title: "Title2".to_string() },
            Book { id: "3".to_string(), title: "Title3".to_string() }
            ] 
        }
    )
}
