require "spec_helper"

RSpec.describe CurrencyRate::ForgeAdapter do
  before(:all) { @data, @normalized = data_for :forge }

  before { @adapter = CurrencyRate::ForgeAdapter.instance }

  describe "#normalize" do
    it "brings data to canonical form" do
      expect(@adapter.normalize(@data)).to eq(@normalized)
    end
  end

  describe "#exchange_data" do
    context "when api_key not defined" do
      it "returns nil" do
        expect(@adapter.exchange_data).to be_nil
      end
    end
  end
end
