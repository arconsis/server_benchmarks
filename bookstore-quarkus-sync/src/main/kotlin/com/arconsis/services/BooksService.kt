package com.arconsis.services

import com.arconsis.services.models.Book
import com.arconsis.services.persistence.BooksPersistenceService
import java.time.LocalDate
import java.util.*
import javax.enterprise.context.ApplicationScoped

@ApplicationScoped
class BooksService(private val booksPersistenceService: BooksPersistenceService) {
    fun createBook(title: String, author: String, publisher: String, releaseDate: LocalDate): Book = booksPersistenceService.createBook(title, author, publisher, releaseDate)
    fun getBookById(id: UUID): Book? = booksPersistenceService.getBook(id)
    fun getBooks(limit: Int): List<Book> = booksPersistenceService.getBooks(limit)
    fun deleteAllBooks() = booksPersistenceService.deleteBooks()
    fun deleteBookById(id: UUID) = booksPersistenceService.deleteBook(id)

}