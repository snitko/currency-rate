module CurrencyRate
  class CoinbaseAdapter < Adapter
    CRYPTOS = %w[
                  btc etc eth ltc
                ]

    FETCH_URL = "https://api.coinbase.com/v2/exchange-rates?currency=BTC"

    def normalize(response)
      return nil unless super
      data = response["data"]
      result = {}

      data["rates"].each do |currency, rate|
        result["BTC_#{currency}"] = BigDecimal.new(rate.to_s)
      end

      result
    end

  end
end
