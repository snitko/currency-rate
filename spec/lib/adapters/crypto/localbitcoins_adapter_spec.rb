require "spec_helper"

RSpec.describe CurrencyRate::LocalbitcoinsAdapter do
  before(:all) { @data, @normalized = data_for :localbitcoins }

  before { @adapter = CurrencyRate::LocalbitcoinsAdapter.instance }

  describe "#normalize" do
    it "brings data to canonical form" do
      expect(@adapter.normalize(@data)).to eq(@normalized)
    end
  end
end
