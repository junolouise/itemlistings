require "test_helper"

class FetchItemsTest < ActionDispatch::IntegrationTest
 test "correct values are set when browsing to /items" do
    VCR.use_cassette("items_list") do
      get(items_url)
      assert_equal 27, Item.count
      last_item = Item.last
      last_item_thumbnail_url = "https://cdn.olioex.com/uploads/photo/file/rBBj7uIfgVrR6tUxoxJOXA/medium_image.jpg"
      assert_equal "Brown thins", last_item.title
      assert_equal last_item_thumbnail_url, last_item.thumbnail_url
      assert_equal 11.0, last_item.distance
      assert_equal 4, last_item.views
      assert_equal nil, last_item.likes
      assert_equal 4259900, last_item.external_id
      assert_not last_item.user.nil?
    end
  end
end
