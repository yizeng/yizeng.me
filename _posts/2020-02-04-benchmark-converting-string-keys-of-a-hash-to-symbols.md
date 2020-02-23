---
layout: post
title: "Benchmark converting string keys of a hash to symbols"
description: "Benchmark the performance of various ways of converting string keys of a (nested) hash to symbols using transform_keys, with_indifferent_access, symbolize_keys and more."
categories: [articles]
tags: [benchmarking, ruby, ruby on rails]
redirect_from:
  - /2020/02/04/
---

There are several ways of converting string keys to symbols in hash.
But ever wondered how fast they are and what's the difference?

## TL;DR

                                    user     system       total           real
    transform_keys:             6.994507    0.014749    7.009256  (  7.022791)
    using_each_with_object:    11.424220    0.041001   11.465221  ( 11.511807)
    symbolize_keys:             7.628721    0.018207    7.646928  (  7.665882)

    with_indifferent_access:  107.970348    0.446824  108.417172  (109.052287)
    deep_symbolize_keys:       95.842033    0.551120   96.393153  ( 97.145661)


## Shallow Symbolizing

Shallow symbolizing means it will only convert the string keys of a hash
to symbols without converting the keys in the nested hashes.

### Ruby < 2.5

Before Ruby 2.5, there are no handy methods in Ruby to convert string hash keys to symbols.
But the enumberable method `each_with_object` can be used to achieve it.

```ruby
{"dimensions" => { "height" => 10 } }.each_with_object({}) { |(k,v), h| h[k.to_sym] = v }
```

### Ruby >= 2.5

Since Ruby 2.5, a new method `transform_keys` has been added to Hash class,
which can be used to convert string keys to symbols.

<https://ruby-doc.org/core-2.5.0/Hash.html#method-i-transform_keys>{:target="_blank"}

```ruby
{"dimensions" => { "height" => 10 } }.transform_keys(&:to_sym)
```

### Ruby on Rails

Ruby on Rails' active support provides `symbolize_keys`
on Hash class to symbolize keys.

```ruby
{"dimensions" => { "height" => 10 } }.symbolize_keys
```

## Deep Symbolizing

Ruby on Rails' active_support provides two ways of achieving this.

### with_indifferent_access

<https://api.rubyonrails.org/classes/ActiveSupport/HashWithIndifferentAccess.html>{:target="_blank"}

It converts the hash keys (nested) so that strings and hashes are considered same.

```ruby
hash = {"dimensions" => { "height" => 10 } }.with_indifferent_access
# hash.dig(:dimensions, :height) # => 10
# hash.dig('dimensions', 'height') # => 10
```

### deep_symbolize_keys

<https://apidock.com/rails/v6.0.0/Hash/deep_symbolize_keys>{:target="_blank"}

It is similar to `symbolize_keys` method,
but it includes the keys from the root hash and from all nested hashes and arrays.

Unlike `with_indifferent_access`, once converted,
the keys in the new hash can no longer be retrieved via original string format.

```ruby
hash = {"dimensions" => { "height" => 10 } }.deep_symbolize_keys
# hash.dig(:dimensions, :height) # => 10
# hash.dig('dimensions', 'height') # => nil
```

## Benchmarking

### Code

```ruby
require 'benchmark'
require 'active_support/all'

TIMES = 50_000_000
HASH = {
  "colour" => "red",
  "sizes" => [
    "measurements_1" => {
      "height" => 1,
      "length" => 2,
      "depth" => 3,
    },
    "measurements_2" => {
      "height" => 10,
      "length" => 20,
      "depth" => 30,
    }
  ]
}

Benchmark.bm do |x|
  x.report("transform_keys:") { TIMES.times { HASH.transform_keys(&:to_sym) } }
  x.report("using_each_with_object:") { TIMES.times { HASH.each_with_object({}) { |(k,v), h| h[k.to_sym] = v } } }
  x.report("symbolize_keys:") { TIMES.times { HASH.symbolize_keys } }
  x.report("with_indifferent_access:") { TIMES.times { HASH.with_indifferent_access } }
  x.report("deep_symbolize_keys:") { TIMES.times { HASH.deep_symbolize_keys } }
end
```

### Results

                                    user     system       total           real
    transform_keys:             6.994507    0.014749    7.009256  (  7.022791)
    using_each_with_object:    11.424220    0.041001   11.465221  ( 11.511807)
    symbolize_keys:             7.628721    0.018207    7.646928  (  7.665882)

    with_indifferent_access:  107.970348    0.446824  108.417172  (109.052287)
    deep_symbolize_keys:       95.842033    0.551120   96.393153  ( 97.145661)
