module CurrencyRate
  class Synchronizer
    attr_accessor :storage

    def initialize(storage: nil)
      @storage = storage || FileStorage.new
    end

    def sync!
      [CurrencyRate.configuration.fiat_adapters, CurrencyRate.configuration.crypto_adapters].each do |adapters|
        adapters.each do |adapter_name|
          adapter_name = "#{adapter_name}Adapter" unless adapter_name.include? "Adapter"
          begin
            adapter = CurrencyRate::const_get(adapter_name).instance
            rates = adapter.fetch_rates
            unless rates
              CurrencyRate.logger.warn("Synchronizer#sync!: rates for #{adapter_name} not found")
              next
            end
            exchange_name = adapter_name[0..-8].downcase
            @storage.write(exchange_name, rates)
          rescue StandardError => e
            CurrencyRate.logger.error(e)
            next
          end
        end
      end
    end

  end
end
