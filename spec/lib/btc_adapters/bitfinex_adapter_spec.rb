require 'spec_helper'

RSpec.describe CurrencyRate::BitfinexAdapter do

  before :each do
    VCR.insert_cassette 'exchange_rate_adapters/btc_adapters/bitfinex_adapter'
  end

  after :each do
    VCR.eject_cassette
  end

  before(:each) do
    @exchange_adapter = CurrencyRate::BitfinexAdapter.instance
  end

  it "finds the rate for currency code" do
    expect(@exchange_adapter.rate_for('BTC', 'USD')).to eq(1016.9)
    expect(@exchange_adapter.rate_for('USD', 'BTC')).to eq(0.000983381)
    expect(@exchange_adapter.rate_for('LTC', 'USD')).to eq(3.9526)
    expect(@exchange_adapter.rate_for('USD', 'LTC')).to eq(0.252998027)
    expect( -> { @exchange_adapter.rate_for('FEDcoin', 'USD') }).to raise_error(CurrencyRate::Adapter::CurrencyNotSupported)
  end

  it "raises exception if rate is nil" do
    json_response_1 = '{}'
    json_response_2 = '{"mid":"762.495","bid":"762.49","ask":"762.5","last_price":"762.5","low":"743.1","high":"775.0","volume":"25680.26724445","timestamp":"1466405569.857112499"}'
    json_response_3 = '{"mid":"762.495","bid":"762.49","ask":"762.5","last_price":"762.5","low":"743.1","high":"775.0","volume":"25680.26724445","timestamp":"1466405569.857112499"}'
    uri_mock = double('uri mock')
    allow(uri_mock).to receive(:read).with(read_timeout: 4).and_return(json_response_1, json_response_2, json_response_3)
    allow(URI).to      receive(:parse).and_return(uri_mock)
    3.times do
      @exchange_adapter.fetch_rates!
      expect( -> { @exchange_adapter.rate_for('FEDcoin', 'BTC') }).to raise_error(CurrencyRate::Adapter::CurrencyNotSupported)
    end
  end

end
