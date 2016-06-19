module CurrencyRate

  class FiatAdapter < Adapter

    def rate_for(to,from)
      super
      rate = rate_to_f(currency_pair_rate(to,from))
      invert_rate(to,from,rate)
    end

  end

end
