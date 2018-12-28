module CurrencyRate
  class LocalbitcoinsAdapter < Adapter
    # No need to use it for fetching, just additional information about supported currencies
    SUPPORTED_CURRENCIES = %w(
      AED AOA ARS AUD BDT BRL BYN CAD CHF CLP CNY COP CRC CZK DKK DOP EGP ETH
      EUR GBP GEL GHS HKD HUF IDR ILS INR IRR JOD JPY KES KRW KWD KZT LKR LTC
      MAD MWK MXN MYR NGN NOK NZD OMR PAB PEN PHP PKR PLN QAR RON RSD RUB RWF
      SAR SEK SGD SZL THB TRY TWD TZS UAH UGX USD UYU VES VND XAF XMR XOF XRP
      ZAR ZMW
    )

    ANCHOR_CURRENCY = "BTC"

    FETCH_URL = 'https://localbitcoins.com/bitcoinaverage/ticker-all-currencies/'

    def normalize(data)
      return nil unless super
      data.reduce({ "anchor" => ANCHOR_CURRENCY }) do |result, (fiat, value)|
        result["#{fiat.upcase}"] = BigDecimal.new(value["rates"]["last"].to_s)
        result
      end
    end

  end
end
