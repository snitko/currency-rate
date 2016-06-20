module CurrencyRate
  class HuobiAdapter < BtcAdapter

    FETCH_URL = {
      'btc_cny' => 'http://api.huobi.com/staticmarket/ticker_btc_json.js',
      'ltc_cny' => 'http://api.huobi.com/staticmarket/ticker_ltc_json.js'
    }

    def rate_for(from,to)
      super
      rate = rate_to_f(currency_pair_rate(to,from))
      invert_rate(from,to,rate)
    end

    def currency_pair_rate(currency1, currency2)
      rate = @rates["#{currency1.downcase}_#{currency2.downcase}"] || @rates["#{currency2.downcase}_#{currency1.downcase}"]
      raise CurrencyNotSupported unless rate
      rate["ticker"]['last']
    end

    def invert_rate(from,to,rate)
      if ['BTC', 'LTC'].include?(to)
        1/rate.to_f
      else
        rate
      end
    end

  end
end
