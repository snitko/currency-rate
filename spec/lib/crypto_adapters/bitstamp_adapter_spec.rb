require 'spec_helper'

RSpec.describe CurrencyRate::BitstampAdapter do

  before :each do
    VCR.insert_cassette 'exchange_rate_adapters/btc_adapters/average_rate_adapter' # contains request to Bistamp
  end

  after :each do
    VCR.eject_cassette
  end

  before(:each) do
    @exchange_adapter = CurrencyRate::BitstampAdapter.instance
  end

  it "finds the rate for currency code" do
    expect(@exchange_adapter.rate_for('BTC', 'USD')).to eq(1017.17)
    expect(@exchange_adapter.rate_for('USD', 'BTC').to_f).to eq(0.00098312)
    expect(@exchange_adapter.rate_for('BTC', 'EUR')).to eq(946.0)
    expect(@exchange_adapter.rate_for('EUR', 'BTC').to_f).to eq(0.001057082)
    expect(@exchange_adapter.rate_for('LTC', 'USD')).to eq(41.01)
    expect(@exchange_adapter.rate_for('USD', 'LTC')).to eq(0.024384297)
    expect(@exchange_adapter.rate_for('LTC', 'EUR')).to eq(35.62)
    expect(@exchange_adapter.rate_for('EUR', 'LTC')).to eq(0.028074116)
    expect(@exchange_adapter.rate_for('USD', 'EUR').to_f).to eq(0.933619643)
    expect(@exchange_adapter.rate_for('EUR', 'USD')).to eq(1.0711)
    expect( -> { @exchange_adapter.rate_for('FEDcoin', 'USD') }).to raise_error(CurrencyRate::Adapter::CurrencyNotSupported)
  end

  it "raises exception if rate is nil" do
    json_response_1 = '{}'
    json_response_2 = '{"high": "232.89", "list": "224.13", "timestamp": "1423457015", "bid": "224.00", "vwap": "224.57", "volume": "14810.41127494", "low": "217.28", "ask": "224.13"}'
    json_response_3 = '{"high": "232.89", "last": null, "timestamp": "1423457015", "bid": "224.00", "vwap": "224.57", "volume": "14810.41127494", "low": "217.28", "ask": "224.13"}'
    uri_mock = double('uri mock')
    allow(uri_mock).to receive(:read).with(read_timeout: 4).and_return(json_response_1, json_response_2, json_response_3)
    allow(URI).to      receive(:parse).and_return(uri_mock)
    3.times do
      @exchange_adapter.fetch_rates!
      expect( -> { @exchange_adapter.rate_for('FEDcoin', 'BTC') }).to raise_error(CurrencyRate::Adapter::CurrencyNotSupported)
    end
  end

end
