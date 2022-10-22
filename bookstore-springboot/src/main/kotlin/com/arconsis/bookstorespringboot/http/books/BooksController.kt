package com.arconsis.bookstorespringboot.http.books

import com.arconsis.bookstorespringboot.data.books.BooksDataStore
import org.springframework.transaction.annotation.Transactional
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController
import java.util.UUID

@RestController
@RequestMapping("/books")
class BooksController(private val booksDataStore: BooksDataStore) {

    @GetMapping("/{bookId}")
    suspend fun getBook(@PathVariable bookId: UUID): Book? {
        return booksDataStore.getBook(bookId = bookId)
    }

    @GetMapping("/")
    suspend fun getBooks(): List<Book> {
        return booksDataStore.getBooks()
    }

    @Transactional
    @PostMapping("/")
    suspend fun postBook(@RequestBody createBook: CreateBook): UUID {
        return booksDataStore.createBook(createBook)
    }
}