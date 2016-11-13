require "spec_helper"

describe KeyValueChecker::CheckerResult do
  it "have add method to add some results" do
    result = KeyValueChecker::CheckerResult.new
    result.add([{success: 'SUC'}])
    expect(result.results[0]).to eq({success: 'SUC'})
  end

  it "can handle some results" do
    result = KeyValueChecker::CheckerResult.new
    result.add([{success: 'SUC'}])
    result.add([{success: 'SUC2'}, {error: 'ERR'}])
    expect(result.results.length).to eq(3)
  end
end
