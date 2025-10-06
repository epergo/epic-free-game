FROM ruby:3.4-alpine AS builder

WORKDIR /app

RUN apk add --no-cache \
    curl \
    build-base \
    libpq-dev \
    nodejs \
    npm \
    git

COPY Gemfile Gemfile.lock ./

RUN bundle config set deployment true
RUN bundle config set clean true
RUN bundle config set without "development test"

RUN bundle install --jobs $(nproc) --retry 3

COPY . .
RUN npm install

RUN npm run build:css:production

FROM ruby:3.4-alpine

WORKDIR /app

RUN apk add --no-cache \
    curl \
    libpq-dev \
    gcompat

RUN bundle config set deployment true
RUN bundle config set without development test

COPY --from=builder /app/web/public/css/application.css /app/web/public/css/application.css
COPY --from=builder /app/vendor/bundle /app/vendor/bundle

COPY . .

EXPOSE 5000

CMD ["bin/entrypoint"]
