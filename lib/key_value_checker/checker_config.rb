require 'yaml'
require 'key_value_checker/key_value_access'

module KeyValueChecker
  # Load config from a file and then return the value via
  # to_map method.
  class CheckerConfig
    include KeyValueAccess

    def load_file(file)
      @rule_config = YAML.load_file(file)
    end

    def to_map
      @rule_config
    end
  end
end
