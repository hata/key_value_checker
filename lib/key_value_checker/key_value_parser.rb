require 'key_value_checker/key_value_access'

module KeyValueChecker
  # Definition for Parser interface.
  module KeyValueParser
    include KeyValueAccess

    def init(options = {})
    end

    def load_file(file)
    end
  end
end
