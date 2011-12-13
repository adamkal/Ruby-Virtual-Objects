#!/usr/bin/ruby

# *virtual* is implemented using ruby Struct

class View
  def View.virtual(*args)
    @@virtual_type = Struct.new("View#{self}", *args)
  end

  def View.seed(*args, &block)
    if args.size == 0
      @@seeds = block.call
    else
      @@seeds = args
    end
  end

  def initialize()
    @virtual = @@virtual_type.new
  end

  def method_missing(method, *args, &block)
    attribute = get_virtual_attribute(method)
    operator = get_operation_type(method)

    if is_supported_attribute(attribute)
      handle_attribute(method, attribute, operator, *args)
    else
      raise NoMethodError, "Attribute '#{method}' does not exist"
    end
  end

  private
  def get_virtual_attribute(method)
    method = method.to_s
    if method.end_with? "="
      method = method[0..-2]
    end
    method
  end

  def get_operation_type(method)
    method = method.to_s
    if method.end_with? "="
      :do_update
    else
      :do_retrieve
    end
  end
  
  def is_supported_attribute(attribute)
    @@virtual_type.members.include? attribute
  end

  def handle_attribute(method, attribute, operator, *args)
    if has_subview_for_attribute(attribute)
      handle_with_subview(method, *args)
    else 
      handle_with_operator(attribute, operator, *args)
    end
  end

  def has_subview_for_attribute(attribute)
    self.class.constants.include? attribute 
  end

  def handle_with_subview(method, *args)
  end

  def handle_with_operator(attribute, operator, *args)
    @@seeds.collect do |e|
      self.send(operator, e, attribute, *args)
      @virtual.send attribute
    end
  end

  def do_retrieve(seed, attribute)
    on_retrieve(seed)
  end

  def do_update(seed, attribute, value, *args)
    on_retrieve(seed) # will load data to @virtual TODO refactor 
    @virtual.send("#{attribute}=", value)
    on_update(seed, @virtual)
  end

  def do_create
  end

  def do_delete
  end
end

