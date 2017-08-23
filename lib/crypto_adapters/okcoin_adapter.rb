module CurrencyRate
  class OkcoinAdapter < CryptoAdapter

    FETCH_URL = {
      'ltc_usd' => 'https://www.okcoin.com/api/v1/ticker.do?symbol=ltc_usd',
      'btc_usd' => 'https://www.okcoin.com/api/v1/ticker.do?symbol=btc_usd',
      'ltc_cny' => 'https://www.okcoin.cn/api/ticker.do?symbol=ltc_cny',
      'btc_cny' => 'https://www.okcoin.cn/api/ticker.do?symbol=btc_cny'
    }
    DEFAULT_CURRENCIES = ["CNY", "BTC"]
    SUPPORTED_CRYPTO_CURRENCIES = ["BTC", "LTC"]

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

    # Because OKCoin has LTC
    def invert_rate(from,to,rate)
      if self.class::SUPPORTED_CRYPTO_CURRENCIES.include?(to)
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
