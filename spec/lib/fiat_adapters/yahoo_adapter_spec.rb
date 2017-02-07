require 'spec_helper'

RSpec.describe CurrencyRate::YahooAdapter do

  before :each do
    VCR.insert_cassette 'exchange_rate_adapters/fiat_adapters/yahoo_adapter'
  end

  after :each do
    VCR.eject_cassette
  end

  before(:each) do
    @exchange_adapter = CurrencyRate::YahooAdapter.instance
  end

  it "finds the rate for currency code" do
    expect(@exchange_adapter.rate_for('EUR', 'USD')).to eq(1.08)
    expect(@exchange_adapter.rate_for('USD', 'EUR')).to eq(0.93)
    expect(@exchange_adapter.rate_for('USD', 'RUB')).to eq(58.91)
    expect(@exchange_adapter.rate_for('RUB', 'USD')).to eq(0.02)
    expect( -> { @exchange_adapter.rate_for('USD', 'FEDcoin') }).to raise_error(CurrencyRate::Adapter::CurrencyNotSupported)
  end

end
