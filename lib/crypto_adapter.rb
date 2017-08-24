module CurrencyRate

  class CryptoAdapter < Adapter

    SUPPORTED_CRYPTO_CURRENCIES = []

    DECIMAL_PRECISION = 9

    def rate_for(from,to)
      super
    end

    def invert_rate(from,to,rate)
      self.class::SUPPORTED_CRYPTO_CURRENCIES.include?(to) ? _invert_rate(rate) : rate
    end

  end

end
