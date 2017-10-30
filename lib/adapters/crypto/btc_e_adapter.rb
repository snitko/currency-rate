module CurrencyRate
  class BtcEAdapter < Adapter
    FETCH_URL = {
      'BTC_USD' => 'https://wex.nz/api/2/btc_usd/ticker',
      'BTC_EUR' => 'https://wex.nz/api/2/btc_eur/ticker',
      'BTC_RUB' => 'https://wex.nz/api/2/btc_rur/ticker',
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
