module KeyValueChecker
  # Dump checker result.
  class CheckerResult
    def initialize
      super
      @result = []
    end

    def add(key_results)
      @result.concat key_results
    end

    def print_result(cmd_options)
      result_message = result_to_message_list.join("\n")

      print "---- RESULT ----\n"
      print "config_file: #{cmd_options[:config_files]}\n"
      print "key_value_file: #{cmd_options[:key_value_file]}\n"
      print "\n#{result_message}\n"
    end

    private

    def result_to_message_list
      @result.map do |entry|
        if entry[:error]
          "ERROR: #{entry[:error]}"
        elsif entry[:success]
          "SUC: #{entry[:success]}"
        else
          'ERROR: Unknown entry found.'
        end
      end
    end
  end
end
