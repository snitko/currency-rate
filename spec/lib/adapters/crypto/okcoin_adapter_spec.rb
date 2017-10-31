require "spec_helper"

RSpec.describe CurrencyRate::OkcoinAdapter do
  before(:all) { @data, @normalized = data_for :okcoin }

  before { @adapter = CurrencyRate::OkcoinAdapter.instance }

  describe "#normalize" do
    it "brings data to canonical form" do
      expect(@adapter.normalize(@data)).to eq(@normalized)
    end
  end
end
