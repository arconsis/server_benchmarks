package com.arconsis.services.persistence

import com.arconsis.services.models.Book
import com.arconsis.services.persistence.entities.BookEntity
import java.time.LocalDate
import java.util.*
import java.util.logging.Logger
import javax.enterprise.context.ApplicationScoped
import javax.persistence.EntityManager
import javax.transaction.Transactional

@ApplicationScoped
class BooksPersistenceService(private val entityManager: EntityManager) {
    private val logger: Logger = Logger.getLogger(BooksPersistenceService::class.java.name)

    fun getBook(bookId: UUID): Book? {
        return entityManager.find(BookEntity::class.java, bookId)
            ?.toBook()
    }

    @Transactional
    fun createBook(title: String, author: String, publisher: String, releaseDate: LocalDate): Book {
        val bookEntity = BookEntity(null, title, author, publisher, releaseDate)
        entityManager.persist(bookEntity)
        return bookEntity.toBook()
    }

    fun getBooks(limit: Int): List<Book> {
        return entityManager.createNamedQuery(BookEntity.FIND_ALL, BookEntity::class.java)
            .setMaxResults(limit)
            .resultList
            .toBooks()
    }

    @Transactional
    fun deleteBook(bookId: UUID) {
        entityManager.createNamedQuery(BookEntity.DELETE_BY_ID)
            .setParameter("id", bookId)
            .executeUpdate()
    }

    @Transactional
    fun deleteBooks() {
        val deletedBooks = entityManager.createNamedQuery(BookEntity.DELETE_ALL_BOOKS).executeUpdate()
        logger.info { "Deleted all $deletedBooks." }
    }
}