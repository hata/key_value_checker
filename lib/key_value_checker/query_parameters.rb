require 'key_value_checker/key_value_access'

module KeyValueChecker
  class QueryParameters
    include KeyValueAccess

    def load_file(file)
      @key_value_map = {}
      File.foreach(file) do |line|
        line = line.strip
        next if line.length == 0

        key, value = line.split(":", 2)
        @key_value_map[key] = value
      end
    end

    def to_map
      @key_value_map
    end
  end
end
