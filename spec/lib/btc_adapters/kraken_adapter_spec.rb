require 'spec_helper'

RSpec.describe CurrencyRate::KrakenAdapter do

  before :all do
    VCR.insert_cassette 'exchange_rate_adapters/btc_adapters/kraken_adapter'
  end

  after :all do
    VCR.eject_cassette
  end

  before(:each) do
    @exchange_adapter = CurrencyRate::KrakenAdapter.instance
  end

  it "finds the rate for currency code" do
    expect(@exchange_adapter.rate_for('BTC', 'USD')).to eq(755.15)
    expect(@exchange_adapter.rate_for('USD', 'BTC')).to eq(0.0013242402171753957)
    expect(@exchange_adapter.rate_for('BTC', 'EUR')).to eq(671.215)
    expect(@exchange_adapter.rate_for('EUR', 'BTC')).to eq(0.0014898355966419105)
    expect( -> { @exchange_adapter.rate_for('FEDcoin', 'USD') }).to raise_error(CurrencyRate::Adapter::CurrencyNotSupported)
  end

  it "raises exception if rate is nil" do
    json_response_1 = '{"error":[],"result":{}}'
    json_response_2 = '{"error":[],"result":{"XXBTZUSD":{"a":["244.95495","1"],"b":["227.88761","1"],"abc":["228.20494","0.10000000"],"v":["5.18645337","24.04033530"],"p":["234.92296","234.41356"],"t":[45,74],"l":["228.20494","228.20494"],"h":["239.36069","239.36069"],"o":"231.82976"}}}'
    json_response_3 = '{"error":[],"result":{"XXBTZUSD":{"a":["244.95495","1"],"b":["227.88761","1"],"c":[null,"0.10000000"],"v":["5.18645337","24.04033530"],"p":["234.92296","234.41356"],"t":[45,74],"l":["228.20494","228.20494"],"h":["239.36069","239.36069"],"o":"231.82976"}}}'
    uri_mock = double('uri mock')
    allow(uri_mock).to receive(:read).with(read_timeout: 4).and_return(json_response_1, json_response_2, json_response_3)
    allow(URI).to      receive(:parse).and_return(uri_mock)
    3.times do
      @exchange_adapter.fetch_rates!
      expect( -> { @exchange_adapter.rate_for('FEDCoin', 'USD') }).to raise_error(CurrencyRate::Adapter::CurrencyNotSupported)
    end
  end

end
