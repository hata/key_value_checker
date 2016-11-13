require 'optparse'

module KeyValueChecker
  # Command line tool helper.
  # Command.run(ARGV)
  class Command
    def self.run(argv)
      new(argv).execute
    end

    def initialize(argv)
      @argv = argv
    end

    def parse_argv
      cmd_options = {}

      OptionParser.new do |opt|
        opt.on('-c CONFIG_FILE[,CONFIG_FILE,...]') { |v| cmd_options[:config_files] = v }
        opt.on('-q QUERY_PARAMS_FILE') { |v| cmd_options[:params_file] = v }
        opt.parse!(@argv)
      end

      cmd_options
    end

    def execute
      cmd_options = parse_argv
      config = load_config_files(cmd_options[:config_files])

      params = KeyValueChecker::QueryParameters.new
      params.load_file(cmd_options[:params_file])
      result = KeyValueChecker::CheckerResult.new

      checker = KeyValueChecker::Checker.new
      checker.validate(config, params, result).print_result(cmd_options)
    end

    def load_config_files(config_files)
      config = KeyValueChecker::CheckerConfig.new
      config_files.split(',').each do |file|
        config.load_file(file)
      end
      config
    end
  end
end
