module CurrencyRate
  class BitstampAdapter < Adapter
    USD = "usd"
    CRYPTOS = ["btc","ltc","xrp","eth"]
    FETCH_URL = Hash[CRYPTOS.collect { |crypto| [ "#{crypto}_#{USD}".upcase, "https://www.bitstamp.net/api/v2/ticker/#{crypto}#{USD}/" ] }]

    def normalize(data)
      return nil unless super
      data.reduce({}) do |result, (pair, value)|
        result[pair] = BigDecimal.new(value["last"].to_s)
        result
      end
    end

  end
end
