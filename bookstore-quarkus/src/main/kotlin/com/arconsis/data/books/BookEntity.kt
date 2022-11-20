package com.arconsis.data.books

import com.arconsis.http.books.Book
import com.arconsis.http.books.CreateBook
import io.quarkus.hibernate.reactive.panache.PanacheEntityBase
import kotlinx.datetime.toJavaLocalDate
import kotlinx.datetime.toKotlinLocalDate
import org.hibernate.annotations.GenericGenerator
import java.time.LocalDate
import java.util.*
import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.GeneratedValue
import javax.persistence.Id

@Entity(name = "books")
class BookEntity(
    @Id
    @GeneratedValue(generator = "UUID")
    @GenericGenerator(
        name = "UUID",
        strategy = "org.hibernate.id.UUIDGenerator",
    )
    val id: UUID? = null,
    val title: String,
    val author: String,
    val publisher: String,
    @Column(name = "release_date")
    val releaseDate: LocalDate,
) : PanacheEntityBase()

fun BookEntity.toBook() = Book(
    id = id!!,
    title = title,
    author = author,
    publisher = publisher,
    releaseDate = releaseDate.toKotlinLocalDate()
)

fun CreateBook.toBookEntity() = BookEntity(
    title = title,
    author = author,
    publisher = publisher,
    releaseDate = releaseDate.toJavaLocalDate()
)