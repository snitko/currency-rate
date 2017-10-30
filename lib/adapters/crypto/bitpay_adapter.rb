module CurrencyRate
  class BitpayAdapter < Adapter
    FETCH_URL = "https://bitpay.com/api/rates"

    def normalize(data)
      return nil unless super
      data.reject { |rate| rate["code"] == "BTC" }.reduce({}) do |result, rate|
        result["BTC_#{rate['code'].upcase}"] = BigDecimal.new(rate["rate"].to_s)
        result
      end
    end

  end
end
