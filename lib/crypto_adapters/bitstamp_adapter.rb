module CurrencyRate
  class BitstampAdapter < CryptoAdapter

    FETCH_URL = {
      'btc_usd' => 'https://www.bitstamp.net/api/v2/ticker/btcusd/',
      'btc_eur' => 'https://www.bitstamp.net/api/v2/ticker/btceur/',
      'eur_usd' => 'https://www.bitstamp.net/api/v2/ticker/eurusd/'
    }
    DEFAULT_CURRENCIES = ["USD", "BTC"]
    SUPPORTED_CRYPTO_CURRENCIES = ["BTC"]

    def rate_for(from,to)
      super
      rate = rate_to_f(currency_pair_rate(to,from))
      invert_rate(from,to,rate)
    end

    # Because Bitstamp has USD/EUR pair
    def invert_rate(from,to,rate)
      if self.class::SUPPORTED_CRYPTO_CURRENCIES.include?(to) || (from == 'USD' && to == 'EUR')
        _invert_rate(rate)
      else
        rate
      end
    end

    def currency_pair_rate(currency1, currency2)
      rate = @rates["#{currency1.downcase}_#{currency2.downcase}"] || @rates["#{currency2.downcase}_#{currency1.downcase}"]
      raise CurrencyNotSupported unless rate
      rate['last']
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
