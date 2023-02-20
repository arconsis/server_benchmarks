import { ConfigService } from '@nestjs/config';
import { NestFactory } from '@nestjs/core';
import {
  FastifyAdapter,
  NestFastifyApplication,
} from '@nestjs/platform-fastify';
import { AppModule } from './app.module';

async function bootstrap() {
  let app = await NestFactory.create(AppModule);
  const configService = app.get(ConfigService);
  if (configService.get('USE_FASTIFY') === 'true') {
    app = await NestFactory.create<NestFastifyApplication>(
      AppModule,
      new FastifyAdapter()
    );
  }
  await app.listen(+configService.get('PORT'), '0.0.0.0');
}
bootstrap();
