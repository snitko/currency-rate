module CurrencyRate
  class OkcoinAdapter < BtcAdapter

    FETCH_URL = {
      'ltc_usd' => 'https://www.okcoin.com/api/v1/ticker.do?symbol=ltc_usd',
      'btc_usd' => 'https://www.okcoin.com/api/v1/ticker.do?symbol=btc_usd',
      'ltc_cny' => 'https://www.okcoin.cn/api/ticker.do?symbol=ltc_cny',
      'btc_cny' => 'https://www.okcoin.cn/api/ticker.do?symbol=btc_cny'
    }

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
      if ['BTC', 'LTC'].include?(to)
        _invert_rate(rate)
      else
        rate
      end
    end

  end
end
