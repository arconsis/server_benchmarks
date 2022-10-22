package com.arconsis.bookstorespringboot.data.books

import org.springframework.data.repository.kotlin.CoroutineCrudRepository
import java.util.*

interface BooksRepository : CoroutineCrudRepository<BookEntity, UUID> {
}