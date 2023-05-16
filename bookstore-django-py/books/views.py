from django.shortcuts import get_object_or_404
from django.http import JsonResponse
from django.views import View
from django.db import IntegrityError

from .models import Book
import json


class BookList(View):
    def get(self, request):
        limit = request.GET.get('limit', None)
        if limit:
            books = Book.objects.all()[:int(limit)]
        else:
            books = Book.objects.all()
        response_data = {"books": list(books.values())}
        return JsonResponse(response_data)

    def post(self, request):
        data = json.loads(request.body)
        try:
            book = Book.objects.create(
                title=data['title'],
                author=data['author'],
                release_date=data['release_date'],
                publisher=data['publisher']
            )
            response_data = {'message': 'Book created successfully', 'book_id': book.id}
            return JsonResponse(response_data, status=201)
        except IntegrityError:
            response_data = {'message': 'Failed to create book, check input data'}
            return JsonResponse(response_data, status=400)

    def delete(self, request, book_id=None):
        if book_id:
            book = get_object_or_404(Book, pk=book_id)
            book.delete()
            response_data = {'message': f'Book with id {book_id} deleted successfully'}
            return JsonResponse(response_data, status=200)
        else:
            Book.objects.all().delete()
            response_data = {'message': 'All books deleted successfully'}
            return JsonResponse(response_data, status=200)

class BookDetail(View):
    def get(self, request, book_id=None):
        book = get_object_or_404(Book, pk=book_id)
        response_data = {"book": {
            "title": book.title,
            "author": book.author,
            "release_date": book.release_date,
            "publisher": book.publisher
        }}
        return JsonResponse(response_data)
