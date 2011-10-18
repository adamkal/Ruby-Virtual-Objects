#!/usr/bin/ruby

# = Virtual objects 
#
# This demonstrates how virtual objects could be organized. This file introduces
# some ideas of how to provide object functionality without creation of real
# object (or as cloase to that fact as possible)
#
# Author:: Adam Kaliński
#
# Requirements:
# 	* operator methods
# 	* object definition (what attributes it has and so on)
#

class Manager
	def initialize(dict)
		# in this document we do not concentrate on how objects are managed so it is
		# not important what the init. parameter will be. For now let's assume that
		# it's a dict of real objects. 
		#
		# how to manage seed and related issues are concidered in _manager.rb_ file
		@record = dict
	end

	def record
		@record
	end

	def Manager.on_retrieve(seed)
		puts "On retrieve called on #{seed}"
	end

	def Manager.on_update(seed)
		puts "On update called on #{seed}"
	end

	def Manager.on_delete(seed)
		puts "On delete called on #{seed}"
	end

	def Manager.on_new(seed)
		puts "On new called on #{seed}"
	end

	def Manager.on_navigate(seed)
		puts "On navigte called on #{seed}"
	end
end

# This is the simplest option where no additional help from framework is added. 
# Everything is explicit. 

# mgr = Manager.new({:name => 'Ryszard', :surname => 'Ochódzki', :profession => 'prezes'})
# Manager.on_retrieve(mgr.record)
# Manager.on_update(mgr.record)
# Manager.on_delete(mgr.record)
# Manager.on_new(mgr.record)
# Manager.on_navigate(mgr.record)


# Simple object wrapper
# this does a simple operation: it wraps the "retrieve" operation so that we 
# can actually change it as much as we want and retrieve totally different object

class Wrapper
  def initialize(obj)
    @obj = obj
  end
  
  def method_missing(m, *args, &block)
		if args.size == 0
	    return on_retrieve(m, &block)
		else
			return on_update(m, *args, &block)
		end
	end
  
  def on_retrieve(method, &block)
		puts "Retrieving #{method}"

  end

	def on_update(method, *args, &block)
		puts "Updating #{method} with args #{args}"
		
	end
  
end
  
# w = Wrapper.new("ala ma kota")
# w.dupa
# w.cycki("duuuuze")

# Now let's try and solve the probelm of virtual object in SBA sense. That is which
# has vitrual structure resembling normal object but is not a real object. 
# At this point I'll use hashes as a simple way of controlling variables but later on
# it migth be a good idea to use singletons as thay might be more convinient option as a
# virtual object


