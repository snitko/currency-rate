module CurrencyRate

  class FiatAdapter < Adapter

    BigDecimal.mode BigDecimal::ROUND_MODE, :banker
    DECIMAL_PRECISION = 2

    def rate_for(to,from)
      super
      rate = currency_pair_rate(to,from)
      invert_rate(to,from,rate)
    end

  end

end
