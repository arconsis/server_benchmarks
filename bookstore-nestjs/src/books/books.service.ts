import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Books } from './books.entity';
import { BooksDto } from './books.request.dto';

@Injectable()
export class BooksService {
  constructor(
    @InjectRepository(Books)
    private booksRepository: Repository<Books>
  ) {}

  findWithLimit(limit: number): Promise<Books[]> {
    return this.booksRepository.find({ take: limit });
  }

  findOne(id: string): Promise<Books> {
    return this.booksRepository.findOneBy({ id });
  }

  async deleteOne(id: string): Promise<void> {
    await this.booksRepository.delete(id);
  }

  async deleteAll(): Promise<void> {
    await this.booksRepository.clear();
  }

  async addOne(booksDto: BooksDto): Promise<void> {
    await this.booksRepository.insert(booksDto);
  }
}
