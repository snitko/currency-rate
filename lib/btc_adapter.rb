module CurrencyRate

  class BtcAdapter < Adapter

    def rate_for(from,to)
      super
    end

    def invert_rate(from,to,rate)
      to == 'BTC' ? _invert_rate(rate) : rate
    end

    private

      def decimal_precision
        9
      end

  end

end
