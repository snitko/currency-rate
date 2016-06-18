require 'spec_helper'

describe CurrencyRate do

  before :each do
    allow(CurrencyRate::BitstampAdapter.instance).to receive('rate_for').with('USD', 'BTC').and_return(550)
    allow(CurrencyRate::BitstampAdapter.instance).to receive('rate_for').with('BTC', 'USD').and_return(1.to_f/550.to_f)
    allow(CurrencyRate::BitstampAdapter.instance).to receive('rate_for').with('RUB', 'BTC').and_return(33100)
    allow(CurrencyRate::YahooAdapter.instance).to receive('rate_for').with('RUB', 'USD').and_return(60)
    allow(CurrencyRate::YahooAdapter.instance).to receive('rate_for').with('USD', 'RUB').and_return(1.to_f/60.to_f)
  end

  it "fetches currency rate from a specified exchange" do
    expect(CurrencyRate.get('Bitstamp', 'USD', 'BTC')).to eq(550)
    expect(CurrencyRate.get('Bitstamp', 'BTC', 'USD')).to eq(1.to_f/550.to_f)
    expect(CurrencyRate.get('Bitstamp', 'RUB', 'USD').round(2)).to eq(60.18)
  end
  
  it "converts one currency into another" do
    expect(CurrencyRate.convert('Bitstamp', amount: 5, from: 'BTC', to: 'USD')).to eq(2750)
    expect(CurrencyRate.convert('Bitstamp', amount: 2750, from: 'USD', to: 'BTC')).to eq(5)
    expect(CurrencyRate.convert('Yahoo', amount: 300, from: 'USD', to: 'RUB')).to eq(18000)
    expect(CurrencyRate.convert('Yahoo', amount: 19500, from: 'RUB', to: 'USD')).to eq(325)
  end

  it "converts non-anchor currencies" do
    expect(CurrencyRate.convert('Bitstamp', amount: 1000, from: 'USD', to: 'RUB')).to eq(60181.82)
    expect(CurrencyRate.convert('Bitstamp', amount: 60181.81, from: 'RUB', to: 'USD')).to eq(1000)
  end
  
  
end
