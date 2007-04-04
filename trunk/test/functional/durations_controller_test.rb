require File.dirname(__FILE__) + '/../test_helper'
require 'durations_controller'

# Re-raise errors caught by the controller.
class DurationsController; def rescue_action(e) raise e end; end

class DurationsControllerTest < Test::Unit::TestCase
  fixtures :durations

	NEW_DURATION = {}	# e.g. {:name => 'Test Duration', :description => 'Dummy'}
	REDIRECT_TO_MAIN = {:action => 'list'} # put hash or string redirection that you normally expect

	def setup
		@controller = DurationsController.new
		@request    = ActionController::TestRequest.new
		@response   = ActionController::TestResponse.new
		# Retrieve fixtures via their name
		# @first = durations(:first)
		@first = Duration.find_first
	end

  def test_component
    get :component
    assert_response :success
    assert_template 'durations/component'
    durations = check_attrs(%w(durations))
    assert_equal Duration.find(:all).length, durations.length, "Incorrect number of durations shown"
  end

  def test_component_update
    get :component_update
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_component_update_xhr
    xhr :get, :component_update
    assert_response :success
    assert_template 'durations/component'
    durations = check_attrs(%w(durations))
    assert_equal Duration.find(:all).length, durations.length, "Incorrect number of durations shown"
  end

  def test_create
  	duration_count = Duration.find(:all).length
    post :create, {:duration => NEW_DURATION}
    duration, successful = check_attrs(%w(duration successful))
    assert successful, "Should be successful"
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
    assert_equal duration_count + 1, Duration.find(:all).length, "Expected an additional Duration"
  end

  def test_create_xhr
  	duration_count = Duration.find(:all).length
    xhr :post, :create, {:duration => NEW_DURATION}
    duration, successful = check_attrs(%w(duration successful))
    assert successful, "Should be successful"
    assert_response :success
    assert_template 'create.rjs'
    assert_equal duration_count + 1, Duration.find(:all).length, "Expected an additional Duration"
  end

  def test_update
  	duration_count = Duration.find(:all).length
    post :update, {:id => @first.id, :duration => @first.attributes.merge(NEW_DURATION)}
    duration, successful = check_attrs(%w(duration successful))
    assert successful, "Should be successful"
    duration.reload
   	NEW_DURATION.each do |attr_name|
      assert_equal NEW_DURATION[attr_name], duration.attributes[attr_name], "@duration.#{attr_name.to_s} incorrect"
    end
    assert_equal duration_count, Duration.find(:all).length, "Number of Durations should be the same"
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_update_xhr
  	duration_count = Duration.find(:all).length
    xhr :post, :update, {:id => @first.id, :duration => @first.attributes.merge(NEW_DURATION)}
    duration, successful = check_attrs(%w(duration successful))
    assert successful, "Should be successful"
    duration.reload
   	NEW_DURATION.each do |attr_name|
      assert_equal NEW_DURATION[attr_name], duration.attributes[attr_name], "@duration.#{attr_name.to_s} incorrect"
    end
    assert_equal duration_count, Duration.find(:all).length, "Number of Durations should be the same"
    assert_response :success
    assert_template 'update.rjs'
  end

  def test_destroy
  	duration_count = Duration.find(:all).length
    post :destroy, {:id => @first.id}
    assert_response :redirect
    assert_equal duration_count - 1, Duration.find(:all).length, "Number of Durations should be one less"
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_destroy_xhr
  	duration_count = Duration.find(:all).length
    xhr :post, :destroy, {:id => @first.id}
    assert_response :success
    assert_equal duration_count - 1, Duration.find(:all).length, "Number of Durations should be one less"
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
