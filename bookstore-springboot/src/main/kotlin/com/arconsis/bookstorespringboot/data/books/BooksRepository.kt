package com.arconsis.bookstorespringboot.data.books

import org.springframework.data.repository.reactive.ReactiveCrudRepository
import java.util.UUID

interface BooksRepository : ReactiveCrudRepository<BookEntity, UUID> {
}