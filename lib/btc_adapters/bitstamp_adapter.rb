module CurrencyRate
  class BitstampAdapter < BtcAdapter

    FETCH_URL = 'https://www.bitstamp.net/api/ticker/'

    def rate_for(to,from)
      raise CurrencyNotSupported unless ["BTC", "USD", "EUR"].include?(to) && ["BTC", "USD", "EUR"].include?(from)
      super
      rate = get_rate_value_from_hash(@rates, "last")
      rate = rate_to_f(rate)
      invert_rate(to,from,rate)
    end

  end
end
