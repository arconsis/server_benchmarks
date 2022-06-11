package com.arconsis.http.books

import com.arconsis.data.BooksRepository
import com.arconsis.http.books.dto.BooksDto
import com.arconsis.http.books.dto.BookDto
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
class BooksResource(private val booksRepository: BooksRepository) {
    @GET
    @Path("/{bookId}")
    @Produces(MediaType.APPLICATION_JSON)
    @Consumes(MediaType.APPLICATION_JSON)
    suspend fun getBook(@PathParam("bookId") bookId: UUID): BooksDto {
        return booksRepository.getBook(bookId)
    }

    @POST
    @Produces(MediaType.APPLICATION_JSON)
    @Consumes(MediaType.APPLICATION_JSON)
    suspend fun createBook(bookCreate: BookDto, uriInfo: UriInfo): Response {
        val createdBook = booksRepository.createBook(bookCreate)
        val path = uriInfo.path
        val location = path + createdBook.id
        return Response.created(URI.create(location)).entity(createdBook).build()
    }

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    @Consumes(MediaType.APPLICATION_JSON)
    suspend fun getBooks(): BooksDto {
        return booksRepository.getCourses()
    }
}