# frozen_string_literal: true

module Rolebars
  # Main mixin for objects to add role authorization functionality.
  module Resource
    using Util::Refinements

    def self.included klass
      klass.include Common
      klass.extend ClassMethods

      klass.rolebars_attr_rules = {}
      klass.rolebars_role_rules = []
      klass.rolebars_role_blacklist = Set.new
      klass.rolebars_role_whitelist = Set.new
    end

    def agent_allowed? agent
      case self.class.rolebars_list_mode
      when :blacklist
        !self.class.rolebars_role_blacklist.member? agent.rolebars_role.to_sym
      when :whitelist
        self.class.rolebars_role_whitelist.member? agent.rolebars_role.to_sym
      else
        warn 'Neither a whitelist or blacklist are supplied'
        true
      end
    end

    module ClassMethods
      attr_accessor :rolebars_role_attr
      attr_accessor :rolebars_list_mode
      attr_accessor :rolebars_role_rules
      attr_accessor :rolebars_attr_rules
      attr_accessor :rolebars_role_blacklist
      attr_accessor :rolebars_role_whitelist

      def role_attr name
        rolebars_role_attr = name
      end

      def role_whitelist *roles
        @rolebars_list_mode = :whitelist
        @rolebars_role_whitelist = @rolebars_role_whitelist&.union roles
      end

      def role_blacklist *roles
        @rolebars_list_mode = :blacklist
        @rolebars_role_blacklist = @rolebars_role_blacklist&.union roles
      end
    end
  end
end
