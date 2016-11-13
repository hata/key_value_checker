require 'yaml'
require 'key_value_checker/key_value_access'

module KeyValueChecker
  # Load config from a file and then return the value via
  # to_map method.
  class CheckerConfig
    include KeyValueAccess

    def initialize
      @rule_config = { config: { param_separator: ':' } }
    end

    def load_file(file)
      load_map YAML.load_file(file)
    end

    def load_map(map_config)
      map_config.each do |key, value|
        intern_key = key.intern
        if @rule_config[intern_key]
          merge_top_config(intern_key, value)
        else
          @rule_config[intern_key] = value
        end
      end
    end

    def merge_top_config(intern_key, new_value)
      @rule_config[intern_key] = merge_map_config(@rule_config[intern_key], new_value)
    end

    def merge_map_config(old_map, new_map)
      return new_map unless old_map
      old_map.merge(new_map)
    end

    def to_config
      @rule_config[:config]
    end

    def to_map
      @rule_config[:rule_map]
    end
  end
end
