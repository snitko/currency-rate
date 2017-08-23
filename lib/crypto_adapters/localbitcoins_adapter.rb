module CurrencyRate
  class LocalbitcoinsAdapter < CryptoAdapter

    FETCH_URL = 'https://localbitcoins.com/bitcoinaverage/ticker-all-currencies/'
    DEFAULT_CURRENCIES = ["USD", "BTC"]
    SUPPORTED_CRYPTO_CURRENCIES = ["BTC"]

    def rate_for(from,to)
      super
      rate = currency_pair_rate(to,from)
      rate = rate_to_f(rate)
      invert_rate(from,to,rate)
    end

    def currency_pair_rate(currency1, currency2)
      rate = @rates[currency1] || @rates[currency2]
      raise CurrencyNotSupported if !rate || !([currency1, currency2] & self.class::SUPPORTED_CRYPTO_CURRENCIES).any?
      rate['rates']['last']
    end

    def supported_currency_pairs
      cache_supported_currency_pairs do
        @rates.each do |k,v|
          @supported_currency_pairs << "#{k}/BTC"
        end
      end
    end

  end
end
