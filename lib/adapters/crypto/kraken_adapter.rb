module CurrencyRate
  class KrakenAdapter < Adapter
    FETCH_URL = {
      "btc_usd" => "https://api.kraken.com/0/public/Ticker?pair=xbtusd",
      "btc_eur" => "https://api.kraken.com/0/public/Ticker?pair=xbteur",
      "ltc_usd" => "https://api.kraken.com/0/public/Ticker?pair=ltcusd",
      "ltc_eur" => "https://api.kraken.com/0/public/Ticker?pair=ltceur",
    }

    ASSET_MAP = {
      "BTC" => "XBT",
    }

    def normalize(data)
      super
      data.reduce({}) do |result, (pair, value)|
        crypto, fiat = pair.split("_")
        result[pair] = BigDecimal.new(value["result"]["X#{ta(crypto)}Z#{ta(fiat)}"]["c"].first.to_s)
        result
      end
    end

    def translate_asset(asset)
      uasset = asset.upcase
      ASSET_MAP[uasset] || uasset
    end
    alias_method :ta, :translate_asset

  end
end
