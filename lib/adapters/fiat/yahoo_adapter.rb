module CurrencyRate
  class YahooAdapter < Adapter
    SUPPORTED_CURRENCIES = %w(
      AED AFN ALL AMD ANG AOA ARS AUD AWG AZN BAM BBD BDT BGN BHD BIF BMD BND
      BRL BSD BTN BWP BYR BZD CAD CHF CLF CLP CNY COP CRC CUC CUP CVE CZK DEM
      DJF DKK DOP DZD ECS EGP ERN ETB EUR FJD FKP FRF GBP GEL GHS GIP GMD GNF
      GTQ GYD HKD HNL HRK HTG HUF IDR IEP ILS INR IQD ISK ITL JMD JOD JPY KES
      KGS KHR KMF KWD KYD KZT LAK LBP LKR LRD LSL LTL LVL LYD MAD MGA MMK MNT
      MOP MRO MUR MVR MWK MXN MXV MYR MZN NAD NGN NIO NOK NPR NZD OMR PAB PEN
      PGK PHP PKR PLN PYG QAR RON RSD RUB RWF SAR SBD SCR SDG SEK SGD SLL SOS
      SRD STD SVC SYP SZL THB TJS TMT TND TOP TRY TTD UAH UGX USD UYU UZS VND
      VUV WST XAF XAG XAU XCD XDR XOF XPD XPF XPT YER ZAR ZMW ZWL
    )

    ANCHOR_CURRENCY = "USD"

    FETCH_URL = "http://query.yahooapis.com/v1/public/yql?" + URI.encode_www_form(
      format: 'json',
      env: "store://datatables.org/alltableswithkeys",
      q: "SELECT * FROM yahoo.finance.xchange WHERE pair IN" +
        # The following line is building array string in SQL: '("USDJPY", "USDRUB", ...)'
        "(#{SUPPORTED_CURRENCIES.map{|x| '"' + ANCHOR_CURRENCY + x.upcase + '"'}.join(',')})"
    )

    def normalize(data)
      return nil unless super
      rates = { "anchor" => self.class::ANCHOR_CURRENCY }
      data["query"]["results"]["rate"].each do |rate|
        rates[rate["Name"].split("/")[1]] = BigDecimal.new(rate["Rate"].to_s)
      end
      rates
    end

  end
end
