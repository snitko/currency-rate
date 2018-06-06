module CurrencyRate
  class BitfinexAdapter < Adapter
    FETCH_URL = {
      "BTC_USD" => "https://api.bitfinex.com/v1/pubticker/btcusd",
      "LTC_USD" => "https://api.bitfinex.com/v1/pubticker/ltcusd",
      "BTC_EUR" => "https://api.bitfinex.com/v1/pubticker/btceur",
      "LTC_EUR" => "https://api.bitfinex.com/v1/pubticker/ltceur"
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
