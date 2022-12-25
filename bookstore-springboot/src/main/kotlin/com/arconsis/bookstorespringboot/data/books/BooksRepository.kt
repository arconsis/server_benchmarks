package com.arconsis.bookstorespringboot.data.books

import kotlinx.coroutines.flow.Flow
import org.springframework.data.domain.Pageable
import org.springframework.data.repository.kotlin.CoroutineCrudRepository
import java.util.*

interface BooksRepository : CoroutineCrudRepository<BookEntity, UUID> {
    suspend fun findBy(pageable: Pageable): Flow<BookEntity>
}