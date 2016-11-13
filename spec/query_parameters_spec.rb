require "spec_helper"

describe KeyValueChecker::QueryParameters do
  it "can load a parameter file" do
    path_src = 'spec/fixtures/params.txt'
    parser = KeyValueChecker::QueryParameters.new
    parser.load_file(path_src)
    params = parser.to_map
    expect(params['foo']).to eq('bar')
    expect(params['hoge']).to eq('fuga')
  end
end
