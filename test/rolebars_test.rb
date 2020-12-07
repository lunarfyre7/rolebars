require "test_helper"

class RolebarsTest < Minitest::Test
  class self::BaseResource
    attr_accessor :prop_a
    attr_accessor :prop_b
  end
  class self::ResourceA < BaseResource
    include Rolebars::Resource
    role_whitelist :allowed, :yes
  end
  class self::ResourceB < BaseResource
    include Rolebars::Resource
    role_blacklist :disallowed, :no
  end
  class self::ResourceC < BaseResource
    include Rolebars::Resource
    # role_rules 
  end
  class self::User
    attr_accessor :role

    include Rolebars::Agent
    role_attr :role
  end

  def test_role_whitelist
    user = User.new
    object = ResourceA.new
    user.role = :allowed
    assert user.allowed? object
    assert user.allowed_read? object
    assert user.allowed_write? object

    user.role = :yes
    assert user.allowed? object
    assert user.allowed_read? object
    assert user.allowed_write? object

    user.role = :meow

    refute user.allowed? object
    refute user.allowed_read? object
    refute user.allowed_write? object
  end

  def test_role_blacklist
    user = User.new
    user.role = :allowed
    object = ResourceB.new
    assert user.allowed? object
    assert user.allowed_read? object
    assert user.allowed_write? object

    user.role = :disallowed

    refute user.allowed? object
    refute user.allowed_read? object
    refute user.allowed_write? object

    user.role = :no

    refute user.allowed? object
    refute user.allowed_read? object
    refute user.allowed_write? object
  end
end
