module CurrencyRate

  class FiatAdapter < Adapter

    BigDecimal.mode BigDecimal::ROUND_MODE, :banker
    #@@decimal_precision = 2

    def rate_for(from,to)
      super
      rate = currency_pair_rate(to,from)
      invert_rate(from,to,rate)
    end

    private

      def decimal_precision
        2
      end

  end

end
