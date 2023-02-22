FROM node:lts-alpine AS BASEIMAGE
WORKDIR /src
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run prebuild && npm run build

FROM node:lts-alpine
WORKDIR /src
COPY --from=BASEIMAGE /src/dist /src/dist
COPY --from=BASEIMAGE /src/node_modules /src/node_modules
EXPOSE 3000
CMD ["node", "dist/main.js"]