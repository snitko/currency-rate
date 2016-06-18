module CurrencyRate
  class CoinbaseAdapter < BtcAdapter

    FETCH_URL = 'https://coinbase.com/api/v1/currencies/exchange_rates'

    def rate_for(to,from)
      super
      rate = @rates["#{from.downcase}_to_#{to.downcase}"]
      rate_to_f(rate)
    end

  end
end
