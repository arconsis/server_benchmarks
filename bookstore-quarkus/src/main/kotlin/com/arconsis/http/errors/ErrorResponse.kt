package com.arconsis.http.errors

const val PROBLEM_DETAIL_CONTENT_TYPE = "application/problem+json"

/**
 * Based on ProblemDetail from RFC 7807
 */
class ErrorResponse(title: String, status: Int, detail: String)