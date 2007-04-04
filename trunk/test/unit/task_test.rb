require File.dirname(__FILE__) + '/../test_helper'

class TaskTest < Test::Unit::TestCase
  fixtures :tasks

	NEW_TASK = {}	# e.g. {:name => 'Test Task', :description => 'Dummy'}
	REQ_ATTR_NAMES 			 = %w( ) # name of fields that must be present, e.g. %(name description)
	DUPLICATE_ATTR_NAMES = %w( ) # name of fields that cannot be a duplicate, e.g. %(name description)

  def setup
    # Retrieve fixtures via their name
    # @first = tasks(:first)
  end

  def test_raw_validation
    task = Task.new
    if REQ_ATTR_NAMES.blank?
      assert task.valid?, "Task should be valid without initialisation parameters"
    else
      # If Task has validation, then use the following:
      assert !task.valid?, "Task should not be valid without initialisation parameters"
      REQ_ATTR_NAMES.each {|attr_name| assert task.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"}
    end
  end

	def test_new
    task = Task.new(NEW_TASK)
    assert task.valid?, "Task should be valid"
   	NEW_TASK.each do |attr_name|
      assert_equal NEW_TASK[attr_name], task.attributes[attr_name], "Task.@#{attr_name.to_s} incorrect"
    end
 	end

	def test_validates_presence_of
   	REQ_ATTR_NAMES.each do |attr_name|
			tmp_task = NEW_TASK.clone
			tmp_task.delete attr_name.to_sym
			task = Task.new(tmp_task)
			assert !task.valid?, "Task should be invalid, as @#{attr_name} is invalid"
    	assert task.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
    end
 	end

	def test_duplicate
    current_task = Task.find_first
   	DUPLICATE_ATTR_NAMES.each do |attr_name|
   		task = Task.new(NEW_TASK.merge(attr_name.to_sym => current_task[attr_name]))
			assert !task.valid?, "Task should be invalid, as @#{attr_name} is a duplicate"
    	assert task.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
		end
	end
end

