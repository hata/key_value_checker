require 'optparse'

module KeyValueChecker
  # Your code goes here...

  class Command
    def self.run(argv)
      new(argv).execute
    end

    def initialize(argv)
      @argv = argv
    end

    def parse_argv
      # Commands
      cmd_options = {}

      OptionParser.new do |opt|
        opt.on('-c CONFIG_FILE') {|v| cmd_options[:config_file] = v}
        opt.on('-q QUERY_PARAMS_FILE') {|v| cmd_options[:params_file] = v}
        opt.parse!(@argv)
      end

      cmd_options
    end

    def execute
      cmd_options = parse_argv
      config = KeyValueChecker::CheckerConfig.new
      config.load_file(cmd_options[:config_file])

      params = KeyValueChecker::QueryParameters.new
      params.load_file(cmd_options[:params_file])

      checker = KeyValueChecker::Checker.new
      checker.validate(config, params).print_result(cmd_options)
    end
  end
end
