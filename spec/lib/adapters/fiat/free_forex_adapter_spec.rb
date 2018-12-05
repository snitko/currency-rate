require "spec_helper"

RSpec.describe CurrencyRate::FreeForexAdapter do
  before(:all) { @data, @normalized = data_for :free_forex }

  before { @adapter = CurrencyRate::FreeForexAdapter.instance }

  describe "#normalize" do
    it "brings data to canonical form" do
      expect(@adapter.normalize(@data)).to eq(@normalized)
    end
  end
end
