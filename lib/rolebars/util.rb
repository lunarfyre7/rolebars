# frozen_string_literal: true

module Rolebars
  module Util
    module Refinements
      refine String do
        # Convert to CamelCase
        def camelize
          split('_').collect(&:capitalize).join
        end

        # Get object from CamelCase string
        def constintize
          Object.get_constant(self)
        end
      end
    end

    class << self
      # Get the rules of an agent and a resource
      def get_attr_rules agent:, resource:
        agent_rules = agent.class.rolebars_attr_rules
        resource_rules = resource.class.rolebars_attr_rules
        agent_rules.merge resource_rules
      end
    end
  end
end
