module CurrencyRate
  class ForgeAdapter < Adapter
    SUPPORTED_CURRENCIES = %w(
      JPY CHF CAD SEK NOK MXN ZAR TRY CNH EUR GBP AUD NZD XAU XAG
    )

    ANCHOR_CURRENCY = "USD"
    FETCH_URL = "https://forex.1forge.com/1.0.2/quotes?pairs=" + SUPPORTED_CURRENCIES.map { |c| "#{ANCHOR_CURRENCY}#{c}" }.join(",")
    API_KEY_PARAM = "api_key"

    def normalize(data)
      return nil unless super
      rates = { "anchor" => self.class::ANCHOR_CURRENCY }
      data.each do |rate|
        if rate["error"]
          CurrencyRate.logger.error("Forge exchange returned error")
          return nil
        end
        rates[rate["symbol"].sub(self.class::ANCHOR_CURRENCY, "")] = BigDecimal.new(rate["price"].to_s)
      end
      rates
    end

  end
end
