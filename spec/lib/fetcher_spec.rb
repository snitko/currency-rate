require "spec_helper"

RSpec.describe CurrencyRate::Fetcher do
  before do
    @usd_try = BigDecimal.new("22")
    @usd_eur = BigDecimal.new("0.8457")
    @eur_try = @usd_try / @usd_eur
    @storage_double = double("storage")
    @fetcher = CurrencyRate::Fetcher.new(storage: @storage_double)
  end

  it "uses FileStorage by default" do
    fetcher = CurrencyRate::Fetcher.new
    expect(fetcher.storage).to be_a(CurrencyRate::FileStorage)
  end

  it "overwrites the default list of fiat exchanges" do
    fetcher = CurrencyRate::Fetcher.new(fiat_exchanges: ["CurrencyLayer", "Forge", "Fixer"])
    expect(fetcher.fiat_exchanges).to eq(["CurrencyLayer", "Forge", "Fixer"])
  end

  describe "#fetch_crypto" do
    before do
      @from = "BTC"
      @to = "ETH"
      @btc_eth = BigDecimal.new("3832.5432")
      @exchange = "Bitstamp"
    end

    subject { @fetcher.fetch_crypto(@exchange, @from, @to) }

    context "when rates for selected exchange are not available" do
      before { allow(@storage_double).to receive(:read).with(@exchange).and_return(nil) }

      it { is_expected.to be_nil }
    end

    context "when pair is supported by selected exchange" do
      before do
        allow(@storage_double).to receive(:read).with(@exchange).and_return({ "anchor" => "BTC", "ETH" => @btc_eth })
      end

      it { is_expected.to eq(@btc_eth) }

      it { is_expected.to be_a(BigDecimal) }
    end

    context "when pair is not supported by selected exchange" do
      before do
        allow(@storage_double).to receive(:read).with(@exchange).and_return({ "anchor" => "BTC", "XOS" => @btc_eth })
        allow(@storage_double).to receive(:read).with("Yahoo").and_return(nil)
        allow(@storage_double).to receive(:read).with("Fixer").and_return(nil)
        allow(@storage_double).to receive(:read).with("Forge").and_return(nil)
      end

      it { is_expected.to be_nil }
    end
  end

  describe "#fetch_fiat" do
    before do
      @from = "EUR"
      @to = "TRY"
      @fiat_exchanges = ["Yahoo", "Fixer", "Forge"]
    end

    subject { @fetcher.fetch_fiat(@from, @to) }

    it "uses Yahoo -> Fixer -> Forge priority order" do
      expect(@storage_double).to receive(:read).with("Yahoo").and_return(nil).ordered
      expect(@storage_double).to receive(:read).with("Fixer").and_return(nil).ordered
      expect(@storage_double).to receive(:read).with("Forge").and_return(nil).ordered
      @fetcher.fetch_fiat("EUR", "TRY")
    end

    it "uses next exchange if rates for current do not exist" do
      allow(@storage_double).to receive(:read).with(@fiat_exchanges.first).and_return(nil)
      expect(@storage_double).to receive(:read).with(@fiat_exchanges[1]).and_return(nil)
      expect(@storage_double).to receive(:read).with(@fiat_exchanges[2]).and_return(nil)
      @fetcher.fetch_fiat("EUR", "TRY")
    end

    context 'when first exchange has "from" currency as an anchor' do
      before do
        allow(@storage_double).to receive(:read).with(@fiat_exchanges.first).and_return({ "anchor" => "EUR", "TRY" => @eur_try })
      end
      it { is_expected.to eq(@eur_try) }
    end

    context 'when first exchange has "to" currency as an anchor' do
      before do
        allow(@storage_double).to receive(:read).with(@fiat_exchanges.first).and_return({ "anchor" => "TRY", "EUR" => (BigDecimal.new(1) / @eur_try).round(16) })
      end

      it "returns reversed to anchor rate" do
        expect(subject.round(16)).to eq(@eur_try.round(16))
      end
    end

    context "when first exchange has different from requested anchor currency" do
      context "when first exchange has rates for both requested currencies" do
        before do
          allow(@storage_double).to receive(:read).with(@fiat_exchanges.first).and_return({
            "anchor" => "USD",
            "EUR" => @usd_eur,
            "TRY" => @usd_try,
          })
        end

        it { is_expected.to eq(@eur_try) }
      end

      context "when first exchange doen't have rates for requested currencies" do
        before do
          allow(@storage_double).to receive(:read).with(@fiat_exchanges.first).and_return(nil)
          expect(@storage_double).to receive(:read).with(@fiat_exchanges[1]).and_return({ "anchor" => "EUR", "TRY" => @eur_try })
        end

        it { is_expected.to eq(@eur_try) }
      end
    end

  end
end
