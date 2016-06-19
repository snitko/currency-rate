module CurrencyRate
  class KrakenAdapter < BtcAdapter

    FETCH_URL = {
      "usd_btc" => 'https://api.kraken.com/0/public/Ticker?pair=xbtusd',
      "eur_btc" => 'https://api.kraken.com/0/public/Ticker?pair=xbteur'
    }

    def rate_for(to,from)
      super
      rate = rate_to_f(currency_pair_rate(to,from))
      invert_rate(to,from,rate)
    end

    def currency_pair_rate(currency1, currency2)
      rate = @rates["#{currency1.downcase}_#{currency2.downcase}"] || @rates["#{currency2.downcase}_#{currency1.downcase}"]
      raise CurrencyNotSupported unless rate || [currency1, currency2].include?("BTC")
      currency = currency1 == "BTC" ? currency2 : currency1
      rate['result']["XXBTZ#{currency}"]['c'].first
    end

  end
end
