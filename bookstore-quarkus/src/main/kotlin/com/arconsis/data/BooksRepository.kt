package com.arconsis.data

import com.arconsis.http.books.Book
import com.arconsis.http.books.CreateBook
import java.util.*
import javax.enterprise.context.ApplicationScoped

@ApplicationScoped
class BooksRepository {

    fun getBook(bookId: UUID): Book {
        return TODO()
    }

    fun createBook(createBook: CreateBook): UUID {
        return TODO()
    }

    fun getBooks(): List<Book> {
        return TODO()
    }

    fun deleteBook(bookId: UUID) {
        return TODO()
    }
}