require 'uri'

module CurrencyRate

  class YahooAdapter < FiatAdapter

    SUPPORTED_CURRENCIES = %w(
      AUD BGN BRL CAD CHF CNY CZK DKK GBP HKD HRK HUF IDR ILS INR JPY
      KRW MXN MYR NOK NZD PHP PLN RON RUB SEK SGD THB TRY USD ZAR EUR
    )

    CROSS_RATE_CURRENCY = 'USD'

    # Example URL (follow to un-shorten): http://goo.gl/62Aedt
    FETCH_URL = "http://query.yahooapis.com/v1/public/yql?" + URI.encode_www_form(
      format: 'json',
      env: "store://datatables.org/alltableswithkeys",
      q: "SELECT * FROM yahoo.finance.xchange WHERE pair IN" +
        # The following line is building array string in SQL: '("USDJPY", "USDRUB", ...)'
        "(#{SUPPORTED_CURRENCIES.map{|x| '"' + CROSS_RATE_CURRENCY + x.upcase + '"'}.join(',')})"
    )

    def invert_rate(from,to,rate)
      if to == 'USD'
        _invert_rate(rate)
      else
        rate
      end
    end

    def currency_pair_rate(currency1, currency2)
      rates = @rates.deep_get('query', 'results', 'rate')
      rate = if CROSS_RATE_CURRENCY == currency1.upcase
        rates.find { |x| x['id'] == "#{CROSS_RATE_CURRENCY}#{currency2.upcase}" }
      else
        rates.find { |x| x['id'] == "#{CROSS_RATE_CURRENCY}#{currency1.upcase}" }
      end
      raise CurrencyNotSupported unless rate
      rate = BigDecimal.new(rate['Rate'])
      rate.round(decimal_precision)
    end

  end
end
