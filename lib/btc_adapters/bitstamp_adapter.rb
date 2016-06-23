module CurrencyRate
  class BitstampAdapter < BtcAdapter

    FETCH_URL = {
      'btc_usd' => 'https://www.bitstamp.net/api/v2/ticker/btcusd/',
      'btc_eur' => 'https://www.bitstamp.net/api/v2/ticker/btceur/',
      'eur_usd' => 'https://www.bitstamp.net/api/v2/ticker/eurusd/'
    }

    def rate_for(from,to)
      raise CurrencyNotSupported unless ["BTC", "USD", "EUR"].include?(to) && ["BTC", "USD", "EUR"].include?(from)
      super
      rate = rate_to_f(currency_pair_rate(to,from))
      invert_rate(from,to,rate)
    end

    # Because Bitstamp has USD/EUR pair
    def invert_rate(from,to,rate)
      if to == 'BTC' || (from == 'USD' && to == 'EUR')
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

  end
end
