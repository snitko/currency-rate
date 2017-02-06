require 'spec_helper'

RSpec.describe CurrencyRate::AverageRateAdapter do

  before :each do
    VCR.insert_cassette 'exchange_rate_adapters/btc_adapters/average_rate_adapter'
  end

  after :each do
    VCR.eject_cassette
  end

  before(:each) do
    @average_rates_adapter = CurrencyRate::AverageRateAdapter.instance(
      CurrencyRate::BitstampAdapter,
      CurrencyRate::BitpayAdapter.instance,
    )
  end

  it "calculates average rate" do
    expect(@average_rates_adapter.rate_for('BTC', 'USD')).to eq 1016.38
  end

  it "fetches rates for all adapters" do
    expect(@average_rates_adapter.fetch_rates!).not_to be_empty
  end

  it 'raises error if all adapters failed to fetch rates' do
    adapter_mocks = [double('adapter_1'), double('adapter_2')]
    adapter_mocks.each do |adapter|
      expect(adapter).to receive(:fetch_rates!).and_raise(CurrencyRate::Adapter::FetchingFailed)
    end
    average_rates_adapter = CurrencyRate::AverageRateAdapter.instance(*adapter_mocks)
    expect( -> { average_rates_adapter.fetch_rates! }).to raise_error(CurrencyRate::Adapter::FetchingFailed)
  end

  it "raises exception if all adapters fail to get rates" do
    expect( -> { @average_rates_adapter.rate_for('BTC', 'FEDcoin') }).to raise_error(CurrencyRate::Adapter::CurrencyNotSupported)
  end

  it "raises exception if unallowed method is called" do # fetch_rates! is not to be used in AverageRateAdapter itself
    expect( -> { @average_rates_adapter.get_rate_value_from_hash(nil, 'nothing') }).to raise_error("This method is not supposed to be used in #{@average_rates_adapter.class}.")
    expect( -> { @average_rates_adapter.rate_to_f(nil) }).to raise_error("This method is not supposed to be used in #{@average_rates_adapter.class}.")
  end

end
