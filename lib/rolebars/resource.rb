# frozen_string_literal: true

module Rolebars
  # Main mixin for objects to add role authorization functionality.
  module Resource
    using Util::Refinements

    def self.included base
      base.include Common
      base.extend ClassMethods

      # base.rolebars_attr_rules = {}
      # base.rolebars_role_rules = []
      # base.rolebars_role_blacklist = Set.new
      # base.rolebars_role_whitelist = Set.new
      base.rolebars_readable = Set.new
      base.rolebars_writable = Set.new
    end

    def rolebars_readable
      self.class.rolebars_readable
    end

    def rolebars_readable=v
      self.class.rolebars_readable=v
    end

    def rolebars_writable
      self.class.rolebars_writable
    end

    def rolebars_writable=v
      self.class.rolebars_writable=v
    end

    module ClassMethods
      attr_accessor :rolebars_readable
      attr_accessor :rolebars_writable

      def role_permissions **rules
        rules.each do |key, value|
          @rolebars_readable << key if value == true || value.to_s.match?(/r/)
          @rolebars_writable << key if value == true || value.to_s.match?(/w/)
        end
      end

      def role_whitelist *roles
        roles.each do |r|
          @rolebars_readable << r
          @rolebars_writable << r
        end
      end
    end
  end
end
