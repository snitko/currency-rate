module CurrencyRate
  class KrakenAdapter < CryptoAdapter

    FETCH_URL = {
      "usd_btc" => 'https://api.kraken.com/0/public/Ticker?pair=xbtusd',
      "eur_btc" => 'https://api.kraken.com/0/public/Ticker?pair=xbteur',
      "usd_ltc" => 'https://api.kraken.com/0/public/Ticker?pair=ltcusd',
      "eur_ltc" => 'https://api.kraken.com/0/public/Ticker?pair=ltceur',
    }
    DEFAULT_CURRENCIES = ["USD", "BTC"]
    SUPPORTED_CRYPTO_CURRENCIES = ["BTC", "LTC"]
    ASSET_MAP = {
      "BTC" => "XBT",
    }

    def rate_for(to,from)
      super
      rate = rate_to_f(currency_pair_rate(to,from))
      invert_rate(to,from,rate)
    end

    def currency_pair_rate(currency1, currency2)
      rate = @rates["#{currency1.downcase}_#{currency2.downcase}"] || @rates["#{currency2.downcase}_#{currency1.downcase}"]
      raise CurrencyNotSupported unless rate || ([currency1, currency2] & self.class::SUPPORTED_CRYPTO_CURRENCIES).any?
      fiat, crypto = self.class::SUPPORTED_CRYPTO_CURRENCIES.include?(currency1) ? [currency2, currency1] : [currency1, currency2]
      rate['result']["X#{ta(crypto)}Z#{ta(fiat)}"]['c'].first
    end

    def supported_currency_pairs
      cache_supported_currency_pairs do
        @rates.each do |k,v|
          @supported_currency_pairs << k.sub("_", "/").upcase
        end
      end
    end

    def translate_asset(asset)
      ASSET_MAP[asset] || asset
    end
    alias_method :ta, :translate_asset
  end
end
