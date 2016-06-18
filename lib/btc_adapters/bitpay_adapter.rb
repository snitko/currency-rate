module CurrencyRate
  class BitpayAdapter < BtcAdapter

    FETCH_URL = 'https://bitpay.com/api/rates'

    def rate_for(to,from)
      raise CurrencyNotSupported unless from == 'BTC'
      super
      @rates.each do |rt|
        if rt['code'] == to
          rate = get_rate_value_from_hash(rt, 'rate')
          return rate_to_f(rate)
        end
      end
      raise CurrencyNotSupported
    end

  end
end
