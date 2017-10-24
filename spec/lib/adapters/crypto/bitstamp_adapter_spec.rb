require "spec_helper"

RSpec.describe CurrencyRate::BitstampAdapter do
  before(:all) { @data, @normalized = data_for :bitstamp }

  before { @adapter = CurrencyRate::BitstampAdapter.instance }

  describe "#normalize" do
    it "brings data to cannonical form" do
      expect(@adapter.normalize(@data)).to eq(@normalized)
    end
  end
end
