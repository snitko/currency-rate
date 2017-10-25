module CurrencyRate
  class Synchronizer
    attr_accessor :storage

    def initialize(storage: nil)
      @storage = storage || FileStorage.new
    end

    def sync!
      [CurrencyRate.fiat_adapters, CurrencyRate.crypto_adapters].each do |adapters|
        adapters.each do |adapter_name|
          begin
            adapter = CurrencyRate::const_get(adapter_name).instance
            rates = adapter.fetch_rates
            next unless rates
            exchange_name = adapter_name[0..-8].downcase
            @storage.write(exchange_name, rates)
          rescue
            next
          end
        end
      end
    end

  end
end
