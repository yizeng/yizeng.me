---
layout: post
title: "Load environment variables with Docker Compose"
description: "How to load environment variables with Docker Compose."
categories: [tutorials]
tags: [docker, ruby on rails]
redirect_from:
  - /2019/11/12/
---
Generally there are two ways to load environment variables with Docker Compose in `docker-compose.yml`.

## Set directly

`docker-compose.yml`

```yaml
web:
  depends_on:
    - 'db'
  build: .
  ports:
    - '3000:3000'
  environment:
    - RAILS_LOG_TO_STDOUT=enabled
```

## Specify the env_file

For example, if the Rails project uses [dotenv](https://github.com/bkeepers/dotenv){:target="_blank"} gem,
then the `.env` file at the root of the project can be passed into Docker Compose like the following:

`docker-compose.yml`

```yaml
version: '3'

services:
  db:
    image: 'postgres:10-alpine'
    volumes:
      - 'postgres:/var/lib/postgresql/data'
    ports:
      - '5432:5432'
    env_file:
      - '.env'

  web:
    depends_on:
      - 'db'
    build: .
    ports:
      - '3000:3000'
    volumes:
      - '.:/project'
    env_file:
      - '.env'

volumes:
  postgres:
```

`.env`

```
RAILS_LOG_TO_STDOUT=enabled
```