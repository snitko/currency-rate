module CurrencyRate
  class FixerAdapter < Adapter
    ANCHOR_CURRENCY = "USD"
    FETCH_URL = "http://api.fixer.io/latest?base=usd"

    def normalize(data)
      return nil unless super
      rates = { "anchor" => ANCHOR_CURRENCY }
      data["rates"].each do |k, v|
        rates[k] = BigDecimal.new(v.to_s)
      end
      rates
    end

  end
end
