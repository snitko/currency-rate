require 'spec_helper'

RSpec.describe CurrencyRate::BitpayAdapter do

  before :each do
    VCR.insert_cassette 'exchange_rate_adapters/btc_adapters/average_rate_adapter' # contains request to Bitpay
  end

  after :each do
    VCR.eject_cassette
  end

  before(:each) do
    @exchange_adapter = CurrencyRate::BitpayAdapter.instance
  end

  it "finds the rate for currency code" do
    expect(@exchange_adapter.rate_for('BTC', 'USD')).to eq(1015.59)
    expect(@exchange_adapter.rate_for('BTC', 'BTC')).to eq(1)
    expect(@exchange_adapter.rate_for('BTC', 'EUR')).to eq(941.895743)
    expect(@exchange_adapter.rate_for('EUR', 'BTC')).to eq(1)
    expect( -> { @exchange_adapter.rate_for('USD', 'EUR') }).to raise_exception(CurrencyRate::Adapter::CurrencyNotSupported)
    expect( -> { @exchange_adapter.rate_for('EUR', 'USD') }).to raise_exception(CurrencyRate::Adapter::CurrencyNotSupported)
    expect( -> { @exchange_adapter.rate_for('FEDcoin', 'USD') }).to raise_error(CurrencyRate::Adapter::CurrencyNotSupported)
  end

  it "raises exception if rate is nil" do
    json_response_1 = '[{},{}]'
    json_response_2 = '[{"code":"USD","name":"US Dollar","rat":223.59},{"code":"EUR","name":"Eurozone Euro","rate":197.179544}]'
    json_response_3 = '[{"code":"USD","name":"US Dollar","rate":null},{"code":"EUR","name":"Eurozone Euro","rate":197.179544}]'
    uri_mock = double('uri mock')
    allow(uri_mock).to receive(:read).with(read_timeout: 4).and_return(json_response_1, json_response_2, json_response_3)
    allow(URI).to      receive(:parse).and_return(uri_mock)
    3.times do
      @exchange_adapter.fetch_rates!
      expect( -> { @exchange_adapter.rate_for('FEDcoin', 'USD') }).to raise_error(CurrencyRate::Adapter::CurrencyNotSupported)
    end
  end

end
