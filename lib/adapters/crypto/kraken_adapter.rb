module CurrencyRate
  class KrakenAdapter < Adapter
    SUPPORTED_CURRENCIES = %w(
      ADA BCH BSV BTC DASH EOS ETC ETH GNO LTC MLN
      NMC QTUM REP XDG XLM XMR XRP XTZ ZEC
    )

    ASSET_MAP = {
                  "XXBTZ" => "BTC",
                  "XETCX" => "ETC",
                  "XETHX" => "ETH",
                  "XLTCX" => "LTC",
                  "XREPX" => "REP",
                  "XXLMX" => "XLM",
                  "XXMRX" => "XMR",
                  "XXRPX" => "XRP",
                  "XZECX" => "ZEC",
                  "XZUSD" => "USD",
                  "BTC"   => "XBT",
                }

    ANCHOR_CURRENCY = "BTC"

    FETCH_URL = "https://api.kraken.com/0/public/Ticker?pair=#{ %w(ADAXBT BCHXBT BSVXBT DASHXBT EOSXBT GNOXBT QTUMXBT XTZXBT XETCXXBT XETHXXBT XLTCXXBT XREPXXBT XXLMXXBT XXMRXXBT XXRPXXBT XZECXXBT XXBTZUSD).join(",") }"

    def normalize(data)
      return nil unless super
      data["result"].reduce({ "anchor" => ANCHOR_CURRENCY }) do |result, (pair, value)|
        key = ta(pair.sub(ta(ANCHOR_CURRENCY), ""))

        if key == "USD"
          result[key] = BigDecimal.new(value["c"].first.to_s)
        else
          result[key] = 1 / BigDecimal.new(value["c"].first.to_s)
        end
        result
      end
    end

    def translate_asset(asset)
      ASSET_MAP[asset] || asset
    end
    alias_method :ta, :translate_asset

  end
end
