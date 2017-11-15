module Figobox
  class CommandCompiler
    def initialize(target_alias, variables)
      @alias = target_alias
      @variables = variables || {}
    end

    def add
      add_command || ""
    end

    private

    def add_command
      return unless @variables.any?

      command = "nanobox evar add #{@alias}"
      @variables.each { |k, v| command << " #{k}=#{v}" }

      command
    end
  end
end
