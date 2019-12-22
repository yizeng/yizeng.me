---
layout: post
title: "Add Sidekiq to a Docker Compose managed Rails project"
description: "How to add Sidekiq to a Docker Compose managed Rails project."
categories: [tutorials]
tags: [docker, redis, ruby on rails, sidekiq]
redirect_from:
  - /2019/11/17/
---
[Sidekiq][Sidekiq]{:target="_blank"} is a simple, efficient background processing for Ruby
that has a lot of advantage over delayed_job or Resque[^1].

Here are the few simple steps to integrate Sidekiq into a Dockerized Rails project:

If the project has not been dockerized yet,
the [previous post](/2019/11/09/setup-a-ruby-on-rails-6-api-project-with-docker-compose/){:target="_blank"} can be helpful.

## Add Sidekiq to Gemfile

```ruby
gem 'sidekiq'
```

## Build project

```bash
docker-compose build
```

## Setup Sidekiq

Follow the steps below to setup Sidekiq.

1. Generate a Sidekiq worker.

   ```bash
   docker-compose run web bundle exec rails g sidekiq:worker Hard
   ```

2. If ActiveJob is used, update `config/application.rb`.

   ```ruby
   config.active_job.queue_adapter = :sidekiq
   ```

3. If ActiveJob is not used, delete `app/jobs` folder.

   ```bash
   rm -r app/jobs/
   ```

4. Set the Sidekiq Redis URL.

    By default, Sidekiq tries to connect to Redis at localhost:6379,
    which needs to be changed the Redis URL in Docker.

    - Create `config/initializers/sidekiq.rb`.

      ```bash
      touch config/initializers/sidekiq.rb
      ```

    - Set URL in initializer.

      ```ruby
      Sidekiq.configure_server do |config|
        config.redis = { url: ENV['REDIS_URL_SIDEKIQ'] ||= 'redis://redis:6379/1' }
      end

      Sidekiq.configure_client do |config|
        config.redis = { url: ENV['REDIS_URL_SIDEKIQ'] ||= 'redis://redis:6379/1' }
      end
      ```

  5. Add Sidekiq and Redis to docker-compose.yml

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

       sidekiq:
         depends_on:
           - 'db'
           - 'redis'
         build: .
         command: bundle exec sidekiq
         volumes:
           - '.:/project'
           - '/project/tmp' # don't mount tmp directory

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

  6. Customize `REDIS_URL_SIDEKIQ`

     Either add as an environment variable in `docker-compose.yml`:

     ```yaml
     sidekiq:
       depends_on:
         - 'db'
         - 'redis'
       build: .
       command: bundle exec sidekiq
       volumes:
         - '.:/project'
       environment:
         - REDIS_URL_SIDEKIQ=redis://redis:6379/12
     ```

     Or add to `.env` file and load it in `docker-compose.yml`

     ```
     OTHER_ENV=example
     REDIS_URL_SIDEKIQ=redis://redis:6379/12
     ```

     ```yaml
     sidekiq:
       depends_on:
         - 'db'
         - 'redis'
       build: .
       command: bundle exec sidekiq
       volumes:
         - '.:/project'
       env_file:
         - '.env'
     ```

  7. Add UI page to `routes.rb`.

     ```ruby
     require 'sidekiq/web'
     mount Sidekiq::Web => '/sidekiq'
     ```

## Start Server

```bash
docker-compose up --build
```

Go to <http://localhost:3000/sidekiq>{:target="_blank"} to verify.

## Troubleshooting

> Errno::ENOENT - No such file or directory - bs_fetch:atomic_write_cache_file:rename

- **Reason**: Two processes are trying to load the /app/tmp directory at the same time[^2].

- **Solution**: Add `- '/project/tmp'` to Sidekiq volumes in `docker-compose.yml`.

[^1]: [Sidekiq Comparison](https://github.com/mperham/sidekiq/wiki/FAQ#how-does-sidekiq-compare-to-resque-or-delayed_job){:target="_blank"}
[^2]: See [this](https://github.com/Shopify/bootsnap/issues/177#issuecomment-491711481){:target="_blank"} GitHub Comment.

[Sidekiq]: https://github.com/mperham/sidekiq