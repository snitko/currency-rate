module CurrencyRate
  class BTCChinaAdapter < BtcAdapter

    FETCH_URL = 'https://data.btcchina.com/data/ticker'
    DEFAULT_CURRENCIES   = { from: "BTC", to: "CNY" }

    def rate_for(from,to)
      super
      rate = rate_to_f(@rates['ticker'] && @rates['ticker']['last'])
      invert_rate(from,to,rate)
    end

    def supported_currency_pairs
      ["BTC/CNY"]
    end

  end
end
