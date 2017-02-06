module CurrencyRate
  class CoinbaseAdapter < BtcAdapter

    FETCH_URL = 'https://coinbase.com/api/v1/currencies/exchange_rates'
    DEFAULT_CURRENCIES = ["USD", "BTC"]

    def rate_for(from,to)
      super
      rate = @rates["#{from.downcase}_to_#{to.downcase}"]
      rate_to_f(rate)
    end

    def supported_currency_pairs
      cache_supported_currency_pairs do
        @rates.each do |k,v|
          @supported_currency_pairs << k.sub("_to_", "/").upcase
        end
      end
    end

  end
end
