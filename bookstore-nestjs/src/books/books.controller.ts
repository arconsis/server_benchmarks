import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  Post,
  Query,
} from '@nestjs/common';
import { BooksDto } from './books.request.dto';
import { BooksService } from './books.service';

@Controller('books')
export class BooksController {
  constructor(private readonly booksService: BooksService) {}

  @Get()
  getAllBooks(@Query('limit') limit: number = 1000) {
    return this.booksService.findWithLimit(+limit);
  }

  @Get(':id')
  getBook(@Param('id') id: string) {
    return this.booksService.findOne(id);
  }

  @Delete(':id')
  deleteBook(@Param('id') id: string) {
    return this.booksService.deleteOne(id);
  }

  @Delete()
  deleteAllBooks() {
    return this.booksService.deleteAll();
  }

  @Post()
  addBook(@Body() booksDto: BooksDto) {
    return this.booksService.addOne(booksDto);
  }
}
