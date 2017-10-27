module CurrencyRate
  class BitfinexAdapter < Adapter
    FETCH_URL = {
      "btc_usd" => "https://api.bitfinex.com/v1/pubticker/btcusd",
      "ltc_usd" => "https://api.bitfinex.com/v1/pubticker/ltcusd",
    }

    def normalize(data)
      return nil unless super
      data.reduce({}) do |result, (pair, value)|
        result[pair] = BigDecimal.new(value["last_price"].to_s)
        result
      end
    end

  end
end
