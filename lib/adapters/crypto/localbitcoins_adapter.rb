module CurrencyRate
  class LocalbitcoinsAdapter < Adapter
    CRYPTOS = %w[
                  btc dash eth ltc xrp
                ]

    FETCH_URL = 'https://localbitcoins.com/bitcoinaverage/ticker-all-currencies/'

    def normalize(data)
      return nil unless super
      data.reduce({}) do |result, (fiat, value)|
        result["BTC_#{fiat.upcase}"] = BigDecimal.new(value["rates"]["last"].to_s)
        result
      end
    end

  end
end
