require 'color_echo'

module KeyValueChecker
  # Dump checker result.
  class CheckerResult
    attr_reader :results

    def initialize
      super
      @results = []
    end

    def add(key_results)
      @results.concat key_results
    end

    def print_result(cmd_options)
      result_message = result_to_message_list.join("\n")

      CE.pickup([/^ERR/], :red, nil, nil).pickup([/^SUC/], :green, nil, nil)
      print "---- RESULT ----\n"
      print "config_files: #{cmd_options[:config_files]}\n"
      print "key_value_file: #{cmd_options[:key_value_file]}\n"
      print "\n#{result_message}\n"
    end

    private

    def result_to_message_list
      @results.map do |entry|
        if entry[:error]
          "ERR: #{entry[:error]}"
        elsif entry[:success]
          "SUC: #{entry[:success]}"
        else
          'ERR: Unknown entry found.'
        end
      end
    end
  end
end
