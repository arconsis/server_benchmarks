package com.arconsis.bookstorespringboot.data.books

import com.arconsis.bookstorespringboot.http.books.Book
import com.arconsis.bookstorespringboot.http.books.CreateBook
import kotlinx.coroutines.flow.toList
import org.springframework.data.domain.PageRequest
import org.springframework.stereotype.Service
import java.util.*

@Service
class BooksDataStore(private val booksRepository: BooksRepository) {

    suspend fun getBook(bookId: UUID): Book? {
        val bookEntity = booksRepository.findById(bookId)
        return bookEntity?.toBook()
    }

    suspend fun getBooks(limit: Int): List<Book> {
        val pageRequest = PageRequest.ofSize(limit)
        val bookEntities = booksRepository.findBy(pageRequest).toList()
        return bookEntities.map { it.toBook() }
    }

    suspend fun createBook(createBook: CreateBook): UUID {
        val savedBookEntity = booksRepository.save(createBook.toBookEntity())
        return savedBookEntity.id!!
    }

    suspend fun deleteBook(bookId: UUID) {
        booksRepository.deleteById(bookId)
    }

    suspend fun deleteBooks() {
        booksRepository.deleteAll()
    }
}