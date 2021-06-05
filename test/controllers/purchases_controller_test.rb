require 'test_helper'

class PurchasesControllerTest < ActionDispatch::IntegrationTest
  test "should get post_file" do
    get purchases_post_file_url
    assert_response :success
  end

  test "should get get_all_time" do
    get purchases_get_all_time_url
    assert_response :success
  end

end
