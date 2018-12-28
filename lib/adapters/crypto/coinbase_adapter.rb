module CurrencyRate
  class CoinbaseAdapter < Adapter
    # No need to use it for fetching, just additional information about supported currencies
    SUPPORTED_CURRENCIES = %w(
      AED AFN ALL AMD ANG AOA ARS AUD AWG AZN BAM BAT BBD BCH BDT BGN BHD BIF BMD
      BND BOB BRL BSD BTC BTN BWP BYN BYR BZD CAD CDF CHF CLF CLP CNH CNY COP CRC
      CUC CVE CZK DJF DKK DOP DZD EEK EGP ERN ETB ETC ETH EUR FJD FKP GBP GEL GGP
      GHS GIP GMD GNF GTQ GYD HKD HNL HRK HTG HUF IDR ILS IMP INR IQD ISK JEP JMD
      JOD JPY KES KGS KHR KMF KRW KWD KYD KZT LAK LBP LKR LRD LSL LTC LTL LVL LYD
      MAD MDL MGA MKD MMK MNT MOP MRO MTL MUR MVR MWK MXN MYR MZN NAD NGN NIO NOK
      NPR NZD OMR PAB PEN PGK PHP PKR PLN PYG QAR RON RSD RUB RWF SAR SBD SCR SEK
      SGD SHP SLL SOS SRD SSP STD SVC SZL THB TJS TMT TND TOP TRY TTD TWD TZS UAH
      UGX USD SDC UYU UZS VEF VND VUV WST XAF XAG XAU XCD XDR XOF XPD XPF XPT YER
      ZAR ZEC ZMK ZMW ZRX ZWL
    )

    ANCHOR_CURRENCY = "BTC"

    FETCH_URL = "https://api.coinbase.com/v2/exchange-rates?currency=#{ANCHOR_CURRENCY}"

    def normalize(response)
      return nil unless super
      response["data"]["rates"].reduce({ "anchor" => ANCHOR_CURRENCY }) do |result, (currency, rate)|
        result[currency] = BigDecimal.new(rate.to_s)
        result
      end
    end

  end
end
