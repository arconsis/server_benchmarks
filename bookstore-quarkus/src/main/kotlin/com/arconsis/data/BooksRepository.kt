package com.arconsis.data

import com.arconsis.http.books.dto.Book
import com.arconsis.http.books.dto.CreateBook
import java.util.*
import javax.enterprise.context.ApplicationScoped

@ApplicationScoped
class BooksRepository {
    fun getBook(bookId: UUID): Book {
        return TODO()
    }

    fun createBook(createBook: CreateBook): Book {
        return TODO()
    }

    fun getBooks(): List<Book> {
        return TODO()
    }
}