module CurrencyRate
  class BTCChinaAdapter < BtcAdapter

    FETCH_URL = 'https://data.btcchina.com/data/ticker'

    def rate_for(from,to)
      super
      raise raise CurrencyNotSupported unless [from,to].include?('CNY')
      rate = rate_to_f(@rates['ticker'] && @rates['ticker']['last'])
      invert_rate(from,to,rate)
    end

  end
end
