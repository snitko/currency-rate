module CurrencyRate
  class FixerAdapter < FiatAdapter

    FETCH_URL = {
      "eur" => "http://api.fixer.io/latest?base=eur",
      "usd" => "http://api.fixer.io/latest?base=usd"
    }

    def currency_pair_rate(currency1, currency2)
      rates = @rates[currency1.downcase] || @rates[currency2.downcase]
      raise CurrencyNotSupported unless rates
      rate = rates["rates"][currency1] || rates["rates"][currency2]
      raise CurrencyNotSupported unless rate
      rate.round(DECIMAL_PRECISION)
    end

    def invert_rate(from,to,rate)
      if (to == 'USD' || to == 'EUR')
        (1/rate.to_f).round(DECIMAL_PRECISION)
      else
        rate
      end
    end

  end
end
