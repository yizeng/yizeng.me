---
layout: post
title: "Install and setup PostgreSQL for Ruby on Rails on Mac OS"
description: "A brief note on how to install and setup PostgreSQL for Ruby on Rails on Mac OS."
categories: [notes]
tags: [postgresql, ruby on rails]
alias: [/2015/02/09/]
---
A brief note on how to install and setup PostgreSQL for Ruby on Rails on Mac OS.

* Kramdown table of contents
{:toc .toc}

## Prerequisites
{: #prerequisites}

This note assumes that Ruby on Rails has already been properly installed
and the purpose is to replace the default DB engine [SQLite][SQLite] with [PostgreSQL][PostgreSQL].

## Install PostgreSQL
{: #install-postgresql}

As shown in the official Postgres download instructions [here](http://www.postgresql.org/download/macosx/),
there are few ways of installing PostgreSQL on Mac OS.
[Homebrew][Homebrew] or [Postgres.app][Postgres.app] are the common ones
that often recommeded by other Mac users.

However, as I also use Linux and Windows machines for development,
installing PostgreSQL using grapichal installer from [EnterpriseDB][EnterpriseDB] would be a more widely used solution
that keeps everything consistent across all my environment.
This grapichal installer provides an easy and straightforward wizard to get
Postgres installed with few simple clicks.

### Download
{: #download-postgresql}
1. Go to <http://www.enterprisedb.com/products-services-training/pgdownload>
2. Select a version. (For example, the latest installer version is `Version 9.4.0`).
3. Click 'Mac OS X' to download for Mac.

### Install
{: #install-postgresql-steps}
1. Install from the downloaded file `postgresql-9.4.0-1-osx.dmg` just like any other Mac installers.
2. Follow through the installation wizard with the default options.
3. Installing Stack Builder is optional and can be omitted.

### Add to PATH
{: #add-to-path}
1. Locate where PostgreSQL's binary is.
By default, it should be `/Library/PostgreSQL/9.4/bin/psql`, where 9.4 is the PostgreSQL version number.
Otherwise, use the following `find` command to find the path.

    > sudo find / -name "psql"

2. Open `~/.bash_profile` with following command.

    > open ~/.bash_profile

3. Add the following line to `.bash_profile` using the PostgreSQL's binary path.

    > PATH=$PATH:/Library/PostgreSQL/9.4/bin

## Install pgAdmin
{: #install-pgadmin}

[pgAdmin][pgAdmin] is the most popular and feature rich Open Source administration and development platform for PostgreSQL.
It helps users manage PostgreSQL databases through graphical interfaces.

### Install
{: #install-pgadmin-steps}
1. Download Mac OS dmg installer from <http://www.pgadmin.org/download/macosx.php>.
2. Install it (e.g. the latest is `pgadmin3-1.20.0.dmg`).

### Connect to server
{: #pgadmin-connect}
1. Open up pgAdmin III from the applications.
2. The local DB should be already shown up in Obeject Browser -> Server Groups -> Servers -> PostgreSQL 9.4 (localhost:5432).
If not, manually add a server pointing to `localhost:5432`
or the port number specified when installing PostgreSQL.

## Install pg gem
{:install-pg-gem}
1. Open up a terminal window
2. Find out where `pg_config` is using the command below.
By default, it should be `/Library/PostgreSQL/9.4/bin/pg_config` for PostgreSQL 9.4.

    > sudo find / -name "pg_config"

3. Install the gem with `pg-config` path explicitly specified.

    > gem install pg \-- \--with-pg-config=/Library/PostgreSQL/9.4/bin/pg_config

## Update Ruby on Rails project
{:update-ruby-on-rails-project}
1. Update 'Gemfile'. Replace `gem 'sqlite3'` with `gem 'pg'`.
2. Run `bundle install`.
3. Open `config/database.yml` file and update it like the following:

    Original (for SQLite):

    {% prettify yaml %}
    # SQLite version 3.x
    #   gem install sqlite3
    #
    #   Ensure the SQLite 3 gem is defined in your Gemfile
    #   gem 'sqlite3'
    #
    default: &default
      adapter: sqlite3
      pool: 5
      timeout: 5000

    development:
      <<: *default
      database: db/development.sqlite3

    # Warning: The database defined as "test" will be erased and
    # re-generated from your development database when you run "rake".
    # Do not set this db to the same as development or production.
    test:
      <<: *default
      database: db/test.sqlite3

    production:
      <<: *default
      database: db/production.sqlite3
    {% endprettify %}

    New (For PostgreSQL):

    {% prettify yaml %}
    default: &default
      adapter: postgresql
      encoding: unicode
      pool: 5
      host: localhost
      username: [Your username for DB]
      password: [Your password for DB]

    development:
      <<: *default
      database: [Your dev database name]

    # Warning: The database defined as "test" will be erased and
    # re-generated from your development database when you run "rake".
    # Do not set this db to the same as development or production.
    test:
      <<: *default
      database: [Your test database name]
    {% endprettify %}

4. Create DB using PostgreSQL now.

    > rake db:create && rake db:migrate

[PostgreSQL]: http://www.postgresql.org/
[SQLite]: http://www.sqlite.org/
[Homebrew]: http://brew.sh/
[Postgres.app]: http://postgresapp.com/
[EnterpriseDB]: http://www.enterprisedb.com/products-services-training/products/postgresql-overview
[pgAdmin]: http://www.pgadmin.org/
