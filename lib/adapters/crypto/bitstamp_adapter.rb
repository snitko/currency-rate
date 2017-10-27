module CurrencyRate
  class BitstampAdapter < Adapter
    FETCH_URL = {
      'btc_usd' => 'https://www.bitstamp.net/api/v2/ticker/btcusd/',
      'btc_eur' => 'https://www.bitstamp.net/api/v2/ticker/btceur/',
      'ltc_usd' => 'https://www.bitstamp.net/api/v2/ticker/ltcusd/',
      'ltc_eur' => 'https://www.bitstamp.net/api/v2/ticker/ltceur/',
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
