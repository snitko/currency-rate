require 'spec_helper'

RSpec.describe CurrencyRate::BTCChinaAdapter do

  before :all do
    VCR.insert_cassette 'exchange_rate_adapters/btc_adapters/btcchina_adapter'
  end

  after :all do
    VCR.eject_cassette
  end

  before(:each) do
    @exchange_adapter = CurrencyRate::BTCChinaAdapter.instance
  end

  it "finds the rate for currency code" do
    expect(@exchange_adapter.rate_for('BTC', 'CNY')).to eq(4785.55)
    expect(@exchange_adapter.rate_for('CNY', 'BTC')).to eq(0.000208962)
    expect( -> { @exchange_adapter.rate_for('FEDcoin', 'USD') }).to raise_error(CurrencyRate::Adapter::CurrencyNotSupported)
  end

  it "raises exception if rate is nil" do
    json_response_1 = '{}'
    json_response_2 = '{"ticker":{"high":"5119.92","low":"4980.00","buy":"5081.50","sell":"5081.97","last":"5081.98","vol":"44572.00110000","date":1466406593,"vwap":"5056.91","prev_close":"5096.97","open":"5096.28"}}'
    json_response_3 = '{"ticker":{"high":"5119.92","low":"4980.00","buy":"5081.50","sell":"5081.97","last":"5081.98","vol":"44572.00110000","date":1466406593,"vwap":"5056.91","prev_close":"5096.97","open":"5096.28"}}'
    uri_mock = double('uri mock')
    allow(uri_mock).to receive(:read).with(read_timeout: 4).and_return(json_response_1, json_response_2, json_response_3)
    allow(URI).to      receive(:parse).and_return(uri_mock)
    3.times do
      @exchange_adapter.fetch_rates!
      expect( -> { @exchange_adapter.rate_for('FEDcoin', 'BTC') }).to raise_error(CurrencyRate::Adapter::CurrencyNotSupported)
    end
  end

end
