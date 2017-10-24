require "spec_helper"

RSpec.describe CurrencyRate::BitfinexAdapter do
  before(:all) { @data, @normalized = data_for :bitfinex }

  before { @adapter = CurrencyRate::BitfinexAdapter.instance }

  describe "#normalize" do
    it "brings data to canonical form" do
      expect(@adapter.normalize(@data)).to eq(@normalized)
    end
  end
end
