package com.arconsis.data.books

import io.quarkus.hibernate.reactive.panache.PanacheRepositoryBase
import java.util.*
import javax.enterprise.context.ApplicationScoped

@ApplicationScoped
class BooksRepository: PanacheRepositoryBase<BookEntity, UUID>