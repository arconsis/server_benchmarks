package com.arconsis.data

import com.arconsis.data.common.BOOK_ID
import com.arconsis.http.books.dto.Book
import com.arconsis.http.books.dto.CreateBook
import io.smallrye.mutiny.Uni
import java.util.*
import javax.enterprise.context.ApplicationScoped
import org.hibernate.reactive.mutiny.Mutiny

@ApplicationScoped
class BooksRepository(private val sessionFactory: Mutiny.SessionFactory) {
    suspend fun getBook(bookId: UUID): Uni<Book>? {
        return sessionFactory.withTransaction { s ->
            s.createNamedQuery(BookEntity.GET_BOOK, BookEntity::class.java)
                .setParameter(BOOK_ID, bookId)
                .singleResult.map { it.toBook() }
        }
    }

    suspend fun createBook(createBook: CreateBook): Uni<Book> {
        val bookEntity = BookEntity(
            title = createBook.title,
            author = createBook.author,
            publisher = createBook.publisher,
            releaseDate = createBook.releaseDate,
        )
        return sessionFactory.withTransaction { s ->
            s.persist(bookEntity).map {
                bookEntity.toBook()
            }
        }
    }

    suspend fun getBooks(): Uni<List<Book>> {
        return sessionFactory.withTransaction { s ->
            s.createNamedQuery(BookEntity.LIST_BOOKS, BookEntity::class.java)
                .resultList.map { bookEntities -> bookEntities.toBooks() }
        }
    }
}