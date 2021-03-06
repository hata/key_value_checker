require 'key_value_checker/key_value_access'

module KeyValueChecker
  # Create Key Value pairs from query parameters file.
  # File is like browser developer tool DefaultParser.
  # e.g.
  # key1:value1
  # key2:value2
  # And these values are load and return by to_map.
  class DefaultParser
    include KeyValueParser

    def initialize
      @options = { separator: ':' }
    end

    def init(options)
      @options = @options.merge(options)
    end

    def load_file(file)
      @key_value_map = {}
      File.foreach(file) do |line|
        line = line.strip
        next if line.length == 0

        key, value = line.split(@options[:separator], 2)
        @key_value_map[key] = value
      end
    end

    def to_map
      @key_value_map
    end
  end
end
