package com.arconsis.http.books

import java.time.LocalDate
import java.util.UUID

data class Book(
    val id: UUID,
    val title: String,
    val author: String,
    val publisher: String,
    val releaseDate: LocalDate
)
