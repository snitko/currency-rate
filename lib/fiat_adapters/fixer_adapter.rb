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
      BigDecimal.new(rate.to_s).round(decimal_precision)
    end

    def invert_rate(from,to,rate)
      if (to == 'USD' || to == 'EUR')
        _invert_rate(rate)
      else
        rate
      end
    end

    def supported_currency_pairs
      cache_supported_currency_pairs do
        @rates.each do |base_name, content|
          currency1 = content["base"]
          content["rates"].each do |currency2, rate|
            @supported_currency_pairs << "#{currency1}/#{currency2}"
          end
        end
      end
    end

  end
end
