require "spec_helper"

RSpec.describe CurrencyRate::KrakenAdapter do
  before(:all) { @data, @normalized = data_for :kraken }

  before { @adapter = CurrencyRate::KrakenAdapter.instance }

  describe "#normalize" do
    it "brings data to canonical form" do
      expect(@adapter.normalize(@data)).to eq(@normalized)
    end
  end
end
