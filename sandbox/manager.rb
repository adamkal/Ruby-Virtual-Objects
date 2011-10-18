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


class Manager
	def initialize(*args)
		Seed.new
	end
end


class MyManager < Manager
	class MyManager.Seed
		def initialize
			puts 'hello from seed'
		end
	end
end


MyManager.new(%w(raz dwa trzy cztery))

