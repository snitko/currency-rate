module CurrencyRate
  class KrakenAdapter < Adapter
    SUPPORTED_CURRENCIES = %w(
      ADA BCH BSV BTC DASH EOS ETC ETH GNO LTC MLN
      NMC QTUM REP USDT XDG XLM XMR XRP XTZ ZEC
    )

    ASSET_MAP = {
                  "XXBTZ" => "BTC",
                  "XETCZ" => "ETC",
                  "XETHZ" => "ETH",
                  "XLTCZ" => "LTC",
                  "XREPZ" => "REP",
                  "XXLMZ" => "XLM",
                  "XXMRZ" => "XMR",
                  "XXRPZ" => "XRP",
                  "XZECZ" => "ZEC",
                  "USDTZ" => "USDT",
                  "TZUSD" => "USDT",
                }

    ANCHOR_CURRENCY = "USD"

    FETCH_URL = "https://api.kraken.com/0/public/Ticker?pair=#{ %w(ADAUSD BCHUSD BSVUSD DASHUSD EOSUSD GNOUSD QTUMUSD XTZUSD USDTZUSD XETCZUSD XETHZUSD XLTCZUSD XREPZUSD XXLMZUSD XXMRZUSD XXRPZUSD XZECZUSD XXBTZUSD).join(",") }"

    def normalize(data)
      return nil unless super
      data["result"].reduce({ "anchor" => ANCHOR_CURRENCY, ANCHOR_CURRENCY => BigDecimal.new("1") }) do |result, (pair, value)|
        result[ta(pair.sub(ANCHOR_CURRENCY, ""))] = 1 / BigDecimal.new(value["c"].first.to_s)
        result
      end
    end

    def translate_asset(asset)
      ASSET_MAP[asset] || asset
    end
    alias_method :ta, :translate_asset

  end
end
