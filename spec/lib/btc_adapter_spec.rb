require 'spec_helper'

RSpec.describe CurrencyRate::BtcAdapter do

  class CurrencyRate::Adapter
    FETCH_URL = ''
  end

  class SomeExchangeAdapter < CurrencyRate::BtcAdapter
    def rate_for(from,to)
      super
      rate = rate_to_f(750)
      invert_rate(from,to,rate)
    end
  end

  before(:each) do
    @exchange_adapter = CurrencyRate::BtcAdapter.instance
  end

  it "inverts currency rate when needed" do
    allow(SomeExchangeAdapter.instance).to receive(:fetch_rates!)
    @exchange_adapter = SomeExchangeAdapter.instance
    expect(@exchange_adapter.rate_for('BTC', 'USD')).to eq(0.0013333333333333333)
  end


  it "when checking for rates, only calls fetch_rates! if they were checked long time ago or never" do
    uri_mock = double('uri mock')
    expect(URI).to      receive(:parse).and_return(uri_mock).once
    expect(uri_mock).to receive(:read).and_return('{ "USD": 534.4343 }').once
    @exchange_adapter.rate_for('USD', 'BTC')
    @exchange_adapter.rate_for('USD', 'BTC') # not calling fetch_rates! because we've just checked
    @exchange_adapter.instance_variable_set(:@rates_updated_at, Time.now-1900)
    @exchange_adapter.rate_for('USD', 'BTC')
  end

  it "raises exception if rate is nil" do
    rate = nil
    expect( -> { @exchange_adapter.rate_to_f(rate) }).to raise_error(CurrencyRate::Adapter::CurrencyNotSupported)
  end

end
