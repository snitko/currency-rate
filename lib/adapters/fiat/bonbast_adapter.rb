module CurrencyRate
  class BonbastAdapter < Adapter
    # No need to use it for fetching, just additional information about supported currencies
    SUPPORTED_CURRENCIES = %w(USD IRR)
    ANCHOR_CURRENCY = "USD"
    FETCH_URL = "https://www.bonbast.com/"

    def normalize(data)
      sell = data.match(/<td id="usd1"[^>]*>(\d+)<\/td>/)[1].to_f
      buy  = data.match(/<td id="usd2"[^>]*>(\d+)<\/td>/)[1].to_f
      { "anchor" => self.class::ANCHOR_CURRENCY, "IRR" => 1/BigDecimal.new(([buy, sell].reduce(:+).fdiv(2)*10).to_s) }
    end

    def request(url)

      http_client = HTTP.timeout(connect:
        CurrencyRate.configuration.connect_timeout, read:
        CurrencyRate.configuration.read_timeout
      )
      http_client.get(url).to_s

    end

  end
end
