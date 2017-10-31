module CurrencyRate
  class Fetcher
    attr_accessor :storage
    attr_accessor :fiat_exchanges

    def initialize(storage: nil)
      @storage = storage || FileStorage.new
      @fiat_exchanges = ["Yahoo", "Fixer", "Forge"]
    end

    def fetch_crypto(exchange, from, to)
      crypto = from.upcase
      fiat = to.upcase
      pair = "#{from}_#{to}"
      rates = @storage.read(exchange)

      if rates.nil?
        CurrencyRate.logger.warn("Fetcher#fetch_crypto: rates for #{exchange} not found in storage <#{@storage.class.name}>")
        return nil
      end
      return BigDecimal.new(rates[pair]) if rates[pair]

      supported_crypto, supported_fiat = rates.keys.reduce([[], []]) do |result, rate|
        c, f = rate.split("_")
        result[0] << c
        result[1] << f
        result
      end.map { |x| x.uniq }

      unless supported_crypto.include?(crypto)
        CurrencyRate.logger.warn("Fetcher#fetch_crypto: #{exchange} doesn't support #{crypto}")
        return nil
      end

      # If requested pair not found and exchange supports requested cryptocurrency
      # then we can convert using another supported fiat currency as an anchor
      # USD has first priority since it's the most popular world currency
      if fiat != "USD" && supported_fiat.delete("USD")
        usd_fiat = fetch_fiat("USD", fiat)
        return BigDecimal.new(rates["#{crypto}_USD"]) * BigDecimal.new(usd_fiat) if usd_fiat
      end

      # We don't have usd_fiat pair so try other supported currencies as convertation anchor
      supported_fiat.each do |anchor|
        anchor_fiat = fetch_fiat(anchor, fiat)
        return BigDecimal.new(rates["#{crypto}_#{anchor}"]) * BigDecimal.new(anchor_fiat) if anchor_fiat
      end

      # We didn't find a way to fetch rate for requested pair
      CurrencyRate.logger.warn("Fetcher#fetch_crypto: cannot fetch #{from}_#{to} from #{exchange}")
      nil
    end

    def fetch_fiat(from, to)
      @fiat_exchanges.each do |exchange|
        left = from.upcase
        right = to.upcase
        rates = @storage.read(exchange)
        next if rates.nil?
        anchor = rates.delete("anchor")
        return BigDecimal.new(rates[right]) if anchor == left && rates[right]
        return BigDecimal.new(1) / BigDecimal.new(rates[left]) if anchor == right && rates[left]
        return BigDecimal.new(rates[left]) / BigDecimal.new(rates[right]) if rates[left] && rates[right]
      end
      CurrencyRate.logger.warn("Fetcher#fetch_fiat: rate for #{from}_#{to} not found")
      nil
    end

  end
end

