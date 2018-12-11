module CurrencyRate
  class FixerAdapter < Adapter
    # EUR is the only currency available as a base on free plan
    ANCHOR_CURRENCY = "EUR"
    FETCH_URL = "http://data.fixer.io/latest"
    API_KEY_PARAM = "access_key"

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
