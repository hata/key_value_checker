require "spec_helper"

describe KeyValueChecker::CheckerConfig do
  it "can load a map config" do
    config = KeyValueChecker::CheckerConfig.new
    config.load_map({rule_map: {foo: 'bar'}})
    expect(config.to_map[:foo]).to eq('bar')
  end

  it "can load some map configs" do
    config = KeyValueChecker::CheckerConfig.new
    config.load_map({rule_map: {foo: 'bar'}})
    config.load_map({rule_map: {bar: 'hoge'}})
    expect(config.to_map[:foo]).to eq('bar')
    expect(config.to_map[:bar]).to eq('hoge')
  end

  it "can override rule_map params" do
    config = KeyValueChecker::CheckerConfig.new
    config.load_map({rule_map: {foo: 'bar'}})
    config.load_map({rule_map: {bar: 'foo', foo: 'hoge'}})
    expect(config.to_map[:foo]).to eq('hoge')
    expect(config.to_map[:bar]).to eq('foo')
  end

  it "can return a default configs" do
    config = KeyValueChecker::CheckerConfig.new
    parser_config = config.to_config[:key_value_parser]
    expect(parser_config[:classname]).to eq('KeyValueChecker::QueryParameters')
    expect(parser_config[:options][:param_separator]).to eq(':')
  end
end
