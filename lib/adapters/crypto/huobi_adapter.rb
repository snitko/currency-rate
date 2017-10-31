module CurrencyRate
  class HuobiAdapter < Adapter
    FETCH_URL = {
      "BTC_CNY" => "http://api.huobi.com/staticmarket/ticker_btc_json.js",
      "LTC_CNY" => "http://api.huobi.com/staticmarket/ticker_ltc_json.js"
    }

    def normalize(data)
      return nil unless super
      data.reduce({}) do |result, (pair, value)|
        result[pair] = BigDecimal.new(value["ticker"]["last"].to_s)
        result
      end
    end

  end
end
