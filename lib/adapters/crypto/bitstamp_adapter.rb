module CurrencyRate
  class BitstampAdapter < Adapter
    CRYPTOS = %w[
                  btc eth ltc xrp
                ]

    FETCH_URL = Hash[CRYPTOS.collect { |crypto| [ "#{crypto}_usd".upcase, "https://www.bitstamp.net/api/v2/ticker/#{crypto}usd/" ] }]

    def normalize(data)
      return nil unless super
      data.reduce({}) do |result, (pair, value)|
        result[pair] = BigDecimal.new(value["last"].to_s)
        result
      end
    end

  end
end
