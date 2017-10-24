module CurrencyRate
  class BTCChinaAdapter < Adapter
    FETCH_URL = 'https://data.btcchina.com/data/ticker'

    def normalize(data)
      super
      { "btc_cny" => BigDecimal.new(data["ticker"]["last"].to_s) }
    end

  end
end
