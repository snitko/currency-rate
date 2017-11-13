require "spec_helper"

RSpec.describe CurrencyRate::CurrencyLayerAdapter do
  before(:all) { @data, @normalized = data_for :currency_layer }

  before { stub_request(:get, /apilayer/).to_return(body: @data.to_json) }

  before { @adapter = CurrencyRate::CurrencyLayerAdapter.instance }

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
