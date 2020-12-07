# frozen_string_literal: true

module Rolebars
  # Main mixin for user objects to add role authorization functionality.
  module Agent
    using Util::Refinements

    def self.included klass
      klass.include Common
      klass.extend ClassMethods

      klass.rolebars_attr_rules = {}
    end

    # Gets the role stored in the property `@rolebars_role_attr`, which is set with
    # `role_attr` in the class definition
    def rolebars_role
      send self.class.rolebars_role_attr.to_sym
    end

    def allowed? thing
      thing.agent_allowed? self
    end

    def allowed_read? thing
      allowed? thing or return false
      rules = Util.get_attr_rules agent: self, resource: thing
      return true unless rules&.any?
    end

    def allowed_write? thing
      allowed? thing or return false
      rules = Util.get_attr_rules agent: self, resource: thing
      return true unless rules&.any?
    end

    module ClassMethods
      attr_reader :rolebars_role_attr
      attr_accessor :rolebars_attr_rules
      # Set the attribute to use as the role.
      def role_attr name
        @rolebars_role_attr = name
      end

    end
  end
end
