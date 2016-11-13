require 'yaml'
require 'key_value_checker/key_value_access'

module KeyValueChecker
  # Load config from a file and then return the value via
  # to_map method.
  class CheckerConfig
    include KeyValueAccess

    def initialize
      @rule_config = {
        config: {
          key_value_parser: {
            classname: 'KeyValueChecker::QueryParameters',
            options: { separator: ':' }
          },
          compare_set: {
            separator: ':'
          }
        }
      }
    end

    def load_file(file)
      load_map YAML.load_file(file)
    end

    def to_config
      @rule_config[:config]
    end

    def to_map
      @rule_config[:rule_map]
    end

    def load_map(map_config)
      map_config.each do |key, value|
        intern_key = key.intern
        if intern_key == :config
          merge_default_config(intern_key, value)
        elsif @rule_config[intern_key]
          merge_top_config(intern_key, value)
        else
          @rule_config[intern_key] = value
        end
      end
    end

    private

    def merge_default_config(config_key, new_value)
      return unless new_value
      new_value = replace_key_to_symbol(new_value)
      @rule_config[config_key] = merge_map_config(@rule_config[config_key], new_value)
    end

    def merge_top_config(intern_key, new_value)
      @rule_config[intern_key] = merge_map_config(@rule_config[intern_key], new_value)
    end

    def merge_map_config(old_map, new_map)
      return new_map unless old_map
      return old_map unless new_map
      old_map.merge(new_map)
    end

    def replace_key_to_symbol(kv_map)
      return kv_map unless kv_map.is_a?(Hash)

      new_map = {}
      # Note: each cannot be used because this code recall the same func
      # and it causes an error.
      for elem in kv_map.to_a do
        new_map[elem[0].intern] = replace_key_to_symbol(elem[1])
      end
      new_map
    end
  end
end
