package com.arconsis.bookstorespringboot.data.books

import com.arconsis.bookstorespringboot.http.books.Book
import com.arconsis.bookstorespringboot.http.books.CreateBook
import kotlinx.coroutines.reactor.awaitSingle
import kotlinx.coroutines.reactor.awaitSingleOrNull
import org.springframework.stereotype.Service
import java.util.UUID

@Service
class BooksDataStore(private val booksRepository: BooksRepository) {

    suspend fun getBook(bookId: UUID): Book? {
        val bookEntity = booksRepository.findById(bookId).awaitSingleOrNull()
        return bookEntity?.toBook()
    }

    suspend fun getBooks(): List<Book> {
        val bookEntities = booksRepository.findAll().collectList().awaitSingle()
        return bookEntities.map { it.toBook() }
    }

    suspend fun createBook(createBook: CreateBook): UUID {
        val savedBookEntity = booksRepository.save(createBook.toBookEntity()).awaitSingle()
        return savedBookEntity.id!!
    }
}