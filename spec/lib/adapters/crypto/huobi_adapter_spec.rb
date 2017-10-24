require "spec_helper"

RSpec.describe CurrencyRate::HuobiAdapter do
  before(:all) { @data, @normalized = data_for :huobi }

  before { @adapter = CurrencyRate::HuobiAdapter.instance }

  describe "#normalize" do
    it "brings data to canonical form" do
      expect(@adapter.normalize(@data)).to eq(@normalized)
    end
  end
end
