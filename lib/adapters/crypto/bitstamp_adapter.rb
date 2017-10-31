module CurrencyRate
  class BitstampAdapter < Adapter
    FETCH_URL = {
      'BTC_USD' => 'https://www.bitstamp.net/api/v2/ticker/btcusd/',
      'BTC_EUR' => 'https://www.bitstamp.net/api/v2/ticker/btceur/',
      'LTC_USD' => 'https://www.bitstamp.net/api/v2/ticker/ltcusd/',
      'LTC_EUR' => 'https://www.bitstamp.net/api/v2/ticker/ltceur/',
    }

    def normalize(data)
      return nil unless super
      data.reduce({}) do |result, (pair, value)|
        result[pair] = BigDecimal.new(value["last"].to_s)
        result
      end
    end

  end
end
