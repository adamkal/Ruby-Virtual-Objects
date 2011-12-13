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
#   * operator methods
#   * object definition (what attributes it has and so on)
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
# w.kolo
# w.samochod("duuuuzy")

# Now let's try and solve the probelm of virtual object in SBA sense. That is which
# has vitrual structure resembling normal object but is not a real object. 
# At this point I'll use hashes as a simple way of controlling variables but later on
# it migth be a good idea to use singletons as thay might be more convinient option as a
# virtual object
#
# In comparison to ealier (my) approach the dict is usefull for creating simple operators

class Virtual

  def Virtual.structure(*args)
    puts "Creating virtual structure for #{self}"
    @@virtual_struct = Struct.new("Virtual#{self.class}", *args)
    puts "Created struct #{@virtual_struct}"
  end

  def initialize(obj)
    @virtual_obj = @@virtual_struct.new
  end

  def method_missing(method, *args, &block)
    puts "Searching for method #{method} in #{self}"
    method = method.to_s
    action = :on_retrieve

    if method.end_with? "="
      method = method[0..-2]
      action = :on_update
    end

    if @@virtual_struct.members.include? method
      args = [method] + args
      self.send(action, *args)
    else
      raise NoMethodError
    end

    puts "Action: #{action}"
  end
end


puts "-" * 10 
class Test < Virtual
  structure :name, :age

  def on_update(name, *args)
    puts "I'm updating #{name} for #{@virtual_obj}"
  end

  def on_retrieve(name)
    puts "I'm retrieving #{name} #{@virtual_obj}"
    @virtual_obj.send name
  end
end

puts "=" * 1
t = Test.new("fas")
t.age = 3
puts t.age 

