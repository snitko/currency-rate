require 'spec_helper'

RSpec.describe CurrencyRate::HuobiAdapter do

  before :all do
    VCR.insert_cassette 'exchange_rate_adapters/btc_adapters/huobi_adapter'
  end

  after :all do
    VCR.eject_cassette
  end

  before(:each) do
    @exchange_adapter = CurrencyRate::HuobiAdapter.instance
  end

  it "finds the rate for currency code" do
    expect(@exchange_adapter.rate_for('BTC', 'CNY')).to eq(5081.0)
    expect(@exchange_adapter.rate_for('CNY', 'BTC')).to eq(0.000196811651249754)
    expect(@exchange_adapter.rate_for('LTC', 'CNY')).to eq(36.9)
    expect(@exchange_adapter.rate_for('CNY', 'LTC')).to eq(0.02710027100271003)
    expect( -> { @exchange_adapter.rate_for('FEDcoin', 'USD') }).to raise_error(CurrencyRate::Adapter::CurrencyNotSupported)
  end

  it "raises exception if rate is nil" do
    json_response_1 = '{}'
    json_response_2 = '{"time":"1466406045","ticker":{"open":5108.77,"vol":533438.162,"symbol":"btccny","last":5081.29,"buy":5081.13,"sell":5081.29,"high":5138,"low":5010.5} }'
    json_response_3 = '{"time":"1466406045","ticker":{"open":5108.77,"vol":533438.162,"symbol":"btccny","last":5081.29,"buy":5081.13,"sell":5081.29,"high":5138,"low":5010.5} }'
    uri_mock = double('uri mock')
    allow(uri_mock).to receive(:read).with(read_timeout: 4).and_return(json_response_1, json_response_2, json_response_3)
    allow(URI).to      receive(:parse).and_return(uri_mock)
    3.times do
      @exchange_adapter.fetch_rates!
      expect( -> { @exchange_adapter.rate_for('FEDcoin', 'BTC') }).to raise_error(CurrencyRate::Adapter::CurrencyNotSupported)
    end
  end

end
