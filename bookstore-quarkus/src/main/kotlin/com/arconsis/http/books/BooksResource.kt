package com.arconsis.http.books

import com.arconsis.data.BooksRepository
import com.arconsis.http.books.dto.Book
import com.arconsis.http.books.dto.CreateBook
import java.net.URI
import java.util.UUID
import javax.enterprise.context.ApplicationScoped
import javax.ws.rs.Consumes
import javax.ws.rs.GET
import javax.ws.rs.POST
import javax.ws.rs.Path
import javax.ws.rs.PathParam
import javax.ws.rs.Produces
import javax.ws.rs.core.MediaType
import javax.ws.rs.core.Response
import javax.ws.rs.core.UriInfo

@Path("/books")
@ApplicationScoped
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
class BooksResource(private val booksRepository: BooksRepository) {
    @GET
    @Path("/{bookId}")
    suspend fun getBook(@PathParam("bookId") bookId: UUID): List<Book> {
        return booksRepository.getBook(bookId)
    }

    @POST
    suspend fun createBook(createBook: CreateBook, uriInfo: UriInfo): Response {
        val createdBook = booksRepository.createBook(createBook)
        val path = uriInfo.path
        val location = path + createdBook.id
        return Response.created(URI.create(location)).entity(createdBook).build()
    }

    @GET
    suspend fun getBooks(): List<Book> {
        return booksRepository.getCourses()
    }
}