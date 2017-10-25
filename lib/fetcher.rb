module CurrencyRate
  class Fetcher

    def initialize(storage: nil)
      @storage = storage || FileStorage.new
      @fiat_exchanges = ["Yahoo", "Fixer", "Forge"]
    end

    def fetch_crypto(exchange, from, to)
      crypto = from.upcase
      fiat = to.upcase
      pair = "#{from}_#{to}"
      rates = @storage.read(exchange)
      raise FetchigFailedError if rates.nil?
      return rates[pair] if rates.has_key?(pair)

      supported_crypto, supported_fiat = rates.keys.reduce([[], []]) do |result, pair|
        c, f = pair.split("_")
        result[0] << c
        result[1] << f
        result
      end.map { |x| x.uniq }
      raise CurrencyNotSupportedError.new(from) unless supported_crypto.include?(crypto)

      # If requested pair not found and exchange supports requested cryptocurrency
      # then we can convert using another supported fiat currency as an anchor
      # USD has first priority since it's most popular world currency
      if fiat != "USD" && supported_fiat.delete("USD")
        usd_fiat = fetch_fiat("USD", fiat)
        return rates["#{crypto}_USD"] * usd_fiat if usd_fiat
      end

      # We don't have usd_fiat pair so try other supported currencies as convertation anchor
      supported_fiat.each do |anchor|
        anchor_fiat = fetch_fiat(anchor, fiat)
        return rates["#{crypto}_#{anchor}"] * anchor_fiat if anchor_fiat
      end

      # We didn't find a way to fetch rate for requested pair
      raise CurrencyNotSupportedError.new(to)
    end

    def fetch_fiat(from, to)
      @fiat_exchanges.each do |exchange|
        left = from.upcase
        right = to.upcase
        rates = @storage.read(exchange)
        anchor = rates.delete("anchor")
        return rates[right] if anchor == left && rates[right]
        return BigDecimal.new(1) / rates[left] if anchor == right && rates[left]
        return rates[left] / rates[right] if rates.values.include?(left) && rates.values.include?(right)
        nil
      end
    end

  end
end
