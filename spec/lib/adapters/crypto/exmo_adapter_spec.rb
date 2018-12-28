require "spec_helper"

RSpec.describe CurrencyRate::ExmoAdapter do
  before(:all) { @data, @normalized = data_for :exmo }

  before { @adapter = CurrencyRate::ExmoAdapter.instance }

  describe "#normalize" do
    it "brings data to canonical form" do
      expect(@adapter.normalize(@data)).to eq(@normalized)
    end
  end
end
