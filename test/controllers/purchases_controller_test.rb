require 'test_helper'

class PurchasesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @controller = PurchasesController.new
  end
  test "right income" do
    purchase = {item_price:3, purchase_count:20}
    assert_equal 60, @controller.send(:income, purchase), "Did not post"
  end
  
  test "should read file" do
    example = fixture_file_upload("files/reduced.tab")
    parsed = @controller.send(:receive_file_and_parse,example)
    assert_equal [
      {
        purchaser_name:"João Silva",
        item_description:"R$10 off R$20 of food",
        item_price: 10.0,
        purchase_count: 2,
        merchant_address: "987 Fake St",
        merchant_name:	"Bob's Pizza"
      }
      ],parsed, "Failed in parsing text"
    
  end
  
  test "should not read empty file" do
    example = fixture_file_upload("files/empty.tab")
    parsed = @controller.send(:receive_file_and_parse,example)
    assert_equal [], parsed, "Not empty"
  end

  test "should get get_all_time" do
    get purchases_get_all_time_url
    assert_response :success
  end
  
  
  
  test "should parse correctly" do
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
      ],@controller.send(:parse_text, text), "Failed in parsing text"
  end
  
  test "should not parse random text" do
    text = "A random text"
    exception = assert_raise(Exception) {@controller.send(:parse_text, text)}
    assert_equal "Missing fields", exception.message
  end

end
