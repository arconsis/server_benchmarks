package com.arconsis.bookstorespringboot.http.books

import com.arconsis.bookstorespringboot.data.books.BooksDataStore
import kotlinx.coroutines.flow.Flow
import org.springframework.http.ResponseEntity
import org.springframework.transaction.annotation.Transactional
import org.springframework.web.bind.annotation.*
import java.util.*

@RestController
@RequestMapping("/books")
class BooksController(private val booksDataStore: BooksDataStore) {

    @GetMapping("/{bookId}")
    suspend fun getBook(@PathVariable bookId: UUID): Book? {
        return booksDataStore.getBook(bookId = bookId)
    }

    @GetMapping
    fun getBooks(
        @RequestParam("limit", required = false, defaultValue = "1000") limit: Int,
    ): Flow<Book> {
        return booksDataStore.getBooks(limit)
    }

    @Transactional
    @PostMapping
    suspend fun postBook(@RequestBody createBook: CreateBook): CreateBookResponse {
        val bookId = booksDataStore.createBook(createBook)
        return CreateBookResponse(bookId)
    }

    @Transactional
    @DeleteMapping("/{bookId}")
    suspend fun deleteBook(@PathVariable bookId: UUID): ResponseEntity<Unit> {
        booksDataStore.deleteBook(bookId)
        return ResponseEntity.noContent().build()
    }

    @Transactional
    @DeleteMapping
    suspend fun deleteBooks(): ResponseEntity<Unit> {
        booksDataStore.deleteBooks()
        return ResponseEntity.noContent().build()
    }
}