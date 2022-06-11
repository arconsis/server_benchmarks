package com.arconsis.http.books.dto

import java.time.Instant
import java.util.UUID

data class BookDto(
    val id: UUID,
    val title: String,
    val author: String,
    val publisher: String,
    val releaseDate: Instant,
    val tags: MutableSet<String>,
)
