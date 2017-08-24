require 'spec_helper'

RSpec.describe CurrencyRate::CoinbaseAdapter do

  before :each do
    VCR.insert_cassette 'exchange_rate_adapters/btc_adapters/coinbase_adapter'
  end

  after :each do
    VCR.eject_cassette
  end

  before(:each) do
    @exchange_adapter = CurrencyRate::CoinbaseAdapter.instance
  end

  it "finds the rate for currency code" do
    expect(@exchange_adapter.rate_for('BTC', 'USD')).to eq(1019.98)
    expect(@exchange_adapter.rate_for('USD', 'BTC')).to eq(0.00098)
    expect(@exchange_adapter.rate_for('LTC', 'USD')).to eq(3.95)
    expect(@exchange_adapter.rate_for('USD', 'LTC')).to eq(0.253165)
    expect( -> { @exchange_adapter.rate_for('FEDcoin', 'USD') }).to raise_error(CurrencyRate::Adapter::CurrencyNotSupported)
  end

  it "raises exception if rate is nil" do
    json_response_1 = '{}'
    json_response_2 = '{"btc_to_urd":"224.41","usd_to_xpf":"105.461721","bsd_to_btc":"0.004456"}'
    json_response_3 = '{"btc_to_usd":null,"usd_to_xpf":"105.461721","bsd_to_btc":"0.004456"}'
    uri_mock = double('uri mock')
    allow(uri_mock).to receive(:read).with(read_timeout: 4).and_return(json_response_1, json_response_2, json_response_3)
    allow(URI).to      receive(:parse).and_return(uri_mock)
    3.times do
      @exchange_adapter.fetch_rates!
      expect( -> { @exchange_adapter.rate_for('FEDCoin', 'BTC') }).to raise_error(CurrencyRate::Adapter::CurrencyNotSupported)
    end

  end

end
