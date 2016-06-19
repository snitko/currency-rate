module CurrencyRate

  class BtcAdapter < Adapter

    def rate_for(from,to)
      super
    end

    def invert_rate(from,to,rate)
      to == 'BTC' ? 1/rate.to_f : rate
    end

  end

end
