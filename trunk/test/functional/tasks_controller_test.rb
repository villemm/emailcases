require File.dirname(__FILE__) + '/../test_helper'
require 'tasks_controller'

# Re-raise errors caught by the controller.
class TasksController; def rescue_action(e) raise e end; end

class TasksControllerTest < Test::Unit::TestCase
  fixtures :tasks

	NEW_TASK = {}	# e.g. {:name => 'Test Task', :description => 'Dummy'}
	REDIRECT_TO_MAIN = {:action => 'list'} # put hash or string redirection that you normally expect

	def setup
		@controller = TasksController.new
		@request    = ActionController::TestRequest.new
		@response   = ActionController::TestResponse.new
		# Retrieve fixtures via their name
		# @first = tasks(:first)
		@first = Task.find_first
	end

  def test_component
    get :component
    assert_response :success
    assert_template 'tasks/component'
    tasks = check_attrs(%w(tasks))
    assert_equal Task.find(:all).length, tasks.length, "Incorrect number of tasks shown"
  end

  def test_component_update
    get :component_update
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_component_update_xhr
    xhr :get, :component_update
    assert_response :success
    assert_template 'tasks/component'
    tasks = check_attrs(%w(tasks))
    assert_equal Task.find(:all).length, tasks.length, "Incorrect number of tasks shown"
  end

  def test_create
  	task_count = Task.find(:all).length
    post :create, {:task => NEW_TASK}
    task, successful = check_attrs(%w(task successful))
    assert successful, "Should be successful"
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
    assert_equal task_count + 1, Task.find(:all).length, "Expected an additional Task"
  end

  def test_create_xhr
  	task_count = Task.find(:all).length
    xhr :post, :create, {:task => NEW_TASK}
    task, successful = check_attrs(%w(task successful))
    assert successful, "Should be successful"
    assert_response :success
    assert_template 'create.rjs'
    assert_equal task_count + 1, Task.find(:all).length, "Expected an additional Task"
  end

  def test_update
  	task_count = Task.find(:all).length
    post :update, {:id => @first.id, :task => @first.attributes.merge(NEW_TASK)}
    task, successful = check_attrs(%w(task successful))
    assert successful, "Should be successful"
    task.reload
   	NEW_TASK.each do |attr_name|
      assert_equal NEW_TASK[attr_name], task.attributes[attr_name], "@task.#{attr_name.to_s} incorrect"
    end
    assert_equal task_count, Task.find(:all).length, "Number of Tasks should be the same"
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_update_xhr
  	task_count = Task.find(:all).length
    xhr :post, :update, {:id => @first.id, :task => @first.attributes.merge(NEW_TASK)}
    task, successful = check_attrs(%w(task successful))
    assert successful, "Should be successful"
    task.reload
   	NEW_TASK.each do |attr_name|
      assert_equal NEW_TASK[attr_name], task.attributes[attr_name], "@task.#{attr_name.to_s} incorrect"
    end
    assert_equal task_count, Task.find(:all).length, "Number of Tasks should be the same"
    assert_response :success
    assert_template 'update.rjs'
  end

  def test_destroy
  	task_count = Task.find(:all).length
    post :destroy, {:id => @first.id}
    assert_response :redirect
    assert_equal task_count - 1, Task.find(:all).length, "Number of Tasks should be one less"
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_destroy_xhr
  	task_count = Task.find(:all).length
    xhr :post, :destroy, {:id => @first.id}
    assert_response :success
    assert_equal task_count - 1, Task.find(:all).length, "Number of Tasks should be one less"
    assert_template 'destroy.rjs'
  end

protected
	# Could be put in a Helper library and included at top of test class
  def check_attrs(attr_list)
    attrs = []
    attr_list.each do |attr_sym|
      attr = assigns(attr_sym.to_sym)
      assert_not_nil attr,       "Attribute @#{attr_sym} should not be nil"
      assert !attr.new_record?,  "Should have saved the @#{attr_sym} obj" if attr.class == ActiveRecord
      attrs << attr
    end
    attrs.length > 1 ? attrs : attrs[0]
  end
end
