module CurrencyRate
  class BitpayAdapter < BtcAdapter

    FETCH_URL = 'https://bitpay.com/api/rates'

    def rate_for(to,from)
      super
      rate = nil
      @rates.each do |rt|
        if rt['code'] == to
          rate = invert_rate(to,from, currency_pair_rate(to,from,rt))
          return rate_to_f(rate)
        end
      end
      raise CurrencyNotSupported
    end

    def currency_pair_rate(currency1, currency2, rt)
      rate = rt['rate'] if [currency1, currency2].include?(rt['code'])
      raise CurrencyNotSupported if !rate || !([currency1, currency2].include?('BTC'))
      rate
    end

  end
end
