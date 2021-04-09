---
layout: post
title: "Truthy, Falsey, nil?, any?, empty?, blank? and present? in Ruby and Ruby on Rails"
description: "What's truthy, falsey, nil?, empty?, blank? and present? in Ruby and Ruby on Rails."
categories: [articles]
tags: [ruby, ruby on rails]
redirect_from:
  - /2021/04/04/
---

Here's a quick comparison of Ruby's truthy, falsey, `nil?`, `any?`, `empty?`
against Ruby on Rails' `blank?` and `present?`.

* Kramdown table of contents
{:toc .toc}

## TL;DR

### Ruby

| Truthy | Used to evaluate `if`/`unless` conditions. Everything is truthy except for `nil` and `false`.|
| Falsey | The negation of truthy. Only `nil` and `false` are falsey in Ruby. |
| `nil?` | Defined on Ruby's [Object][RubyDoc Object]{:target="_blank"} class. |
| `empty?` | Defined only for certain objects of [Array][RubyDoc Array]{:target="_blank"}, [Hash][RubyDoc Hash]{:target="_blank"}, [String][RubyDoc String]{:target="_blank"} etc. It throws `NoMethodError` for nil, TrueClass, FalseClass, Integer etc. |
| `any?` | Defined in the mixin module [Enumerable][RubyDoc Enumerable]{:target="_blank"}, which is included in classes like Array and Hash. |

### Rails

| `blank?`, `present?` | Defined in Ruby on Rails' [ActiveSupport][ActiveSupport blank?]{:target="_blank"}, which can also be installed independently without Rails. |
| `blank?` | `nil`, `false`, empty/whitespace strings, empty arrays, hashes and any other objects with `object.empty?` is true. |
| `present?` | The negation of `blank?`, i.e. `!blank?`. |
| `0` | is not blank (i.e. `0.present? # => true`). |

### Summary

| Methods  | Values                                                                         |
|----------|--------------------------------------------------------------------------------|
| Truthy   | true, "", "\n", "Hello", 0, 1.25, [], [nil, false], [1, 2], {}, {:colour=>nil} |
| Falsey   | nil, false                                                                     |
| nil?     | nil                                                                            |
| any?     | [1, 2], {:colour=>nil}                                                         |
| empty?   | "", [], {}                                                                     |
| blank?   | nil, false, "", "\n", [], {}                                                   |
| present? | true, "Hello", 0, 1.25, [nil, false], [1, 2], {:colour=>nil}                   |

|                                                | truthy | falsey | nil? | any?          | empty?        | blank? | present? |
|------------------------------------------------|--------|--------|------|---------------|---------------|--------|----------|
| nil                                            |        | ✓      | ✓    | NoMethodError | NoMethodError | ✓      |          |
|                                                |        |        |      |               |               |        |          |
| false                                          |        | ✓      |      | NoMethodError | NoMethodError | ✓      |          |
| true                                           | ✓      |        |      | NoMethodError | NoMethodError |        | ✓        |
|                                                |        |        |      |               |               |        |          |
| ""                                             | ✓      |        |      | NoMethodError | ✓             | ✓      |          |
| "\n"                                           | ✓      |        |      | NoMethodError |               | ✓      |          |
| "Hello"                                        | ✓      |        |      | NoMethodError |               |        | ✓        |
|                                                |        |        |      |               |               |        |          |
| 0                                              | ✓      |        |      | NoMethodError | NoMethodError |        | ✓        |
| 1.25                                           | ✓      |        |      | NoMethodError | NoMethodError |        | ✓        |
|                                                |        |        |      |               |               |        |          |
| []                                             | ✓      |        |      |               | ✓             | ✓      |          |
| [nil, false]                                   | ✓      |        |      |               |               |        | ✓        |
| [1, 2]                                         | ✓      |        |      | ✓             |               |        | ✓        |
|                                                |        |        |      |               |               |        |          |
| {}                                             | ✓      |        |      |               | ✓             | ✓      |          |
| { colour: nil }                                | ✓      |        |      | ✓             |               |        | ✓        |
|                                                |        |        |      |               |               |        |          |
| Object responds to empty? and evaluate to true | ✓      |        |      |               | ✓             | ✓      |          |

## Difference between any? and empty?

`any?` is defined in the mixin module [Enumerable][RubyDoc Enumerable]{:target="_blank"}
to check if the enumberable contains the values evaluated from a given block.
When no block is given,
it returns **true** if the object contains a value other than false or nil. 

Since [Array][RubyDoc Array]{:target="_blank"}, [Hash][RubyDoc Hash]{:target="_blank"} both include the Enumerable module,
both `any?` and `empty?` methods become available.

- For Hashes, `any?` is an antonym of `empty?`, i.e. `{}.any?` is false and `{}.empty?` is true. 
- For Arrays, `any?` is almost the antonym of `empty?`, except for `nil` and `false`, that **`[nil, false].any?` is false, while `[nil, false].empty?` is also false**.

## Difference between empty? and blank?

`empty?` is simply a Ruby method defined on certain classes,
e.g. [Array][RubyDoc Array]{:target="_blank"}, [Hash][RubyDoc Hash]{:target="_blank"}, [String][RubyDoc String]{:target="_blank"},
while `blank?`/`present?` are Ruby on Rails methods defined in
[ActiveSupport][ActiveSupport blank?]{:target="_blank"}, which can also be installed independently with Rails.

By definition, `blank?` includes:
- `nil`
- `false`
- empty/whitespace strings
- empty arrays, hashes
- any other objects with `object.empty?` is true

## Difference between blank? and present?

[`present?`][ActiveSupport present?]{:target="_blank"} is just a negation of `blank?`.

```ruby
# File activesupport/lib/active_support/core_ext/object/blank.rb, line 25
def present?
  !blank?
end
```

## The presence method

Defined together with [`present?`][ActiveSupport present?]{:target="_blank"},
`presence` method returns the receiver if it's present otherwise returns nil.

`object.presence` is equivalent to `object.present? ? object : nil`.

For example, something like

    def display_name
      return user.name if user.name.present?

      "Demo User"
    end

becomes

    def display_name
      user.name.presence || "Demo User"
    end


## [Bonus] Logical Operators

| Operator | Name           | Description                                     | Example                                         |
|----------|----------------|-------------------------------------------------|-------------------------------------------------|
| !        | Logical Not    | Negates the truthy or falsey value of an object | `!user.active?`                             |
| !!       | Logical Truthy | Returns the truthy or falsey of an object       | `!![]`                                          |
| &&       | Logical And    | Returns true if both statements are truthy      | `user.name.present? && user.active?`    |
| \|\|     | Logicall Or    | Returns true if one of the statements is truthy | `user.name.blank? || user.discarded?` |


```ruby
nil && true # => nil
true && nil # => nil
nil || "" # => ""
nil || true # => true
0 && 1.25 # => 1.25
0 || 1.25 # => 0
```

## Sample Code

### Example

```ruby
require "active_support"
require "active_support/core_ext/object/blank"

VALUES = [
  nil, false, true, "", "\n", "Hello", 0, 1.25, [], [nil, false], [1, 2], {}, { colour: nil }
]

puts `ruby -v`
puts `rails -v`
puts

puts "All Values: #{VALUES}"
puts

puts "Truthy: #{VALUES.select { |v| !!v == true } }"
puts "Falsey: #{VALUES.select { |v| !!v == false } }"
puts "nil?: #{VALUES.select { |v| v.nil? == true } }"
puts "any?: #{VALUES.select { |v| v.respond_to?(:any?) && v.any? == true } }"
puts "empty?: #{VALUES.select { |v| v.respond_to?(:empty?) && v.empty? == true } }"

puts

puts "blank?: #{VALUES.select { |v| v.blank? == true } }"
puts "present?: #{VALUES.select { |v| v.present? == true } }"
```

### Results

    ruby 2.7.2p137 (2020-10-01 revision 5445e04352) [x86_64-darwin18]
    Rails 6.0.3.5

    All Values: nil, false, true, "", "\n", "Hello", 0, 1.25, [], [nil, false], [1, 2], {}, {:colour=>nil}

    Truthy: true, "", "\n", "Hello", 0, 1.25, [], [nil, false], [1, 2], {}, {:colour=>nil}
    Falsey: nil, false
    nil?: nil
    any?: [1, 2], {:colour=>nil}
    empty?: "", [], {}

    blank?: nil, false, "", "\n", [], {}
    present?: true, "Hello", 0, 1.25, [nil, false], [1, 2], {:colour=>nil}

[ActiveSupport blank?]: https://api.rubyonrails.org/classes/Object.html#method-i-blank-3F
[ActiveSupport present?]: https://api.rubyonrails.org/classes/Object.html#method-i-present-3F
[RubyDoc Array]: https://ruby-doc.org/core-3.0.0/Array.html#method-i-empty-3F
[RubyDoc Enumerable]: https://ruby-doc.org/core-3.0.0/Enumerable.html#method-i-any-3F
[RubyDoc Hash]: https://ruby-doc.org/core-3.0.0/Hash.html#method-i-empty-3F
[RubyDoc Object]: https://ruby-doc.org/core-3.0.0/Object.html#method-i-nil-3F
[RubyDoc String]: https://ruby-doc.org/core-3.0.0/String.html#method-i-empty-3F