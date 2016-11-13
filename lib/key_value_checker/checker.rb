require 'key_value_checker/key_value_access'

module KeyValueChecker
  # Check key and value based on config and parameters.
  # After that, checked status are added to result instance.
  class Checker
    def validate(config, params, result)
      init_config(config)
      config_map = merge_key_map(config, params)
      params_map = params.to_map

      config_map.each do |key, rule|
        result.add validate_param(key, rule, params_map[key])
      end

      result
    end

    private

    def init_config(config)
      if config.to_config[:compare_set] && config.to_config[:compare_set][:separator]
        @compare_set_separator = config.to_config[:compare_set][:separator]
      else
        @compare_set_separator = ','
      end
    end

    def merge_key_map(config, params)
      config_map = config.to_map
      params_map = params.to_map

      # If there is no mapping, then nil is set. Otherwise rule is set to value.
      config_map.merge(params_map) do |_key, oldval, _newval|
        oldval
      end
    end

    def validate_param(key, rule, param_value)
      return [{ error: "No rule for '#{key}' found." }] unless rule && rule['pattern']
      return [{ error: "No parameter,'#{key}', found." }] if rule['required'] && !param_value
      return [{ success: "Skip '#{key}' because no value found." }] unless rule['required'] || param_value

      result_list = []
      rule['pattern'].each do |pattern_definitions|
        pattern_definitions.each do |rule_key, rule_value|
          result_list << validate_dispatcher(key, rule_key, rule_value, param_value)
        end
      end
      result_list
    end

    def validate_dispatcher(key, rule_key, rule_value, param_value)
      case rule_key
      when 'equal'
        return validate_pattern_equal(key, rule_value, param_value)
      when 'regex'
        return validate_pattern_regex(key, rule_value, param_value)
      when 'compare_set'
        return validate_pattern_compare_set(key, rule_value, param_value)
      else
        return { error: "No pattern rule for '#{key}' #{rule[:pattern]} found. Set equal or regex." }
      end
    end

    def validate_pattern_equal(key, rule_value, param_value)
      if "#{rule_value}" == "#{param_value}"
        { success: "Equal match key='#{key}'. #{rule_value}" }
      else
        { error: "Not Equal key='#{key}'. #{rule_value} != #{param_value}" }
      end
    end

    def validate_pattern_regex(key, rule_value, param_value)
      if Regexp.new(rule_value) =~ param_value
        { success: "Regexp(#{rule_value}) match. key='#{key}' #{param_value}" }
      else
        { error: "Regexp(#{rule_value}) do not match. key='#{key}' #{param_value}" }
      end
    end

    def validate_pattern_compare_set(key, rule_value, param_value)
      rule_set = rule_value.split(@compare_set_separator)
      param_set = param_value.split(@compare_set_separator)

      rule_param_set = rule_set - param_set
      param_rule_set = param_set - rule_set

      if rule_param_set.size == 0 && param_rule_set.size == 0
        { success: "Equal match key='#{key}'. #{rule_value}" }
      else
        { error: "Not Equal set key='#{key}'. rule_values - param_values = #{rule_param_set}, param_values - rule_values: #{param_rule_set}" }
      end
    end
  end
end
