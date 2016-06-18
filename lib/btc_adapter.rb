module CurrencyRate

  class BtcAdapter < Adapter

    def rate_for(to,from)
      super
    end

    def invert_rate(to,from,rate)
      to == 'BTC' ? 1/rate.to_f : rate
    end

  end

end
