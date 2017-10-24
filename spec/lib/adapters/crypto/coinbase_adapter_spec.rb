require "spec_helper"

RSpec.describe CurrencyRate::CoinbaseAdapter do
  before(:all) { @data, @normalized = data_for :coinbase }

  before { @adapter = CurrencyRate::CoinbaseAdapter.instance }

  describe "#normalize" do
    it "brings data to canonical form" do
      expect(@adapter.normalize(@data)).to eq(@normalized)
    end
  end
end
