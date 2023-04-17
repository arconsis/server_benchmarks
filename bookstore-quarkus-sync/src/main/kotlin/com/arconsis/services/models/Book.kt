package com.arconsis.services.models

import java.time.LocalDate
import java.util.*

data class Book (
    val id: UUID,
    val title: String,
    val author: String,
    val publisher: String,
    val releaseDate: LocalDate
)