require 'spec_helper'

RSpec.describe CurrencyRate::BtceAdapter do

  before :all do
    VCR.insert_cassette 'exchange_rate_adapters/btc_adapters/btce_adapter'
  end

  after :all do
    VCR.eject_cassette
  end

  before(:each) do
    @exchange_adapter = CurrencyRate::BtceAdapter.instance
  end

  it "finds the rate for currency code" do
    expect(@exchange_adapter.rate_for('USD', 'BTC')).to eq(723.872)
    expect(@exchange_adapter.rate_for('BTC', 'USD')).to eq(0.0013814597055833075)
    expect(@exchange_adapter.rate_for('EUR', 'BTC')).to eq(665.022)
    expect(@exchange_adapter.rate_for('BTC', 'EUR')).to eq(0.0015037096517107704)
    expect(@exchange_adapter.rate_for('RUB', 'USD')).to eq(60.5)
    expect(@exchange_adapter.rate_for('USD', 'RUB')).to eq(0.01652892561983471)
    expect(@exchange_adapter.rate_for('RUB', 'EUR')).to eq(65.63)
    expect(@exchange_adapter.rate_for('EUR', 'RUB')).to eq(0.015236934328813043)
    expect( -> { @exchange_adapter.rate_for('FEDcoin', 'USD') }).to raise_error(CurrencyRate::Adapter::CurrencyNotSupported)
  end

  it "rases exception if rate is nil" do
    json_response_1 = '{"ticker":{}}'
    json_response_2 = '{"ticker":{"high":235,"low":215.89999,"avg":225.449995,"vol":2848293.72397,"vol_cur":12657.55799,"bambo":221.444,"buy":221.629,"sell":220.98,"updated":1422678812,"server_time":1422678813}}'
    json_response_3 = '{"ticker":{"high":235,"low":215.89999,"avg":225.449995,"vol":2848293.72397,"vol_cur":12657.55799,"last":null,"buy":221.629,"sell":220.98,"updated":1422678812,"server_time":1422678813}}'
    uri_mock = double('uri mock')
    allow(uri_mock).to receive(:read).with(read_timeout: 4).and_return(json_response_1, json_response_2, json_response_3)
    allow(URI).to      receive(:parse).and_return(uri_mock)
    3.times do
      @exchange_adapter.fetch_rates!
      expect( -> { @exchange_adapter.rate_for('EUR', 'USD') }).to raise_error(CurrencyRate::Adapter::CurrencyNotSupported)
    end
  end

end
