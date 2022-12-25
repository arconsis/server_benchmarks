package com.arconsis.bookstorespringboot

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication

@SpringBootApplication
class BookstoreSpringbootApplication

fun main(args: Array<String>) {
    runApplication<BookstoreSpringbootApplication>(*args)
}
