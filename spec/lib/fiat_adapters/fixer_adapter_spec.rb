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
    expect(@exchange_adapter.rate_for('RUB')).to be_kind_of(Numeric)
    expect( -> { @exchange_adapter.rate_for('KZT') }).to raise_error(CurrencyRate::Adapter::CurrencyNotSupported)
  end

end
