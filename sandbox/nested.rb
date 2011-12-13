#!/usr/bin/ruby

class A
  puts 'A body'
  def initialize
    puts 'initializing A'
  end
end

class B < A
  puts 'B body'
  def initialize
    puts 'initializing B'
  end

  class C
    puts 'C body'
  end
end

puts "Testing A"
A.new
puts 'Testing B'
B.new
