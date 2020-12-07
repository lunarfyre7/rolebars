# frozen_string_literal: true

module Rolebars
  # Main mixin for user objects to add role authorization functionality.
  module Agent
    def self.included klass
      # klass.include Common
      klass.extend ClassMethods

      klass.rolebars_attr_rules = {}
    end

    # Gets the role stored in the property `@rolebars_role_attr`, which is set with
    # `role_attr` in the class definition. If you are storing the roles in a string,
    # point `@rolebars_role_attr` to the name of a decoding method as this needs
    # to be an array or single value.
    def rolebars_roles
      # @rolebars_roles ||= Array(send(self.class.rolebars_role_attr)).map(&:to_sym).to_set # memo
      Array(send(self.class.rolebars_role_attr)).map(&:to_sym).to_set
    end

    # returns a rule object.
    # usage: `xyz.can.access?`
    # @return [Rule]
    def can
      Rule.new(explosive: false, agent: self)
    end

    # returns an explosive rule object, which will raise an exception
    # on denied permissions.
    # usage: `xyz.can!.access?`
    # @return [Rule]
    def can!
      Rule.new(explosive: true, agent: self)
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
