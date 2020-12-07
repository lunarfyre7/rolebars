module Rolebars
  class Rule
    def initialize explosive: false, agent: nil
      @agent = agent
      @explosive = !!explosive
    end

    def write? resource
      extract_rules resource
      return @write unless @explosive
      return true if @write

      raise AuthorizationError, "#{@agent || 'unknown agent'} is not permitted to write to #{resource || 'unknown resource'}"
    end

    def read? resource
      extract_rules resource
      return @read unless @explosive
      return true if @read

      raise AuthorizationError, "#{@agent || 'unknown agent'} is not permitted to read to #{resource || 'unknown resource'}"
    end

    def access? resource
      read?(resource) && write?(resource)
    end

    private

    def extract_rules resource
      @write ||= resource.rolebars_writable.include? @agent.rolebars_role
      @read ||= resource.rolebars_readable.include? @agent.rolebars_role
    end
  end
end
