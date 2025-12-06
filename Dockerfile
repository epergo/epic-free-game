FROM docker.io/library/ruby:4.0.0-slim AS base

WORKDIR /app

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    libpq-dev \
    libyaml-dev \
    nodejs \
    git \
    libjemalloc2 \
    curl && \
    ln -s /usr/lib/$(uname -m)-linux-gnu/libjemalloc.so.2 /usr/local/lib/libjemalloc.so && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

ENV BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development" \
    PNPM_HOME="/pnpm"

ENV PATH="$PNPM_HOME:$PATH"

FROM base AS build

RUN corepack enable

COPY Gemfile Gemfile.lock ./

RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git

COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY . .

RUN pnpm run build:css:production

RUN rm -rf node_modules

FROM base

RUN groupadd --system --gid 1000 epic && \
    useradd -m epic --uid 1000 --gid 1000 --shell /bin/bash

USER 1000:1000

COPY --from=build --chown=epic:epic "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build --chown=epic:epic /app /app

EXPOSE 5000

CMD ["bin/entrypoint"]
