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
        opt.on('-f KEY_VALUE_FILE') { |v| cmd_options[:key_value_file] = v }
        opt.parse!(@argv)
      end

      cmd_options
    end

    def execute
      cmd_options = parse_argv
      config = load_config_files(cmd_options[:config_files])
      param_parser = load_param_parser(config.to_config[:key_value_parser])
      param_parser.load_file(cmd_options[:key_value_file])

      result = KeyValueChecker::CheckerResult.new
      checker = KeyValueChecker::Checker.new
      checker.validate(config, param_parser, result)
      result.print_result(cmd_options)
    end

    def load_config_files(config_files)
      config = KeyValueChecker::CheckerConfig.new
      config_files.split(',').each do |file|
        config.load_file(file)
      end
      config
    end

    def load_param_parser(param_parser_config)
      classname = param_parser_config[:classname]

      mod_or_clazz = Module
      classname.split('::').each do |name|
        mod_or_clazz = mod_or_clazz.const_get(name)
      end

      parser_instance = mod_or_clazz.new
      parser_instance.init(param_parser_config[:options])
      parser_instance
    end
  end
end
