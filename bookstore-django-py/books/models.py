from django.db import models


class Book(models.Model):
    title = models.CharField(max_length=255)
    author = models.CharField(max_length=255)
    publisher = models.CharField(max_length=255)
    release_date = models.DateField()
    test = models.CharField(max_length=255)

    def __str__(self):
        return self.title
