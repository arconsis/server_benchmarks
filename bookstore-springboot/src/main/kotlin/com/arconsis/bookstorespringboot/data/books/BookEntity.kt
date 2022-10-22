package com.arconsis.bookstorespringboot.data.books

import org.springframework.data.annotation.Id
import java.util.UUID

class BookEntity(
    @Id
    val id: UUID
)