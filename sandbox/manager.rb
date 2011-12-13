#!/usr/bin/ruby

# = Manager 
#
# This code demonstrates an idea on how to create manager class for virtual perspectives.
# Concepts introduced here will be used as a part of Adam Kalinski's master thesis. 
#
# Author:: 	Adam Kalinski
#
# What a manager shoud do
# 1. provide information about seed 
# 	- is manager specific
# 	- contains data structure/structures (classes) as parameters
# 	- contains conditions
# 	- takes parent manager (view) as parameter so that it can use parent seeds
# 2. should provide operator methods
# 	- operators take seed implicitly
# 3. defines local objects
class ManagerError < Exception
end

class Manager
	def initialize(objects)
    @seed_objects = seed

    puts "Objects=#{@seed_objects}"
	end

  def seed
    raise ManagerError, "'seed' method was not defined in Manager"
  end

  def virtual(name, *args) 
    
  end
end


class MyManager < Manager
  def seed
    %w{ala ma kota}
  end
end

MyManager.new(%w(raz dwa trzy cztery))

