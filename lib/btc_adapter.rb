module CurrencyRate

  class BtcAdapter < Adapter

    def rate_for(to,from)
      super
    end

    def invert_rate(from,to,rate)
      if from == 'BTC'
        to,from     = from,to 
        invert_rate = true
        1/rate
      else
        rate
      end
    end

  end

end
