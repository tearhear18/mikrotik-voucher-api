require "test_helper"

class RoutersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get routers_index_url
    assert_response :success
  end
end
