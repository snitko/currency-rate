module CurrencyRate
  class CoinbaseAdapter < Adapter
    FETCH_URL = 'https://coinbase.com/api/v1/currencies/exchange_rates'

    def normalize(data)
      super
      data.reduce({}) do |result, (pair, value)|
        result[pair.gsub("_to_", "_")] = BigDecimal.new(value.to_s)
        result
      end
    end

  end
end
