module CurrencyRate
  class OkcoinAdapter < Adapter
    FETCH_URL = {
      'ltc_usd' => 'https://www.okcoin.com/api/v1/ticker.do?symbol=ltc_usd',
      'btc_usd' => 'https://www.okcoin.com/api/v1/ticker.do?symbol=btc_usd',
      'ltc_cny' => 'https://www.okcoin.cn/api/ticker.do?symbol=ltc_cny',
      'btc_cny' => 'https://www.okcoin.cn/api/ticker.do?symbol=btc_cny'
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
