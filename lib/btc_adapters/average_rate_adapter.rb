module CurrencyRate
  class AverageRateAdapter < BtcAdapter

    DEFAULT_CURRENCIES = ["USD", "BTC"]

    # Takes exchange rate adapters instances or classes as arguments
    def self.instance(*adapters)
      instance = super()
      instance.instance_variable_set(:@adapters, adapters.map { |adapter| adapter.respond_to?(:instance) ? adapter.instance : adapter })
      instance
    end

    def fetch_rates!
      failed_fetches = 0
      @adapters.each do |adapter|
        begin
          adapter.fetch_rates!
        rescue FetchingFailed => e
          failed_fetches += 1
          raise e if failed_fetches == @adapters.size
        end
      end
    end

    def rate_for(from, to)
      rates = []
      @adapters.each do |adapter|
        begin
          rates << adapter.rate_for(from,to)
        rescue CurrencyNotSupported
          rates << nil
        end
      end

      unless rates.select(&:nil?).size == @adapters.size
        rates.compact!
        rate = rates.inject {|sum, rate| sum + rate} / rates.size
        invert_rate(from,to, rate)
      else
        raise CurrencyNotSupported
      end
    end

    def get_rate_value_from_hash(rates_hash, *keys)
      raise "This method is not supposed to be used in #{self.class}."
    end

    def rate_to_f(rate)
      raise "This method is not supposed to be used in #{self.class}."
    end

  end
end
