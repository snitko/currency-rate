module CurrencyRate
  class BitfinexAdapter < BtcAdapter

    FETCH_URL = {
      'btc_usd' => 'https://api.bitfinex.com/v1/pubticker/btcusd',
      'ltc_usd' => 'https://api.bitfinex.com/v1/pubticker/ltcusd'
    }
    DEFAULT_CURRENCIES = ["USD", "BTC"]

    def rate_for(from,to)
      super
      rate = rate_to_f(currency_pair_rate(to,from))
      invert_rate(from,to,rate)
    end

    def currency_pair_rate(currency1, currency2)
      rate = @rates["#{currency1.downcase}_#{currency2.downcase}"] || @rates["#{currency2.downcase}_#{currency1.downcase}"]
      raise CurrencyNotSupported unless rate
      rate['last_price']
    end

    def invert_rate(from,to,rate)
      if ['BTC', 'LTC'].include?(to)
        _invert_rate(rate)
      else
        rate
      end
    end

    def supported_currency_pairs
      cache_supported_currency_pairs do
        @rates.each do |k,v|
          @supported_currency_pairs << k.sub("_", "/").upcase
        end
      end
    end

  end
end
