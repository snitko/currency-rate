require 'spec_helper'

RSpec.describe CurrencyRate::FixerAdapter do

  before :all do
    VCR.insert_cassette 'exchange_rate_adapters/fiat_adapters/fixer_adapter'
  end

  after :all do
    VCR.eject_cassette
  end

  before(:each) do
    @exchange_adapter = CurrencyRate::FixerAdapter.instance
  end

  it "finds the rate for currency code" do
    expect(@exchange_adapter.rate_for('USD', 'EUR')).to eq(1.12)
    expect(@exchange_adapter.rate_for('EUR', 'USD')).to eq(0.88)
    expect(@exchange_adapter.rate_for('RUB', 'USD')).to eq(65.12)
    expect(@exchange_adapter.rate_for('USD', 'RUB')).to eq(0.02)
    expect( -> { @exchange_adapter.rate_for('FEDcoin', 'USD') }).to raise_error(CurrencyRate::Adapter::CurrencyNotSupported)
  end

end
