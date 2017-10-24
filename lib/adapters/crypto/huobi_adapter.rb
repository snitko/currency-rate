module CurrencyRate
  class HuobiAdapter < Adapter
    FETCH_URL = {
      "btc_cny" => "http://api.huobi.com/staticmarket/ticker_btc_json.js",
      "ltc_cny" => "http://api.huobi.com/staticmarket/ticker_ltc_json.js"
    }

    def normalize(data)
      super
      data.reduce({}) do |result, (pair, value)|
        result[pair] = BigDecimal.new(value["ticker"]["last"].to_s)
        result
      end
    end

  end
end
