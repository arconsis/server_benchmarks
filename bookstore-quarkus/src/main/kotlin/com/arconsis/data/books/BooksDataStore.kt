package com.arconsis.data.books

import com.arconsis.http.books.Book
import com.arconsis.http.books.CreateBook
import io.quarkus.hibernate.reactive.panache.common.WithSession
import io.quarkus.hibernate.reactive.panache.common.WithTransaction
import io.smallrye.mutiny.Uni
import io.smallrye.mutiny.coroutines.awaitSuspending
import jakarta.enterprise.context.ApplicationScoped
import java.util.*

@ApplicationScoped
class BooksDataStore(private val booksRepository: BooksRepository) {

    suspend fun getBook(bookId: UUID): Book? {
        return getBookEntity(bookId)
            ?.awaitSuspending()
            ?.toBook()
    }

    @WithSession
    protected fun getBookEntity(bookId: UUID): Uni<BookEntity>? {
        return booksRepository.findById(bookId)
    }

    @WithTransaction
    fun createBook(createBook: CreateBook): Uni<UUID> {
        return booksRepository.persist(createBook.toBookEntity()).map { it.id!! }
    }

    @WithSession
    protected fun getBookEntities(limit: Int): Uni<List<BookEntity>> {
        return booksRepository.findAll().range<BookEntity>(0, limit - 1).list()
    }

    suspend fun getBooks(limit: Int): List<Book> {
        return getBookEntities(limit)
            .awaitSuspending()
            .map { it.toBook() }
    }

    @WithTransaction
    fun deleteBook(bookId: UUID): Uni<Unit> {
        return booksRepository.deleteById(bookId).replaceWith(Unit)
    }

    @WithTransaction
    fun deleteBooks(): Uni<Unit> {
        return booksRepository.deleteAll().replaceWith(Unit)
    }
}