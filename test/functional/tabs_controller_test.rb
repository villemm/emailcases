require File.dirname(__FILE__) + '/../test_helper'
require 'tabs_controller'

# Re-raise errors caught by the controller.
class TabsController; def rescue_action(e) raise e end; end

class TabsControllerTest < Test::Unit::TestCase
  def setup
    @controller = TabsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
