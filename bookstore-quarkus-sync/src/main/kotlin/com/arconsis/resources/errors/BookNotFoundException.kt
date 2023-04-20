package com.arconsis.resources.errors

import java.util.UUID

class BookNotFoundException(val bookId: UUID) : RuntimeException()