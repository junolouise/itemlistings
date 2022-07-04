require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "user needs a 'name' to be valid" do
    user = users(:one)
    user.name = nil
    assert_not user.valid?
  end

  test "user needs a 'display_picture' to be valid" do
    user = users(:one)
    user.display_picture = nil
    assert_not user.valid?
  end
end
