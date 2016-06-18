module CurrencyRate
  class KrakenAdapter < BtcAdapter

    FETCH_URL = 'https://api.kraken.com/0/public/Ticker?pair=xbtusd'

    def rate_for(to,from)
      super
      rate = get_rate_value_from_hash(@rates, 'result', 'XXBTZ' + currency_code.upcase, 'c')
      rate = rate.kind_of?(Array) ? rate.first : raise(CurrencyNotSupported)
      rate_to_f(rate)
    end

  end
end
