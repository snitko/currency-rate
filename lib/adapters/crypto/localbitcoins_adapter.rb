module CurrencyRate
  class LocalbitcoinsAdapter < Adapter
    CRYPTOS           = ["btc","ltc","xrp","eth","dash"]
    FIAT_CURRENCIES   = ["ves"]
    FIAT_ANCHOR       = ["usd"]
    CRYPTO_ANCHOR     = ["btc"]

    FETCH_URL = 'https://localbitcoins.com/bitcoinaverage/ticker-all-currencies/'

    def normalize(data)
      return nil unless super
      data.reduce({}) do |result, (fiat, value)|
        fiat = fiat.upcase

        result["BTC_#{fiat.upcase}"] = BigDecimal.new(value["rates"]["last"].to_s)

        FIAT_ANCHOR.each do |fiat_anchor|
          CRYPTO_ANCHOR.each do |crypto_anchor|
            if (crypto_anchor_fiat_anchor = result["#{crypto_anchor.upcase}_#{fiat_anchor.upcase}"]) && (crypto_anchor_fiat = result["#{crypto_anchor.upcase}_#{fiat}"])
              result["#{fiat_anchor.upcase}_#{fiat}"] = BigDecimal.new(crypto_anchor_fiat_anchor) / BigDecimal.new(crypto_anchor_fiat)
            end
          end
        end if FIAT_CURRENCIES.include?(fiat.downcase)

        result
      end
    end

  end
end
