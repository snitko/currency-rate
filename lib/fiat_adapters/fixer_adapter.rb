module CurrencyRate
  class FixerAdapter < FiatAdapter
    FETCH_URL = "http://api.fixer.io/latest?base=#{CROSS_RATE_CURRENCY}"

    def rate_for(to,from)
      super
      rate = get_rate_value_from_hash(@rates, 'rates', currency_code)
      rate_to_f(rate)
    end
  end
end
