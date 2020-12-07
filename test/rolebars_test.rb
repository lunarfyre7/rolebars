require "test_helper"

class RolebarsTest < Minitest::Test
  class self::BaseResource
    attr_accessor :prop_a
    attr_accessor :prop_b
  end
  class self::ResourceA < BaseResource
    include Rolebars::Resource
    role_permissions role_a: :rw, role_b: false
  end
  class self::ResourceB < BaseResource
    include Rolebars::Resource
    role_permissions role_b: true, role_a: false
  end
  class self::ResourceWList < BaseResource
    include Rolebars::Resource
    role_whitelist :allowed, :cat, :admin
  end
  class self::User
    attr_accessor :role

    include Rolebars::Agent
    role_attr :role
  end

  def test_role_groups
    user = User.new
    resource = ResourceA.new
    user.role = :role_a
    user_b = User.new
    user_b.role = :role_b
    assert user.can.access? resource
    assert user.can.read? resource
    assert user.can.write? resource
    assert user.can!.access? resource
    assert user.can!.read? resource
    assert user.can!.write? resource
    refute user_b.can.access? resource
    refute user_b.can.read? resource
    refute user_b.can.write? resource

    assert_raises(Rolebars::AuthorizationError) { user_b.can!.access? resource }
    assert_raises(Rolebars::AuthorizationError) { user_b.can!.read? resource }
    assert_raises(Rolebars::AuthorizationError) { user_b.can!.write? resource }
  end

  def test_whitelist_shorthand
    user = User.new
    user.role = :allowed
    resource = ResourceWList.new
    assert user.can.access? resource
    user.role = :cat
    assert user.can.access? resource
    user.role = :bat
    refute user.can.access? resource
  end

  def test_multiple_roles
    user = User.new
    user.role = [:admin, :baka]
    resource = ResourceWList.new

    assert user.can.access? resource

    user.role = [:baka, :neko]
    refute user.can.access? resource
    assert_raises(Rolebars::AuthorizationError) { user.can!.access? resource }
  end
end
