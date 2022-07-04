require "test_helper"

class FetchItemsTest < ActionDispatch::IntegrationTest
 test "correct item values are set when browsing to /items" do
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

  test "correct user values are set when browsing to /items" do
    VCR.use_cassette("items_list") do
      get(items_url)
      assert_equal 11, User.count
      last_user = User.last
      last_user_display_picture = "https://cdn.olioex.com/uploads/avatar/file/VwTGY2skijLppfBIrygvwA/small_image.jpg"
      assert_equal last_user_display_picture, last_user.display_picture
      assert_equal "Briony", last_user.name
      assert_equal 10, last_user.rating
      assert_equal 701990, last_user.external_id
      assert_not last_user.items.empty?
    end
  end

  test "valid items are displayed despite invalid items" do
    VCR.use_cassette("items_list_invalid") do
      get(items_url)
      assert_equal 10, User.count
      assert_equal 26, Item.count
    end
  end

  test "item is displayed without views" do
    item = items(:one)
    item.update(views: nil)
    VCR.use_cassette("items_list") do
      get(items_url)
      assert_select "h2", item.title
    end
  end
end
