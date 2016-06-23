require 'spec_helper'

RSpec.describe CurrencyRate::OkcoinAdapter do

  before :all do
    VCR.insert_cassette 'exchange_rate_adapters/btc_adapters/okcoin_adapter'
  end

  after :all do
    VCR.eject_cassette
  end

  before(:each) do
    @exchange_adapter = CurrencyRate::OkcoinAdapter.instance
  end

  it "finds the rate for currency code" do
    expect(@exchange_adapter.rate_for('BTC', 'USD')).to eq(769.05)
    expect(@exchange_adapter.rate_for('USD', 'BTC')).to eq(0.001300306)
    expect(@exchange_adapter.rate_for('BTC', 'CNY')).to eq(5113.0)
    expect(@exchange_adapter.rate_for('CNY', 'BTC')).to eq(0.000195580)

    expect(@exchange_adapter.rate_for('LTC', 'USD')).to eq(5.661)
    expect(@exchange_adapter.rate_for('USD', 'LTC')).to eq(0.176647235)
    expect(@exchange_adapter.rate_for('LTC', 'CNY')).to eq(37.68)
    expect(@exchange_adapter.rate_for('CNY', 'LTC')).to eq(0.026539278)
    expect( -> { @exchange_adapter.rate_for('FEDcoin', 'USD') }).to raise_error(CurrencyRate::Adapter::CurrencyNotSupported)
  end

  it "raises exception if rate is nil" do
    response = [
      '{"date":"1422679981","ticker":{}}',
      '{"date":"1422679981","ticker":{"buy":"227.27","high":"243.55","bambo":"226.89","low":"226.0","sell":"227.74","vol":"16065.2085"}}',
      '{"date":"1422679981","ticker":{"buy":"227.27","high":"243.55","last":null,"low":"226.0","sell":"227.74","vol":"16065.2085"}}',
    ]
    3.times do |i|
      @exchange_adapter.instance_variable_set :@rates_updated_at, Time.now
      @exchange_adapter.instance_variable_set :@rates, JSON.parse(response[i])
      expect( -> { @exchange_adapter.rate_for('FEDcoin', 'BTC') }).to raise_error(CurrencyRate::Adapter::CurrencyNotSupported)
    end
  end

end
