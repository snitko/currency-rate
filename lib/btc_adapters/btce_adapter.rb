module CurrencyRate
  class BtceAdapter < BtcAdapter

    FETCH_URL = {
      'btc_usd' => 'https://btc-e.com/api/2/btc_usd/ticker',
      'btc_eur' => 'https://btc-e.com/api/2/btc_eur/ticker',
      'btc_rub' => 'https://btc-e.com/api/2/btc_rur/ticker',
      'usd_rub' => 'https://btc-e.com/api/2/usd_rur/ticker',
      'eur_rub' => 'https://btc-e.com/api/2/eur_rur/ticker'
    }
    DEFAULT_CURRENCIES   = { from: "BTC", to: "USD" }


    def rate_for(from,to)
      super
      rate = rate_to_f(currency_pair_rate(to,from))
      invert_rate(from,to,rate)
    end

    def currency_pair_rate(currency1, currency2)
      rate = @rates["#{currency1.downcase}_#{currency2.downcase}"] || @rates["#{currency2.downcase}_#{currency1.downcase}"]
      raise CurrencyNotSupported unless rate
      rate['ticker']['last']
    end

    def invert_rate(from,to,rate)
      if to == 'BTC' || (from == 'RUB' && to == 'USD') || (from == 'RUB' && to == 'EUR')
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
