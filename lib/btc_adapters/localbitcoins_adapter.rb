module CurrencyRate
  class LocalbitcoinsAdapter < BtcAdapter

    FETCH_URL = 'https://localbitcoins.com/bitcoinaverage/ticker-all-currencies/'

    def rate_for(to,from)
      super
      rate = currency_pair_rate(to,from)
      rate = rate_to_f(rate)
      invert_rate(to,from,rate)
    end

    def currency_pair_rate(currency1, currency2)
      rate = @rates[currency1] || @rates[currency2]
      raise CurrencyNotSupported if !rate || !([currency1, currency2].include?('BTC'))
      rate['rates']['last']
    end

  end
end
