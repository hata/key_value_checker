require 'yaml'
require 'key_value_checker/key_value_access'

module KeyValueChecker
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
