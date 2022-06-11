package com.arconsis.data

import com.arconsis.http.books.dto.Book
import com.arconsis.http.books.dto.BookCreate
import java.util.*

class BooksRepository {
    fun getBook(bookId: UUID): List<Book> {
        return TODO()
    }

    fun createBook(bookCreate: BookCreate): com.arconsis.http.books.dto.Book {
        return TODO()
    }

    fun getCourses(): List<Book> {
        return TODO()
    }
}