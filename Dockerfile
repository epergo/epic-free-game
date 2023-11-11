FROM ruby:3.2.2-alpine AS builder

WORKDIR /app

RUN apk add --no-cache \
    curl \
    build-base \
    libpq-dev \
    nodejs \
    npm \
    git

RUN npm install -g corepack \
    && corepack enable \
    && corepack prepare yarn@stable --activate

COPY Gemfile Gemfile.lock ./

RUN bundle config set deployment true
RUN bundle config set clean true
RUN bundle config set without "development test"

RUN bundle install --jobs $(nproc) --retry 3

COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

COPY . .

RUN yarn build:css:production

FROM ruby:3.2.2-alpine

WORKDIR /app

RUN apk add --no-cache \
    curl \
    libpq-dev

RUN bundle config set deployment true
RUN bundle config set without development test

COPY --from=builder /app/web/public/css/application.css /app/web/public/css/application.css
COPY --from=builder /app/vendor/bundle /app/vendor/bundle

COPY . .

EXPOSE 5000

CMD ["bin/entrypoint"]
