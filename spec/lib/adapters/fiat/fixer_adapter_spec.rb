require "spec_helper"

RSpec.describe CurrencyRate::FixerAdapter do
  before(:all) { @data, @normalized = data_for :fixer }

  before { @adapter = CurrencyRate::FixerAdapter.instance }

  describe "#normalize" do
    it "brings data to canonical form" do
      expect(@adapter.normalize(@data)).to eq(@normalized)
    end
  end
end
