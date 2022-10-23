package com.arconsis.data.books

import com.arconsis.data.common.BOOK_ID
import com.arconsis.http.books.dto.Book
import com.arconsis.http.books.dto.CreateBook
import io.smallrye.mutiny.coroutines.awaitSuspending
import java.util.*
import javax.enterprise.context.ApplicationScoped
import org.hibernate.reactive.mutiny.Mutiny

@ApplicationScoped
class BooksRepository(private val sessionFactory: Mutiny.SessionFactory) {
    suspend fun getBook(bookId: UUID): Book? {
        val book = sessionFactory.withTransaction { s ->
            s.createNamedQuery(BookEntity.GET_BOOK, BookEntity::class.java)
                .setParameter(BOOK_ID, bookId)
                .singleResult.map { it.toBook() }
        }
        return book.awaitSuspending()
    }

    suspend fun createBook(createBook: CreateBook): Book {
        val bookEntity = BookEntity(
            title = createBook.title,
            author = createBook.author,
            publisher = createBook.publisher,
            releaseDate = createBook.releaseDate,
        )
        val newBook =  sessionFactory.withTransaction { s ->
            s.persist(bookEntity).map {
                bookEntity.toBook()
            }
        }
        return newBook.awaitSuspending()
    }

    suspend fun getBooks(): List<Book> {
        val bookList = sessionFactory.withTransaction { s ->
            s.createNamedQuery(BookEntity.LIST_BOOKS, BookEntity::class.java)
                .resultList.map { bookEntities -> bookEntities.toBooks() }
        }
        return bookList.awaitSuspending()
    }
}