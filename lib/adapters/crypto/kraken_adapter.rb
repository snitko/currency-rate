module CurrencyRate
  class KrakenAdapter < Adapter
    FETCH_URL = {
      "BTC_USD" => "https://api.kraken.com/0/public/Ticker?pair=xbtusd",
      "BTC_EUR" => "https://api.kraken.com/0/public/Ticker?pair=xbteur",
      "LTC_USD" => "https://api.kraken.com/0/public/Ticker?pair=ltcusd",
      "LTC_EUR" => "https://api.kraken.com/0/public/Ticker?pair=ltceur",
    }

    ASSET_MAP = {
      "BTC" => "XBT",
    }

    def normalize(data)
      return nil unless super
      data.reduce({}) do |result, (pair, value)|
        crypto, fiat = pair.split("_")
        result[pair] = BigDecimal.new(value["result"]["X#{ta(crypto)}Z#{ta(fiat)}"]["c"].first.to_s)
        result
      end
    end

    def translate_asset(asset)
      ASSET_MAP[asset] || asset
    end
    alias_method :ta, :translate_asset

  end
end
