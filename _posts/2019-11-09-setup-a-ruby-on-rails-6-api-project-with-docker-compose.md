---
layout: post
title: "Setup a Ruby on Rails 6 API project with Docker Compose"
description: "How to setup a Ruby on Rails 6 API project with Docker Compose."
categories: [tutorials]
tags: [api, docker, ruby on rails]
redirect_from:
  - /2019/11/09/
---
Here is a quick rundown on how to setup a Ruby on Rails 6 API project with Docker Compose.

* Kramdown table of contents
{:toc .toc}

## Prerequisites

### Docker and Docker Compose

Docker: [https://www.docker.com/get-started][Docker]{:target="_blank"}

Docker Compose: [https://docs.docker.com/compose/install/][Docker Compose Install]{:target="_blank"}

For example, I have:

>$ docker -v<br />
>$ Docker version 19.03.2, build 6a30dfc
>
>$ docker-compose -v<br />
>$ docker-compose version 1.24.1, build 4667896b

### Ruby

Rails 6 requires Ruby 2.5.0 or newer[^1].

If the local machine hasn't got Ruby installed,
[RVM][RVM]{:target="_blank"} would be a common solution to consider.

For installing RVM with default Ruby and Rails in one command, run:

```bash
\curl -sSL https://get.rvm.io | bash -s stable --rails
```

To verify the successful installation:

>$ ruby -v<br />
>$ ruby 2.6.5p114 (2019-10-01 revision 67812) [x86_64-darwin18]
>
>$ rails -v<br />
>$ Rails 6.0.2.1

## Create a Rails 6 API project

To create a new Ruby on Rails 6 API project, run:

```bash
rails new rails-6-api-docker-demo --api --database=postgresql -T -C
```

- `rails-6-api-docker-demo`: The name of the new project.
- `--api`: Create an API only project.
- `--database=postgresql`: Use [PostgresQL][PostgresQL]{:target="_blank"} as the default database adapter.
- `-T`: (Optional) Skip test files. [RSpec][Rspec]{:target="_blank"} would be a more common option.
- `-C`: (Optional) Skip ActionCable if no WebSockets is needed for the project.

## Setup Docker

### Create .dockerignore

```bash
cd rails-6-api-docker-demo
touch .dockerignore
```

[`.dockerignore`][.dockerignore]{:target="_blank"}
files essentially works the same way as `.gitignore`, but for docker containers.
You may just use the content from `.gitignore` file plus the `.git` folder and `.gitignore` itself.

[gitignore.io][gitignore.io]{:target="_blank"} can be handy for generating the desired `.gitignore` file.
For example, <https://www.gitignore.io/api/git,rails,rubymine>{:target="_blank"}
gives an example of `.gitignore` file for git, rails and rubymine IDE.

**Here's a complete example**: <https://gist.github.com/yizeng/eeeb48d6823801061791cc5581f7e1fc>{:target="_blank"}

### Create Dockerfile

```bash
touch Dockerfile
```

A Dockerfile is a text document that contains all the commands
a user could call on the command line to assemble an image.
Using docker build users can create an automated build
that executes several command-line instructions in succession.

Full documentation can be found [here][Dockerfile reference]{:target="_blank"}.

```bash
FROM ruby:alpine

RUN apk update && apk add build-base nodejs postgresql-dev tzdata

RUN mkdir /project
WORKDIR /project

COPY Gemfile Gemfile.lock ./
RUN gem install bundler
RUN bundle install

COPY . .

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
```

- `FROM ruby:alpine`: Select the base image to build from.
Here uses the latest alpine version of Ruby.
Note that the version needs to match the Ruby version in `Gemfile`.
If there is a mismatch (e.g. `ruby '2.6.5'` in `Gemfile`), then here would be `FROM ruby:2.6.5-alpine`.
More versions can be found at the [Docker Hub](https://hub.docker.com/_/ruby){:target="_blank"}.
- `RUN apk update && apk add build-base nodejs postgresql-dev tzdata`: Install the required packages inside Docker.
- `RUN mkdir /project`: Create a folder called `project` to host the codebase.
- `WORKDIR /project`: Set the working directory to `project` folder.
- `COPY Gemfile Gemfile.lock ./`: Copy the files to the working directory.
- `RUN gem install bundler`: Install the bundler gem.
It needs to match the version in `Gemfile.lock`,
A specific version can be set like `RUN gem install bundler -v 2.0.2`.
- `COPY . .`: Copy the codebase into Docker.
- `CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]`: Set the start command.

## Setup Docker Compose

### Create .env

First, create a `.env` file at the root of the project,
so that any environment variables can be put into it and loaded in containers.

```bash
touch .env
```

### Create docker-compose.yml

```bash
touch docker-compose.yml
```

Docker compose is a tool to build a multi-container application,
where `docker-compose.yml` is the YAML config file that
tells Docker Compose how to build the containers together.

A more detailed documentation can be found [here][Compose File Reference]{:target="_blank"}.

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
    env_file:
      - '.env'

  web:
    depends_on:
      - 'db'
      - 'redis'
    build: .
    ports:
      - '3000:3000'
    volumes:
      - '.:/project'
    env_file:
      - '.env'

volumes:
  redis:
  postgres:
```

Here defines 3 services in order to run the Rails application:
- `db`: The PostgreSQL database service, which uses `postgres:10-alpine` here for example.
It maps port 5432 inside Docker to the same port on local host machine.
- `redis`: The Redis caching service, which uses `redis:5-alpine` here for example.
It maps port 6379 inside Docker to the same port on local host machine.
This is needed if Sidekiq is used for job processing
or Rails caching is set to Redis instead of memcache.
- `web`: This is how the Rails API is composed.
It depends on `db` and `redis` with port 3000 exposed on host machine.

### Config database.yml

The default Ruby on Rails' `database.yml` needs to be configed with
the Docker database URL by adding `host`, `username` and `password` to it.

```yaml
default: &default
  adapter: postgresql
  encoding: unicode
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  host: db
  username: postgres
  password:

development:
  <<: *default
  database: rails_6_api_docker_demo_development

test:
  <<: *default
  database: rails_6_api_docker_demo_test

production:
  <<: *default
  database: rails_6_api_docker_demo_production
  username: rails_6_api_docker_demo
  password: <%= ENV['RAILS_6_API_DOCKER_DEMO_DATABASE_PASSWORD'] %>
```

## Start Rails Server

Build the containers

```bash
docker-compose build
```
    
Before starting the server, Rails databases need to be created first.

```bash
docker-compose run web bundle exec rails db:create
docker-compose run web bundle exec rails db:migrate
```

Finally, to build and spin up the Rails 6 API server:

```bash
docker-compose up --build
```

Head over to <http://localhost:3000>{:target="_blank"} to test it out and start building the real API!

## Install RSpec (Optional)

If the project was initialized with `-T` option that no tests are generated,
a testing framework would be needed for the project.

Here is how to add [RSpec][RSpec]{:target="_blank"} support.

1. Add rspec-rails to Gemfile

   ```ruby
   # Add it inside group :development, :test
   group :development, :test do
     # some existing gems...
     # ...

     gem 'rspec-rails'
   end
   ```

2. Rebuild the containers

   ```bash
   docker-compose build
   ```

3. Install RSpec

   ```bash
   docker-compose run web bundle exec rails generate rspec:install
   ```

4. Run the tests

   ```bash
   docker-compose run web bundle exec rspec
   ```

## Troubleshooting

> Error starting userland proxy: listen tcp 0.0.0.0:6379: bind: address already in use

- **Reason**: Port 6379 is already in use on local machine.This is most likely that there is another Redis server running locally.

- **Solution**: Either stop the Redis on local machine or map to another port in `docker-compose.yml`, like `- '6380:6379'`.

> Error starting userland proxy: listen tcp 0.0.0.0:5432: bind: address already in use

- **Reason**: Port 5432 is already in use on local machine. This is most likely that there is another PostgreSQL server running locally.

- **Solution**: Either stop the PostgreSQL on local machine or map to another port in `docker-compose.yml`, like `- '5434:5432'`.

> Your Ruby version is 2.6.5, but your Gemfile specified 2.6.3<br />
> ERROR: Service 'web' failed to build: The command '/bin/sh -c bundle install' returned a non-zero code: 18

- **Reason**: There is a Ruby version mismatch between `Gemfile` and Docker container.

- **Solution**: Either update the Ruby version in `Gemfile` to `2.6.5`, or pull explicitly Ruby `2.6.3` image in `Dockerfile` like `FROM ruby:2.6.3-alpine`.

> /usr/local/bundle/ruby/2.6.0/gems/activesupport-6.0.2.1/lib/active_support/railtie.rb:39:in<br />
> rescue in block in \<class:Railtie\>': tzinfo-data is not present.<br />
> Please add gem 'tzinfo-data' to your Gemfile and run bundle install (TZInfo::DataSourceNotFound)<br />
> /usr/local/bundle/ruby/2.6.0/gems/tzinfo-1.2.5/lib/tzinfo/zoneinfo_data_source.rb:180:in `initialize':<br />
> None of the paths included in TZInfo::ZoneinfoDataSource.search_path are valid zoneinfo directories. (TZInfo::ZoneinfoDirectoryNotFound)

- **Reason**: Required `tzdata` package was not installed in Docker container.

- **Solution**: Include `tzdata` in `Dockerfile`'s `RUN apk add` command (see details above).

> /usr/local/lib/ruby/2.6.0/rubygems.rb:283:in `find_spec_for_exe':<br />
> Could not find 'bundler' (2.0.2) required by your /project/Gemfile.lock. (Gem::GemNotFoundException)<br />
> ERROR: Service 'web' failed to build: The command '/bin/sh -c bundle install' returned a non-zero code: 1

- **Reason**: Required gem bundler was not installed in Docker container.

- **Solution**: Include `RUN gem install bundler` command in `Dockerfile` (see details above).

[^1]: https://edgeguides.rubyonrails.org/upgrading_ruby_on_rails.html#ruby-versions

[Docker]: https://www.docker.com/get-started
[Docker Compose Install]: https://docs.docker.com/compose/install
[RVM]: https://rvm.io/
[PostgreSQL]:https://www.postgresql.org/
[RSpec]:https://rspec.info/
[.dockerignore]: https://docs.docker.com/engine/reference/builder/#dockerignore-file
[gitignore.io]: https://www.gitignore.io/
[Dockerfile reference]: https://docs.docker.com/engine/reference/builder/
[Compose File Reference]: https://docs.docker.com/compose/compose-file/