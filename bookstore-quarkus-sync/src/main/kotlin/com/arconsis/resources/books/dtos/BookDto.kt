package com.arconsis.resources.books.dtos

import java.time.LocalDate
import java.util.*

data class BookDto(
    val id: UUID,
    val title: String,
    val author: String,
    val publisher: String,
    val releaseDate: LocalDate
)
