require 'spec_helper'

EXCHANGE_STUB_DOMAIN = "http://exchange.stub.com"

RESPONSE = {
  "btc_usd" => 5000,
  "ltc_usd" => 50,
}

class HashUrlAdapter < CurrencyRate::Adapter
  FETCH_URL = {
    "btc_usd" => "#{EXCHANGE_STUB_DOMAIN}/btc_usd",
    "ltc_usd" => "#{EXCHANGE_STUB_DOMAIN}/ltc_usd",
  }
end

class StringUrlAdapter < CurrencyRate::Adapter
  FETCH_URL = EXCHANGE_STUB_DOMAIN
end

RSpec.describe CurrencyRate::Adapter do
  describe "#exchange_data" do
    context "when FETCH_URL is not defined" do
      before { @adapter = CurrencyRate::Adapter.instance }

      it "raises an error" do
        expect { @adapter.exchange_data }.to raise_error("FETCH_URL is not defined!")
      end
    end

    context "when FETCH_URL is Hash" do
      before do
        @adapter = HashUrlAdapter.instance
        @response_map = Hash[RESPONSE.map { |k, v| [k, { "price" => v } ] }]
        RESPONSE.each { |k, v| stub_request(:get, "#{EXCHANGE_STUB_DOMAIN}/#{k}").to_return(body: { "price" => v }.to_json) }
      end

      it "fetches data for each defined pair" do
        expect(@adapter.exchange_data).to eq(@response_map)
      end
    end

    context "when FETCH_URL is String" do
      before do
        @adapter = StringUrlAdapter.instance
        stub_request(:get, EXCHANGE_STUB_DOMAIN).to_return(body: RESPONSE.to_json)
      end

      it "fetches all data from exchange and retruns parsed Hash" do
        expect(@adapter.exchange_data).to eq(RESPONSE)
      end
    end
  end
end
