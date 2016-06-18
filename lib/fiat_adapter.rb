module CurrencyRate

  class FiatAdapter < Adapter

    CROSS_RATE_CURRENCY = 'USD'
    SUPPORTED_CURRENCIES = %w(
      AUD BGN BRL CAD CHF CNY CZK DKK GBP HKD HRK HUF IDR ILS INR JPY
      KRW MXN MYR NOK NZD PHP PLN RON RUB SEK SGD THB TRY USD ZAR EUR
    )
    DECIMAL_PRECISION = 2

    # Set half-even rounding mode
    # http://apidock.com/ruby/BigDecimal/mode/class
    BigDecimal.mode BigDecimal::ROUND_MODE, :banker

    def rate_for(to,from)
      return 1 if to == CROSS_RATE_CURRENCY
      raise CurrencyNotSupported unless SUPPORTED_CURRENCIES.include?(to)
      super
      # call 'super' in descendant classes and return real rate
    end

  end

end
