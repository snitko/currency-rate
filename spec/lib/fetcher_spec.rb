require "spec_helper"

RSpec.describe CurrencyRate::Fetcher do
  before do
    @usd_try = BigDecimal.new("22")
    @usd_eur = BigDecimal.new("0.8457")
    @eur_try = @usd_eur / @usd_try
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
      @to = "TRY"
      @btc_try = BigDecimal.new("3832.5432")
      @exchange = "Bitstamp"
    end

    subject { @fetcher.fetch_crypto(@exchange, @from, @to) }

    context "when rates for selected exchange are not available" do
      before { allow(@storage_double).to receive(:read).with(@exchange).and_return(nil) }

      it { is_expected.to be_nil }
    end

    context "when pair supported by selected exchange" do
      context "when fetching for a crypto-crypto pair" do
        before do
          @to = "ETH"
          @btc_eth = BigDecimal.new("5032.5432")
          allow(@storage_double).to receive(:read).with(@exchange).and_return({ "BTC_ETH" => @btc_eth })
        end

        it { is_expected.to eq(@btc_eth) }

        it { is_expected.to be_a(BigDecimal) }
      end

      context "when fetching for a crypto-fiat pair" do
        before do
          allow(@storage_double).to receive(:read).with(@exchange).and_return({ "BTC_TRY" => @btc_try })
        end

        it { is_expected.to eq(@btc_try) }

        it { is_expected.to be_a(BigDecimal) }
      end
    end

    context "when pair not supported by selected exchange" do
      before do
        allow(@storage_double).to receive(:read).with(@exchange).and_return({ "LTC_TRY" => @btc_try })
      end

      it { is_expected.to be_nil }
    end

    context "when requested fiat currency not supported by selected exchange" do
      context "when selected exchange supports USD" do
        context "when fetching for a crypto-fiat pair" do
          before do
            @btc_usd = @btc_try
            allow(@storage_double).to receive(:read).with(@exchange).and_return({ "BTC_USD" => @btc_usd })
          end

          context "when any of fiat exchanges supports rate from USD to requested fiat currency" do
            before do
              allow(@fetcher).to receive(:fetch_fiat).with("USD", "TRY").and_return(@usd_try)
            end

            it { is_expected.to eq(@btc_usd * @usd_try) }
          end
        end

        context "when fetching for a crypto-crypto pair" do
          before do
            @btc_usd = BigDecimal.new("3000.5432")
            @eth_usd = BigDecimal.new("503.5432")
            @from = "BTC"
            @to = "ETH"
            allow(@storage_double).to receive(:read).with(@exchange).and_return({ "BTC_USD" => @btc_usd, "ETH_USD" => @eth_usd })
            allow(@fetcher).to receive(:fetch_fiat).with("USD", "ETH").and_return(nil)
          end

          context "when any of crypto exchanges supports rate from USD to requested crypto" do
            it { is_expected.to eq(@btc_usd / @eth_usd) }
          end
        end
      end

      context "when selected exchange doesn't support USD" do
        before do
          @btc_eur = @btc_try
          allow(@storage_double).to receive(:read).with(@exchange).and_return({ "BTC_EUR" => @btc_eur })
        end

        context "when any of fiat exchanges supports rate for one of supported by selected exchange currency" do
          before do
            allow(@fetcher).to receive(:fetch_fiat).with("EUR", "TRY").and_return(@eur_try)
          end

          it { is_expected.to eq(@btc_eur * @eur_try) }
        end

        context "when none of fiat exchanges support rate for one of supported by selected exchange currency" do
          before do
            allow(@fetcher).to receive(:fetch_fiat).with("EUR", "TRY").and_return(nil)
          end

          it { is_expected.to be_nil }
        end
      end
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
