require "test_helper"

class ItemTest < ActiveSupport::TestCase
  test "item needs a 'title' to be valid" do
    item = items(:one)
    item.title = nil
    assert_not item.valid?
  end

  test "item needs a 'thumbnail_url' to be valid" do
    item = items(:one)
    item.thumbnail_url = nil
    assert_not item.valid?
  end

  test "item needs a 'distance' to be valid" do
    item = items(:one)
    item.distance = nil
    assert_not item.valid?
  end

  test "item 'likes' has 0 as default value" do
    item = Item.new
    assert_equal 0, item.likes
  end
end
