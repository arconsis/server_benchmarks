package com.arconsis.http.books

import java.time.Instant
import java.time.LocalDate
import java.util.*

data class CreateBook(
    val title: String,
    val author: String,
    val publisher: String,
    val releaseDate: LocalDate,
)

class CreateBookResponse(val id: UUID)
