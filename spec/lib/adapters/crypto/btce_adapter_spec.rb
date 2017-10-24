require "spec_helper"

RSpec.describe CurrencyRate::BTCEAdapter do
  before(:all) { @data, @normalized = data_for :btce }

  before { @adapter = CurrencyRate::BTCEAdapter.instance }

  describe "#normalize" do
    it "brings data to canonical form" do
      expect(@adapter.normalize(@data)).to eq(@normalized)
    end
  end
end
