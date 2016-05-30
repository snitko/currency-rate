require 'spec_helper'

describe CurrencyRate do

  before :each do
    allow(CurrencyRate::BitstampAdapter.instance).to receive('rate_for').with('USD').and_return(550)
    allow(CurrencyRate::BitstampAdapter.instance).to receive('rate_for').with('RUB').and_return(33100)
    allow(CurrencyRate::YahooAdapter.instance).to receive('rate_for').with('RUB').and_return(65)
  end

  it "fetches currency rate from a specified exchange" do
    expect(CurrencyRate.get('Bitstamp', 'USD')).to eq(550)
  end
  
  it "converts one currency into another" do
    expect(CurrencyRate.convert('Bitstamp', amount: 5, from: 'BTC', to: 'USD')).to eq(2750)
    expect(CurrencyRate.convert('Bitstamp', amount: 2750, from: 'USD', to: 'BTC')).to eq(5)
    expect(CurrencyRate.convert('Yahoo', amount: 300, from: 'USD', to: 'RUB')).to eq(19500)
    expect(CurrencyRate.convert('Yahoo', amount: 19500, from: 'RUB', to: 'USD')).to eq(300)
  end

  it "converts non-anchor currencies" do
    expect(CurrencyRate.convert('Bitstamp', amount: 1000, from: 'USD', to: 'RUB')).to eq(60181.82)
    expect(CurrencyRate.convert('Bitstamp', amount: 60181.81, from: 'RUB', to: 'USD')).to eq(1000)
  end
  
  
end
