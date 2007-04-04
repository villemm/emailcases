require File.dirname(__FILE__) + '/../test_helper'

class PersonTest < Test::Unit::TestCase
  fixtures :people

	NEW_PERSON = {}	# e.g. {:name => 'Test Person', :description => 'Dummy'}
	REQ_ATTR_NAMES 			 = %w( ) # name of fields that must be present, e.g. %(name description)
	DUPLICATE_ATTR_NAMES = %w( ) # name of fields that cannot be a duplicate, e.g. %(name description)

  def setup
    # Retrieve fixtures via their name
    # @first = people(:first)
  end

  def test_raw_validation
    person = Person.new
    if REQ_ATTR_NAMES.blank?
      assert person.valid?, "Person should be valid without initialisation parameters"
    else
      # If Person has validation, then use the following:
      assert !person.valid?, "Person should not be valid without initialisation parameters"
      REQ_ATTR_NAMES.each {|attr_name| assert person.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"}
    end
  end

	def test_new
    person = Person.new(NEW_PERSON)
    assert person.valid?, "Person should be valid"
   	NEW_PERSON.each do |attr_name|
      assert_equal NEW_PERSON[attr_name], person.attributes[attr_name], "Person.@#{attr_name.to_s} incorrect"
    end
 	end

	def test_validates_presence_of
   	REQ_ATTR_NAMES.each do |attr_name|
			tmp_person = NEW_PERSON.clone
			tmp_person.delete attr_name.to_sym
			person = Person.new(tmp_person)
			assert !person.valid?, "Person should be invalid, as @#{attr_name} is invalid"
    	assert person.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
    end
 	end

	def test_duplicate
    current_person = Person.find_first
   	DUPLICATE_ATTR_NAMES.each do |attr_name|
   		person = Person.new(NEW_PERSON.merge(attr_name.to_sym => current_person[attr_name]))
			assert !person.valid?, "Person should be invalid, as @#{attr_name} is a duplicate"
    	assert person.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
		end
	end
end

