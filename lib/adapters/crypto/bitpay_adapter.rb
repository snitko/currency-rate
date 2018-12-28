module CurrencyRate
  class BitpayAdapter < Adapter
    # No need to use it for fetching, just additional information about supported currencies
    SUPPORTED_CURRENCIES = %w(
      AED AFN ALL AMD ANG AOA ARS AUD AWG AZN BAM BBD BCH BDT BGN BHD BIF BMD
      BND BOB BRL BSD BTN BWP BZD CAD CDF CHF CLF CLP CNY COP CRC CUP CVE CZK
      DJF DKK DOP DZD EGP ETB EUR FJD FKP GBP GEL GHS GIP GMD GNF GTQ GUSD GYD
      HKD HNL HRK HTG HUF IDR ILS INR IQD IRR ISK JEP JMD JOD JPY KES KGS KHR
      KMF KPW KRW KWD KYD KZT LAK LBP LKR LRD LSL LYD MAD MDL MGA MKD MMK MNT
      MOP MRU MUR MVR MWK MXN MYR MZN NAD NGN NIO NOK NPR NZD OMR PAB PAX PEN
      PGK PHP PKR PLN PYG QAR RON RSD RUB RWF SAR SBD SCR SDG SEK SGD SHP SLL
      SOS SRD STN SVC SYP SZL THB TJS TMT TND TOP TRY TTD TWD TZS UAH UGX USD
      USDC UYU UZS VEF VES VND VUV WST XAF XAG XAU XCD XOF XPF YER ZAR ZMW ZWL
    )

    ANCHOR_CURRENCY = "BTC"

    FETCH_URL = "https://bitpay.com/api/rates"

    def normalize(data)
      return nil unless super
      data.reject { |rate| rate["code"] == ANCHOR_CURRENCY }.reduce({ "anchor" => ANCHOR_CURRENCY }) do |result, rate|
        result["#{rate['code'].upcase}"] = BigDecimal.new(rate["rate"].to_s)
        result
      end
    end

  end
end
