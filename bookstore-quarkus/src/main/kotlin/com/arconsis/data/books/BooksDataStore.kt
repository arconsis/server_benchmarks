package com.arconsis.data.books

import com.arconsis.http.books.Book
import com.arconsis.http.books.CreateBook
import io.smallrye.mutiny.Uni
import io.smallrye.mutiny.coroutines.awaitSuspending
import java.util.*
import javax.enterprise.context.ApplicationScoped

@ApplicationScoped
class BooksDataStore(private val booksRepository: BooksRepository) {

    suspend fun getBook(bookId: UUID): Book? {
        val bookEntity = booksRepository.findById(bookId)?.awaitSuspending()
        return bookEntity?.toBook()
    }

    fun createBook(createBook: CreateBook): Uni<UUID> {
        return booksRepository.persist(createBook.toBookEntity()).map { it.id!! }
    }

    suspend fun getBooks(): List<Book> {
        val bookEntities = booksRepository.findAll().list<BookEntity>().awaitSuspending()
        return bookEntities.map { it.toBook() }
    }

    fun deleteBook(bookId: UUID): Uni<Unit> {
        return booksRepository.deleteById(bookId).replaceWith(Unit)
    }

    fun deleteBooks(): Uni<Unit> {
        return booksRepository.deleteAll().replaceWith(Unit)
    }
}