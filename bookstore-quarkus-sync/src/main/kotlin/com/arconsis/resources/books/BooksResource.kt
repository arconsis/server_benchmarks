package com.arconsis.resources.books

import com.arconsis.resources.books.dtos.BookDto
import com.arconsis.resources.books.dtos.BookIdDto
import com.arconsis.resources.books.dtos.CreateBookDto
import com.arconsis.resources.errors.BookNotFoundException
import com.arconsis.services.BooksService
import org.jboss.resteasy.reactive.ResponseStatus
import java.util.*
import javax.ws.rs.*
import javax.ws.rs.core.MediaType


@Path("/books")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
class BooksResource(private val booksService: BooksService) {

    @GET
    @Path("/{bookId}")
    fun getBook(@PathParam("bookId") id: UUID): BookDto {
        return booksService.getBookById(id)?.toDto() ?: throw BookNotFoundException(id)
    }

    @POST
    fun createBook(createBook: CreateBookDto): BookIdDto {
        return booksService.createBook(createBook.title, createBook.author, createBook.publisher, createBook.releaseDate).toBookId()
    }

    @GET
    fun getBooks(@QueryParam("limit") limit: Int?): List<BookDto> {
        val booksLimit = limit ?: 1000
        return booksService.getBooks(booksLimit).toDtos()
    }

    @DELETE
    @ResponseStatus(204)
    @Path("/{bookId}")
    fun deleteBookById(@PathParam("bookId") id: UUID) {
        booksService.deleteBookById(id)
    }

    @DELETE
    @ResponseStatus(204)
    fun deleteAllBooks() {
        booksService.deleteAllBooks()
    }
}