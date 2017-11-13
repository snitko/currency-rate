module CurrencyRate
  class CurrencyLayerAdapter < Adapter
    # No need to use it for fetching, just additional information about supported currencies
    SUPPORTED_CURRENCIES = %w(AED AFN ALL AMD ANG AOA ARS AUD AWG AZN BAM BBD BDT BGN
                              BHD BIF BMD BND BOB BRL BSD BTC BTN BWP BYN BYR BZD CAD
                              CDF CHF CLF CLP CNY COP CRC CUC CUP CVE CZK DJF DKK DOP
                              DZD EGP ERN ETB EUR FJD FKP GBP GEL GGP GHS GIP GMD GNF
                              GTQ GYD HKD HNL HRK HTG HUF IDR ILS IMP INR IQD IRR ISK
                              JEP JMD JOD JPY KES KGS KHR KMF KPW KRW KWD KYD KZT LAK
                              LBP LKR LRD LSL LTL LVL LYD MAD MDL MGA MKD MMK MNT MOP
                              MRO MUR MVR MWK MXN MYR MZN NAD NGN NIO NOK NPR NZD OMR
                              PAB PEN PGK PHP PKR PLN PYG QAR RON RSD RUB RWF SAR SBD
                              SCR SDG SEK SGD SHP SLL SOS SRD STD SVC SYP SZL THB TJS
                              TMT TND TOP TRY TTD TWD TZS UAH UGX USD UYU UZS VEF VND
                              VUV WST XAF XAG XAU XCD XDR XOF XPF YER ZAR ZMK ZMW ZWL)

    ANCHOR_CURRENCY = "USD"
    FETCH_URL = "http://www.apilayer.net/api/live"
    API_KEY_PARAM = "access_key"

    def normalize(data)
      return nil unless super
      rates = { "anchor" => self.class::ANCHOR_CURRENCY }
      data["quotes"].each do |key, value|
        rates[key.sub(self.class::ANCHOR_CURRENCY, "")] = BigDecimal.new(value.to_s)
      end
      rates
    end
  end
end
