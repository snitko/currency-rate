module CurrencyRate
  class FreeForexAdapter < Adapter
    # No need to use it for fetching, just additional information about supported currencies
    SUPPORTED_CURRENCIES = %w(AED AFN ALL AMD ANG AOA ARS ATS AUD AWG AZM AZN BAM BBD BDT BEF
                              BGN BHD BIF BMD BND BOB BRL BSD BTN BWP BYN BYR BZD CAD CDF CLP
                              CNH CNY COP CRC CUC CUP CVE CYP CZK DEM DJF DKK DOP DZD EEK EGP
                              ERN ESP ETB EUR FIM FJD FKP FRF GBP GEL GGP GHC GHS GIP GMD GNF
                              GRD GTQ GYD HKD HNL HRK HTG HUF IDR IEP ILS IMP INR IQD IRR ISK
                              ITL JEP JMD JOD KES KGS KHR KMF KPW KRW KWD KYD KZT LAK LBP LKR
                              LRD LSL LTL LUF LVL LYD MAD MDL MGA MGF MKD MMK MNT MOP MRO MRU
                              MTL MUR MVR MWK MXN MYR MZM MZN NAD NGN NIO NLG NOK NPR NZD OMR
                              PAB PEN PGK PHP PKR PLN PTE PYG QAR ROL RON RSD RUB RWF SAR SBD
                              SCR SDD SDG SEK SGD SHP SIT SKK SLL SOS SPL SRD SRG STD STN SVC
                              SYP SZL THB TJS TMM TMT TND TOP TRL TRY TTD TVD TWD TZS UAH UGX
                              UYU UZS VAL VEB VEF VES VND VUV WST XAF XAG XAU XBT XCD XDR XOF
                              XPD XPF XPT YER ZAR ZMK ZMW ZWD)

    ANCHOR_CURRENCY = "USD"
    FETCH_URL = "https://www.freeforexapi.com/api/live?pairs=" + SUPPORTED_CURRENCIES.map{|cur| "USD#{cur}"}.join(",")

    def normalize(data)
      return nil unless super
      rates = { "anchor" => self.class::ANCHOR_CURRENCY }
      data["rates"].each do |pair, payload|
        rates[pair.sub(self.class::ANCHOR_CURRENCY, "")] = BigDecimal.new(payload["rate"].to_s)
      end
      rates
    end
  end
end