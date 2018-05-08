require "spec_helper"

RSpec.describe CurrencyRate::Synchronizer do
  before do
    @storage_double = double("storage")
    @synchronizer = CurrencyRate::Synchronizer.new(storage: @storage_double)

    @kraken_data = normalized_data_for :kraken
    @crypto_adapters = ["Kraken"]
    allow(CurrencyRate::KrakenAdapter.instance).to receive(:fetch_rates).and_return(@kraken_data)
    allow(CurrencyRate.configuration).to receive(:crypto_adapters).and_return(@crypto_adapters)

    @yahoo_data = normalized_data_for :yahoo
    @fiat_adapters = ["Yahoo"]
    allow(CurrencyRate::YahooAdapter.instance).to receive(:fetch_rates).and_return(@yahoo_data)
    allow(CurrencyRate.configuration).to receive(:fiat_adapters).and_return(@fiat_adapters)
  end

  describe "#sync_crypto!" do
    it "saves crypto rates to given storage" do
      expect(@storage_double).to receive(:write).with("kraken", @kraken_data)
      @synchronizer.sync_crypto!
    end

    it "doesn't fetch fiat rates" do
      expect(@storage_double).not_to receive(:write).with("yahoo", @yahoo_data)
      @synchronizer.sync_crypto!
    end
  end

  describe "#sync_fiat!" do
    it "saves fiat rates to given storage" do
      expect(@storage_double).to receive(:write).with("yahoo", @yahoo_data)
      @synchronizer.sync_fiat!
    end

    it "doesn't fetch crypto rates" do
      expect(@storage_double).not_to receive(:write).with("kraken", @kraken_data)
      @synchronizer.sync_fiat!
    end
  end

  describe "#sync!" do
    before do
      @kraken_data = normalized_data_for :kraken
      @crypto_adapters = ["Kraken"]
      allow(CurrencyRate::KrakenAdapter.instance).to receive(:fetch_rates).and_return(@kraken_data)
      allow(CurrencyRate.configuration).to receive(:crypto_adapters).and_return(@crypto_adapters)

      @yahoo_data = normalized_data_for :yahoo
      @fiat_adapters = ["Yahoo"]
      allow(CurrencyRate::YahooAdapter.instance).to receive(:fetch_rates).and_return(@yahoo_data)
      allow(CurrencyRate.configuration).to receive(:fiat_adapters).and_return(@fiat_adapters)
    end

    it "saves fetched rates to given storage" do
      expect(@storage_double).to receive(:write).with("kraken", @kraken_data)
      expect(@storage_double).to receive(:write).with("yahoo", @yahoo_data)
      @synchronizer.sync!
    end

    context "when adapter returned nil data" do
      before do
        allow(CurrencyRate::KrakenAdapter.instance).to receive(:fetch_rates).and_return(nil)
        allow(@storage_double).to receive(:write).with("yahoo", @yahoo_data)
      end

      it "doesn't try to save nil data to the storage" do
        expect(@storage_double).not_to receive(:write).with("kraken", nil)
        @synchronizer.sync!
      end

      it "doesn't throw an exception" do
        expect { @synchronizer.sync! }.not_to raise_error
      end

      it "saves other successfully fetched adapters data" do
        expect(@storage_double).to receive(:write).with("yahoo", @yahoo_data)
        @synchronizer.sync!
      end
    end

    context "when adapter fetching failed with and error" do
      before do
        allow(CurrencyRate::KrakenAdapter.instance).to receive(:fetch_rates).and_raise("Error!")
        allow(@storage_double).to receive(:write).with("yahoo", @yahoo_data)
      end

      it "catches the exception" do
        expect { @synchronizer.sync! }.not_to raise_error
      end

      it "continues fetching other adapters" do
        expect(@storage_double).to receive(:write).with("yahoo", @yahoo_data)
        @synchronizer.sync!
      end
    end
  end
end
