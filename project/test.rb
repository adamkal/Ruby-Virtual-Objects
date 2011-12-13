#!/usr/bin/ruby

require "virtual.rb"
require "test/unit"

Person = Struct.new(:first_name, 
                    :last_name, 
                    :age, 
                    :address, 
                    :phone)
PEOPLE = [
  Person.new('Ryszard', 'Ochódzki', 32, 'al. Jerozolimskie 10', 22111111),
  Person.new('Stanisław', 'Paluch', 32, 'al. Ząbkowska 3', 22222222),
  Person.new('Irena', 'Ochódzka', 30, 'al. Jerozolimskie 10', 22333333),
  Person.new('Aleksandra', 'Kozeł', 28, 'ul. Puławska 102', 22444444),
  Person.new('Jan', 'Hochwander', 32, 'ul. Miodowa 14', 22555555),
  Person.new('Wacław', 'Jarząbek', 32, 'ul. Alternatywy 4', 22666666),
]

class Contact < View
  virtual :name, :phone, :age
  seed *PEOPLE

  def on_update(person, value)
    person.first_name = value.name.split()[0]
    person.last_name = value.name.split()[-1]
    person.age = value.age
  end

  def on_retrieve(person)
    @virtual.name = "#{person.first_name} #{person.last_name}"
    @virtual.phone = person.phone
    @virtual.age = person.age
  end
end


class VirtualPerspectiveTestCase < Test::Unit::TestCase
  def setup
    @contact = Contact.new
  end

  def test_retrieve
    assert_kind_of(Array, @contact.name)
    names = PEOPLE.collect { |p| "#{p.first_name} #{p.last_name}"}
    assert_equal(names, @contact.name)
  end

  def test_update
    @contact.age = 60
    PEOPLE.each { |p| assert_equal(60, p.age) } 
  end

  def test_no_method
    assert_raise(NoMethodError) { @contact.non_existing_method }
  end

  def test_subview
    assert_equal(0, 1)
  end
end

