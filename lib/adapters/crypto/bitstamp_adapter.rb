module CurrencyRate
  class BitstampAdapter < Adapter
    SUPPORTED_CURRENCIES = %w(
      BCH BTC ETH EUR LTC XRP
    )

    ANCHOR_CURRENCY = "USD"

    FETCH_URL = Hash[SUPPORTED_CURRENCIES.collect { |currency| [ currency, "https://www.bitstamp.net/api/v2/ticker/#{currency}usd/".downcase ] }]

    def normalize(data)
      return nil unless super
      data.reduce({ "anchor" => ANCHOR_CURRENCY, ANCHOR_CURRENCY => BigDecimal.new("1") }) do |result, (key, value)|
        result[key] =  1 / BigDecimal.new(value["last"].to_s)
        result
      end
    end

  end
end
