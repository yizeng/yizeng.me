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