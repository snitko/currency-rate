module CurrencyRate
  class BitpayAdapter < BtcAdapter

    FETCH_URL = 'https://bitpay.com/api/rates'
    DEFAULT_CURRENCIES   = { from: "BTC", to: "USD" }

    def rate_for(from,to)
      super
      rate = nil
      @rates.each do |rt|
        if rt['code'] == to
          rate = invert_rate(from,to, currency_pair_rate(to,from,rt))
          return rate_to_f(rate)
        end
      end
    end

    def currency_pair_rate(currency1, currency2, rt)
      rate = rt['rate'] if [currency1, currency2].include?(rt['code'])
      rate
    end

    def supported_currency_pairs
      cache_supported_currency_pairs do
        @rates.each do |r|
          @supported_currency_pairs << "#{r["code"]}/BTC"
        end
      end
    end

  end
end
