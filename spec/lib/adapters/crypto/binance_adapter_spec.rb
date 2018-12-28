require "spec_helper"

RSpec.describe CurrencyRate::BinanceAdapter do
  before(:all) { @data, @normalized = data_for :binance }

  before { @adapter = CurrencyRate::BinanceAdapter.instance }

  describe "#normalize" do
    it "brings data to canonical form" do
      expect(@adapter.normalize(@data)).to eq(@normalized)
    end
  end
end
