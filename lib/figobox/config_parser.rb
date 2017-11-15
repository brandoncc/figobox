require 'yaml'

module Figobox
  class ConfigParser
    def initialize
      verify_config_exists
      @yaml = YAML.load(File.read("config/application.yml"))
    end

    def get_keys_for_environment(environment)
      verify_environment_exists(environment)

      global_values = get_global_key_value_sets
      env_values = get_environment_key_value_sets(environment)

      global_values.merge(env_values)
    end

    private

    attr_reader :yaml

    def verify_config_exists
      return if File.exists?("config/application.yml")
      abort "No config file could be found at config/application.yml. Please see https://github.com/laserlemon/figaro for more details."
    end

    def verify_environment_exists(environment)
      return unless get_environment_key_value_sets(environment) == {}
      abort "'#{environment}' environment doesn't exist in the configuration file."
    end

    def get_global_key_value_sets
      yaml.reject { |_, value| value.is_a?(Hash) }
    end

    def get_environment_key_value_sets(environment)
      found = yaml.find { |key, _| key.casecmp(environment).zero? }
      return found[1] if found
      {}
    end
  end
end
