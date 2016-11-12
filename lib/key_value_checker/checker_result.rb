 module KeyValueChecker
  class CheckerResult
    def initialize(result)
      super()
      @result = result
    end

    def print_result
          # Dump result
      print "---- RESULT ----\n"
      print "config: #{cmd_options[:config_file]}\n"
      print "config: #{cmd_options[:params_file]}\n"
      print "\n"

      @result.each do |entry|
        if !entry
          print "ERROR: entry is nil.\n"
        elsif entry[:error]
          print "ERROR: #{entry[:error]}\n"
        elsif entry[:success]
          print "SUC: #{entry[:success]}\n"
        else
          print "ERROR: Unknown entry found.\n"
        end
      end

      print "\n"
    end
  end
end
