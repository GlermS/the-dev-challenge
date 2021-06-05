require 'test_helper'

class UserFlowsTest < ActionDispatch::IntegrationTest
  test "user uploading file" do
    https!
    get root_url
    assert_response :success
 
    example = fixture_file_upload("files/example_input.tab")
    post purchases_post_file_url, params:{purchase: {file: example}}
    assert_response :success
    assert_equal JSON.parse(response.body)["file_total_gross_income"], 95.0
  end
end
