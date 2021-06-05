require 'test_helper'

class PurchasesControllerTest < ActionDispatch::IntegrationTest
  test "should post post_file" do
    example = fixture_file_upload("files/example_input.tab")
    post purchases_post_file_url, params:{purchase: {file: example}}
    assert_response :success
  end
  
  test "should not post empty post_file" do
    example = fixture_file_upload("files/empty.tab")
    post purchases_post_file_url, params:{purchase: {file: example}}
    assert_response :bad_request
  end

  test "should get get_all_time" do
    get purchases_get_all_time_url
    assert_response :success
  end
  
  
  
  test "should parse correctly" do
    controller = PurchasesController.new
    text = <<-OT 
purchaser name	item description	item price	purchase count	merchant address	merchant name
João Silva	R$10 off R$20 of food	10.0	2	987 Fake St	Bob's Pizza
    OT
    assert_equal [
      {
        purchaser_name:"João Silva",
        item_description:"R$10 off R$20 of food",
        item_price: 10.0,
        purchase_count: 2,
        merchant_address: "987 Fake St",
        merchant_name:	"Bob's Pizza"
      }
      ],controller.parse_text(text), "Failed in parsing text"
  end
  
  test "should not parse random text" do
    controller = PurchasesController.new
    text = "A random text"
    exception = assert_raise(Exception) {controller.parse_text(text)}
    assert_equal "Missing fields", exception.message
  end

end
