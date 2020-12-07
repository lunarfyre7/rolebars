module Rolebars
  class Rule
    def initialize explosive: false, agent: nil
      @agent = agent
      @explosive = !!explosive
    end

    # Check if agent is allowed to write to resource.
    # Throws `AuthorizationError` in explosive mode (build by `can!`).
    def write? resource
      extract_rules resource
      return @write unless @explosive
      return true if @write

      raise AuthorizationError, "#{@agent || 'unknown agent'} is not permitted to write to #{resource || 'unknown resource'}"
    end

    # Check if agent is allowed to read to resource.
    # Throws `AuthorizationError` in explosive mode (build by `can!`).
    def read? resource
      extract_rules resource
      return @read unless @explosive
      return true if @read

      raise AuthorizationError, "#{@agent || 'unknown agent'} is not permitted to read to #{resource || 'unknown resource'}"
    end

    # Check if agent is allowed to read and write to resource.
    # Throws `AuthorizationError` in explosive mode (build by `can!`).
    def access? resource
      read?(resource) && write?(resource)
    end

    private

    def extract_rules resource
      @write ||= resource.rolebars_writable.intersect? @agent.rolebars_roles
      @read ||= resource.rolebars_readable.intersect? @agent.rolebars_roles
      nil
    end
  end
end
