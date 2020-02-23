---
layout: post
title: "Reduce GraphQL Ruby mutation arguments in resolve method"
description: "Reduce GraphQL Ruby mutation arguments in the resolve method."
categories: [articles]
tags: [graphql, ruby, ruby on rails]
redirect_from:
  - /2020/02/04/
---
[GraphQL Ruby gem](https://graphql-ruby.org/){:target="_blank"} helps to add GraphQL support to Ruby or Ruby on Rails applications.

The [official guides](https://graphql-ruby.org/guides){:target="_blank"}
or [How to GraphQL](https://www.howtographql.com/){:target="_blank"} website would be a good starting point.

## The Basics

Here is a basic sign up mutation that handles the sign up process:

```ruby
class Mutations::SignUp < Mutations::BaseMutation
  null true

  argument :email, String, required: true
  argument :password, String, required: true

  field :token, String, null: true
  field :user, Types::UserType, null: true

  def resolve(email:, password:)
    # create your user with passed in email and password.
  end
end
```

## The Problem

But what if it's a third party client calling this mutation endpoint with a lot of parameters?

Here is an example (the parameters are illustrative only, which may not make total sense).

Mutation's `resolve` function would now have 10+ parameters.

```ruby
class Mutations::SignUp < Mutations::BaseMutation
  null true

  argument :email, String, required: true
  argument :password, String, required: true
  argument :expires_at, GraphQL::Types::BigInt, required: true
  argument :expires_in, GraphQL::Types::BigInt, required: true
  argument :resource_state, Int, required: true
  argument :username, String, required: false
  argument :firstname, String, required: true
  argument :lastname, String, required: true
  argument :sex, String, required: false
  argument :active_till, GraphQL::Types::ISO8601DateTime, required: true

  field :token, String, null: true
  field :user, Types::UserType, null: true

  def resolve(email:, password:, expires_at:, expires_in:, resource_state:,
              username:, firstname:, lastname:, lastname:, sex:, active_till:)
    # create your user with data passed in.
  end
end
```

## The Solutions

### Use double splat operator (**)

Ruby 2.0 introduced double splat operator captures all keyword arguments.

```ruby
class Mutations::SignUp < Mutations::BaseMutation
  null true

  argument :email, String, required: true
  argument :password, String, required: true
  argument :expires_at, GraphQL::Types::BigInt, required: true
  argument :expires_in, GraphQL::Types::BigInt, required: true
  argument :resource_state, Int, required: true
  argument :username, String, required: false
  argument :firstname, String, required: true
  argument :lastname, String, required: true
  argument :sex, String, required: false
  argument :active_till, GraphQL::Types::ISO8601DateTime, required: true

  field :token, String, null: true
  field :user, Types::UserType, null: true

  def resolve(**arguments)
    # create your user with data passed in.
    # arguments is a hash like this: { email: '', password: '', expires_at: 1234556, ... }
    # use arguments[:email] to access them.
  end
end
```

### Create a new Type

<https://graphql-ruby.org/guides#type-definitions-guides>{:target="_blank"}

```ruby
module Types
  class SignUpArguments < Types::BaseInputObject
    argument :expires_at, GraphQL::Types::BigInt, required: true
    argument :expires_in, GraphQL::Types::BigInt, required: true
    argument :resource_state, Int, required: true
    argument :username, String, required: false
    argument :firstname, String, required: true
    argument :lastname, String, required: true
    argument :sex, String, required: false
    argument :active_till, GraphQL::Types::ISO8601DateTime, required: true
  end
end

```

```ruby
class Mutations::SignUp < Mutations::BaseMutation
  null true

  argument :email, String, required: true
  argument :password, String, required: true
  argument :sign_up_details, Types::SignUpArguments, required: true

  field :token, String, null: true
  field :user, Types::UserType, null: true

  def resolve(email:, password:, sign_up_details:)
    # create your user with data passed in.
    # sign_up_details.to_h => { expires_at: 1234556, ... }
  end
end
```