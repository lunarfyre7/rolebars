# frozen_string_literal: true

module Rolebars
  # Main mixin for objects to add role authorization functionality.
  module Resource
    using Util::Refinements

    def self.included base
      base.include Common
      base.extend ClassMethods

      base.rolebars_readable = Set.new
      base.rolebars_writable = Set.new
    end

    def rolebars_readable
      self.class.rolebars_readable
    end

    def rolebars_readable= value
      self.class.rolebars_readable = value
    end

    def rolebars_writable
      self.class.rolebars_writable
    end

    def rolebars_writable= value
      self.class.rolebars_writable = value
    end

    # Class level methods to mix in
    module ClassMethods
      attr_accessor :rolebars_readable
      attr_accessor :rolebars_writable

      # Add role permissions to the internal read/write whitelists.
      # Usage: `role_permissions admin: :rw, user: :r`
      def role_permissions **rules
        rules.each do |key, value|
          @rolebars_readable << key if value == true || value.to_s.match?(/r/)
          @rolebars_writable << key if value == true || value.to_s.match?(/w/)
        end
      end

      # Shorthand for `role_permissions`, gives each passed role read-write access.
      # Usage: `role_whitelist :cats, :dogs, :admin`
      def role_whitelist *roles
        roles.each do |r|
          @rolebars_readable << r
          @rolebars_writable << r
        end
      end
    end
  end
end
