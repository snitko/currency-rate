module CurrencyRate
  class BitstampAdapter < Adapter
    SUPPORTED_CURRENCIES = %w(
      BCH ETH LTC XRP
    )

    ANCHOR_CURRENCY = "BTC"

    FETCH_URL = Hash[SUPPORTED_CURRENCIES.collect { |currency| [ currency, "https://www.bitstamp.net/api/v2/ticker/#{currency}#{ANCHOR_CURRENCY}/".downcase ] }]
    FETCH_URL["USD"] = "https://www.bitstamp.net/api/ticker/"

    def normalize(data)
      return nil unless super
      data.reduce({ "anchor" => ANCHOR_CURRENCY }) do |result, (key, value)|
        if key == "USD"
          result[key] =  BigDecimal.new(value["last"].to_s)
        else
          result[key] =  1 / BigDecimal.new(value["last"].to_s)
        end

        result
      end
    end

  end
end
