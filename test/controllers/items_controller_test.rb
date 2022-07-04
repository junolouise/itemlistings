require "test_helper"

class ItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @item = items(:one)
  end

  test "should get index" do
    VCR.use_cassette("items_list") do
      get items_url
      assert_response :success
    end
  end

  test "should get new" do
    get new_item_url
    assert_response :success
  end

  test "should create item" do
    assert_difference('Item.count') do
      user = users(:one)
      post items_url, params: { item: { distance: @item.distance, likes: @item.likes, thumbnail_url: @item.thumbnail_url, title: @item.title, views: @item.views, external_id: @item.external_id, user_id: user.id} }
    end

    assert_redirected_to item_url(Item.last)
  end

  test "should show item" do
    get item_url(@item)
    assert_response :success
  end

  test "should get edit" do
    get edit_item_url(@item)
    assert_response :success
  end

  test "should update item" do
    patch item_url(@item), params: { item: { distance: @item.distance, likes: @item.likes, thumbnail_url: @item.thumbnail_url, title: @item.title, views: @item.views } }
    assert_redirected_to item_url(@item)
  end

  test "should destroy item" do
    assert_difference('Item.count', -1) do
      delete item_url(@item)
    end

    assert_redirected_to items_url
  end
end
