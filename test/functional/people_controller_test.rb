require File.dirname(__FILE__) + '/../test_helper'
require 'people_controller'

# Re-raise errors caught by the controller.
class PeopleController; def rescue_action(e) raise e end; end

class PeopleControllerTest < Test::Unit::TestCase
  fixtures :people

	NEW_PERSON = {}	# e.g. {:name => 'Test Person', :description => 'Dummy'}
	REDIRECT_TO_MAIN = {:action => 'list'} # put hash or string redirection that you normally expect

	def setup
		@controller = PeopleController.new
		@request    = ActionController::TestRequest.new
		@response   = ActionController::TestResponse.new
		# Retrieve fixtures via their name
		# @first = people(:first)
		@first = Person.find_first
	end

  def test_component
    get :component
    assert_response :success
    assert_template 'people/component'
    people = check_attrs(%w(people))
    assert_equal Person.find(:all).length, people.length, "Incorrect number of people shown"
  end

  def test_component_update
    get :component_update
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_component_update_xhr
    xhr :get, :component_update
    assert_response :success
    assert_template 'people/component'
    people = check_attrs(%w(people))
    assert_equal Person.find(:all).length, people.length, "Incorrect number of people shown"
  end

  def test_create
  	person_count = Person.find(:all).length
    post :create, {:person => NEW_PERSON}
    person, successful = check_attrs(%w(person successful))
    assert successful, "Should be successful"
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
    assert_equal person_count + 1, Person.find(:all).length, "Expected an additional Person"
  end

  def test_create_xhr
  	person_count = Person.find(:all).length
    xhr :post, :create, {:person => NEW_PERSON}
    person, successful = check_attrs(%w(person successful))
    assert successful, "Should be successful"
    assert_response :success
    assert_template 'create.rjs'
    assert_equal person_count + 1, Person.find(:all).length, "Expected an additional Person"
  end

  def test_update
  	person_count = Person.find(:all).length
    post :update, {:id => @first.id, :person => @first.attributes.merge(NEW_PERSON)}
    person, successful = check_attrs(%w(person successful))
    assert successful, "Should be successful"
    person.reload
   	NEW_PERSON.each do |attr_name|
      assert_equal NEW_PERSON[attr_name], person.attributes[attr_name], "@person.#{attr_name.to_s} incorrect"
    end
    assert_equal person_count, Person.find(:all).length, "Number of Persons should be the same"
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_update_xhr
  	person_count = Person.find(:all).length
    xhr :post, :update, {:id => @first.id, :person => @first.attributes.merge(NEW_PERSON)}
    person, successful = check_attrs(%w(person successful))
    assert successful, "Should be successful"
    person.reload
   	NEW_PERSON.each do |attr_name|
      assert_equal NEW_PERSON[attr_name], person.attributes[attr_name], "@person.#{attr_name.to_s} incorrect"
    end
    assert_equal person_count, Person.find(:all).length, "Number of Persons should be the same"
    assert_response :success
    assert_template 'update.rjs'
  end

  def test_destroy
  	person_count = Person.find(:all).length
    post :destroy, {:id => @first.id}
    assert_response :redirect
    assert_equal person_count - 1, Person.find(:all).length, "Number of Persons should be one less"
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_destroy_xhr
  	person_count = Person.find(:all).length
    xhr :post, :destroy, {:id => @first.id}
    assert_response :success
    assert_equal person_count - 1, Person.find(:all).length, "Number of Persons should be one less"
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
