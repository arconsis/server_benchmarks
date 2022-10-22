package com.arconsis.bookstorespringboot.http.books

import java.time.Instant
import java.util.UUID

data class Book(
    val id: UUID,
    val title: String,
    val author: String,
    val publisher: String,
    val releaseDate: Instant
)