module CurrencyRate
  class LocalbitcoinsAdapter < Adapter
    FETCH_URL = 'https://localbitcoins.com/bitcoinaverage/ticker-all-currencies/'

    def normalize(data)
      super
      data.reduce({}) do |result, (fiat, value)|
        result["btc_#{fiat.downcase}"] = BigDecimal.new(value["rates"]["last"].to_s)
        result
      end
    end

  end
end
