require "spec_helper"

RSpec.describe CurrencyRate::BTCChinaAdapter do
  before(:all) { @data, @normalized = data_for :btc_china }

  before { @adapter = CurrencyRate::BTCChinaAdapter.instance }

  describe "#normalize" do
    it "brings data to canonical form" do
      expect(@adapter.normalize(@data)).to eq(@normalized)
    end
  end
end
