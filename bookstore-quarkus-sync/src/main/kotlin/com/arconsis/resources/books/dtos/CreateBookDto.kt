package com.arconsis.resources.books.dtos

import java.time.LocalDate

data class CreateBookDto(
    val title: String,
    val author: String,
    val publisher: String,
    val releaseDate: LocalDate,
)
