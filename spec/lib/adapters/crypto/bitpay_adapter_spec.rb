require "spec_helper"

RSpec.describe CurrencyRate::BitpayAdapter do
  before(:all) { @data, @normalized = data_for :bitpay }

  before { @adapter = CurrencyRate::BitpayAdapter.instance }

  describe "#normalize" do
    it "brings data to cannonical form" do
      expect(@adapter.normalize(@data)).to eq(@normalized)
    end
  end
end
