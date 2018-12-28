module CurrencyRate
  class Fetcher
    attr_accessor :storage
    attr_accessor :fiat_exchanges

    def initialize(fiat_exchanges: nil, storage: nil)
      @storage = storage || FileStorage.new
      @fiat_exchanges = fiat_exchanges || ["Yahoo", "Fixer", "Forge"]
    end

    def fetch_crypto(exchange, from, to)
      from = from.strip.upcase
      to = to.strip.upcase
      rates = @storage.read(exchange)

      if rates.nil?
        CurrencyRate.logger.warn("Fetcher#fetch_crypto: rates for #{exchange} not found in storage <#{@storage.class.name}>")
        return nil
      end

      rate = calculate_rate(rates, from, to)
      return rate unless rate.nil?

      if to != "USD"
        usd_fiat = fetch_fiat("USD", to)
        return BigDecimal.new(rates["USD"] * usd_fiat) if usd_fiat && rates["USD"]
      end
    end

    def fetch_fiat(from, to)
      from = from.strip.upcase
      to = to.strip.upcase

      @fiat_exchanges.each do |exchange|
        rates = @storage.read(exchange)
        next if rates.nil?

        rate = calculate_rate(rates, from, to)
        return rate unless rate.nil?
      end
    end

    private

      def calculate_rate(rates, from, to)
        anchor = rates.delete("anchor")

        return BigDecimal.new(rates[to]) if anchor == from && rates[to]
        return BigDecimal.new(1 / rates[from]) if anchor == to && rates[from]
        return BigDecimal.new(rates[to] / rates[from]) if rates[from] && rates[to]

        CurrencyRate.logger.warn("Fetcher: rate for #{from}_#{to} not found.")
        nil
      end

  end
end

