module CurrencyRate
  class BtcChinaAdapter < Adapter
    FETCH_URL = 'https://data.btcchina.com/data/ticker'

    def normalize(data)
      return nil unless super
      { "BTC_CNY" => BigDecimal.new(data["ticker"]["last"].to_s) }
    end

  end
end
