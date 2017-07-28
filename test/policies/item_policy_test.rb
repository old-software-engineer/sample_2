require 'test_helper'

class ItemPolicyTest < ActiveSupport::TestCase
  def setup
    @user = users :user_1
    @item = @user.items.first
  end

  def teardown
    @user = nil
    @item = nil
  end

  test "scope to items that belongs to an user" do
    assert_policy_scope @user.items, @user, Item
  end

  test "show if item owner" do
    assert_policy @user, @item, :show?
  end

  test "cannot show if not item owner" do
    user = users :user_2
    assert_not_policy user, @item, :show?
  end
end
