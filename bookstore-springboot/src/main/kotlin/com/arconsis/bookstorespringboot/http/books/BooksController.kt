package com.arconsis.bookstorespringboot.http.books

import com.arconsis.bookstorespringboot.data.books.BooksDataStore
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
    suspend fun getBooks(): List<Book> {
        return booksDataStore.getBooks()
    }

    @Transactional
    @PostMapping
    suspend fun postBook(@RequestBody createBook: CreateBook): UUID {
        return booksDataStore.createBook(createBook)
    }
}