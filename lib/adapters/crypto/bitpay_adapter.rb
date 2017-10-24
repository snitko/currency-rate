module CurrencyRate
  class BitpayAdapter < Adapter
    FETCH_URL = "https://bitpay.com/api/rates"

    def normalize(data)
      super
      data.reject { |rate| rate["code"] == "BTC" }.reduce({}) do |result, rate|
        result["btc_#{rate['code'].downcase}"] = BigDecimal.new(rate["rate"].to_s)
        result
      end
    end

  end
end
