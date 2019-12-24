---
layout: post
title: "Use Redis for caching to a Docker Compose managed Rails project"
description: "How to use Redis for caching to a Docker Compose managed Rails project."
categories: [tutorials]
tags: [docker, redis, ruby on rails, sidekiq]
redirect_from:
  - /2019/11/16/
---
Since Rails 5.2, Redis cache has been added to Rails for caching,
in additional to the default memcache.

## Add Redis to Gemfile

```ruby
gem 'redis' # A Ruby client library for Redis
```

## Build project

```bash
docker-compose build
```

## Setup Redis for caching

1. Update `config/environments/production.rb`.

   ```ruby
   # Use Redis store for caching.
   config.cache_store = :redis_cache_store, { url: ENV["REDIS_URL_CACHING"] ||= "redis://redis:6379/0" }
   ```

2. Update `config/environments/development.rb`.

   Change `memory_store` to `redis_cache_store` and caching can be toggled by `bundle exec rails dev:cache`.

   ```ruby
   config.cache_store = :redis_cache_store, { url: ENV["REDIS_URL_CACHING"] ||= "redis://redis:6379/0" }
   ```

3. Customize Redis URL

   Please refer to the previous blog post [here](/2019/11/12/load-environment-variables-with-docker-compose/){:target="_blank"}.

## Add Redis to docker-compose.yml

```yaml
version: '3'

services:
  db:
    image: 'postgres:10-alpine'
    volumes:
      - 'postgres:/var/lib/postgresql/data'
    ports:
      - '5432:5432'

  redis:
    image: 'redis:5-alpine'
    command: redis-server
    ports:
      - '6379:6379'
    volumes:
      - 'redis:/data'

  web:
    depends_on:
      - 'db'
      - 'redis'
    build: .
    ports:
      - '3000:3000'
    volumes:
      - '.:/project'

volumes:
  redis:
  postgres:
```

## Start Server

```bash
docker-compose up --build
```
