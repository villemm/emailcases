require File.dirname(__FILE__) + '/../test_helper'

class DurationTest < Test::Unit::TestCase
  fixtures :durations

	NEW_DURATION = {}	# e.g. {:name => 'Test Duration', :description => 'Dummy'}
	REQ_ATTR_NAMES 			 = %w( ) # name of fields that must be present, e.g. %(name description)
	DUPLICATE_ATTR_NAMES = %w( ) # name of fields that cannot be a duplicate, e.g. %(name description)

  def setup
    # Retrieve fixtures via their name
    # @first = durations(:first)
  end

  def test_raw_validation
    duration = Duration.new
    if REQ_ATTR_NAMES.blank?
      assert duration.valid?, "Duration should be valid without initialisation parameters"
    else
      # If Duration has validation, then use the following:
      assert !duration.valid?, "Duration should not be valid without initialisation parameters"
      REQ_ATTR_NAMES.each {|attr_name| assert duration.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"}
    end
  end

	def test_new
    duration = Duration.new(NEW_DURATION)
    assert duration.valid?, "Duration should be valid"
   	NEW_DURATION.each do |attr_name|
      assert_equal NEW_DURATION[attr_name], duration.attributes[attr_name], "Duration.@#{attr_name.to_s} incorrect"
    end
 	end

	def test_validates_presence_of
   	REQ_ATTR_NAMES.each do |attr_name|
			tmp_duration = NEW_DURATION.clone
			tmp_duration.delete attr_name.to_sym
			duration = Duration.new(tmp_duration)
			assert !duration.valid?, "Duration should be invalid, as @#{attr_name} is invalid"
    	assert duration.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
    end
 	end

	def test_duplicate
    current_duration = Duration.find_first
   	DUPLICATE_ATTR_NAMES.each do |attr_name|
   		duration = Duration.new(NEW_DURATION.merge(attr_name.to_sym => current_duration[attr_name]))
			assert !duration.valid?, "Duration should be invalid, as @#{attr_name} is a duplicate"
    	assert duration.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
		end
	end
end

