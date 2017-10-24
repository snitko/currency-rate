require "spec_helper"

RSpec.describe CurrencyRate::YahooAdapter do
  before(:all) { @data, @normalized = data_for :yahoo }

  before { @adapter = CurrencyRate::YahooAdapter.instance }

  describe "#normalize" do
    it "brings data to canonical form" do
      expect(@adapter.normalize(@data)).to eq(@normalized)
    end
  end
end
