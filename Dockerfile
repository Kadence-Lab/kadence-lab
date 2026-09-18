ARG NODE_VERSION=22

FROM node:${NODE_VERSION}-slim AS build

ENV NPM_HOME="/npm"
ENV PATH="$NPM_HOME:$PATH"
RUN corepack enable

WORKDIR /app

COPY ./package.json /app/
COPY ./package-lock.json /app/

RUN npm ci --only=production

COPY . .

RUN npm run build

FROM node:${NODE_VERSION}-alpine

LABEL org.opencontainers.image.source=https://github.com/Kadence-Lab/kadence-lab

WORKDIR /app

COPY --from=build /app/.output/ ./

ENV NODE_ENV=production
ENV PORT=3000
ENV HOST=0.0.0.0

EXPOSE 3000

CMD ["node", "/app/server/index.mjs"]