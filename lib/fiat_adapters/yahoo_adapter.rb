require 'uri'

module CurrencyRate

  class YahooAdapter < FiatAdapter

    SUPPORTED_CURRENCIES = %w(
      AFN EUR ALL DZD USD AOA XCD ARS AMD AWG AUD AZN BSD BHD BDT BBD BYR BZD XOF BMD BTN INR BAM BWP NOK BRL BND BGN BIF KHR XAF CAD CVE KYD CLF CLP CNY COP KMF NZD CRC HRK CUC CUP ANG CZK DKK DJF DOP EGP SVC ERN ETB FKP FJD XPF GMD GEL GHS GIP GTQ GBP GNF GYD HTG HNL HKD HUF ISK IDR XDR IQD ILS JMD JPY JOD KZT KES KWD KGS LAK LBP LSL ZAR LRD LYD CHF LTL MOP MGA MWK MYR MVR MRO MUR MXN MXV MNT MAD MZN MMK NAD NPR NIO NGN OMR PKR PAB PGK PYG PEN PHP PLN QAR RON RUB RWF WST STD SAR RSD SCR SLL SGD SBD SOS LKR SDG SRD SZL SEK SYP TJS THB TOP TTD TND TRY TMT UGX UAH AED UYU UZS VUV VND YER ZMW ZWL XAU XPD XPT XAG FRF CYP ECS DEM ITL IEP LVL
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
      rate.round(self.class::DECIMAL_PRECISION)
    end

    def supported_currency_pairs
      cache_supported_currency_pairs do
        @rates["query"]["results"]["rate"].each do |r|
          @supported_currency_pairs << r["Name"]
        end
      end
    end

  end
end
