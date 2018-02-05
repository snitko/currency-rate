module CurrencyRate
  class Synchronizer
    attr_accessor :storage

    def initialize(storage: nil)
      @storage = storage || FileStorage.new
    end

    def sync!
      successfull = []
      failed = []
      [CurrencyRate.configuration.fiat_adapters, CurrencyRate.configuration.crypto_adapters].each do |adapters|
        adapters.each do |adapter_name|
          adapter_name = "#{adapter_name}Adapter" unless adapter_name.include? "Adapter"
          begin
            adapter = CurrencyRate::const_get(adapter_name).instance
            rates = adapter.fetch_rates
            unless rates
              CurrencyRate.logger.warn("Synchronizer#sync!: rates for #{adapter_name} not found")
              failed.push(adapter_name)
              next
            end
            exchange_name = adapter_name[0..-8].downcase
            @storage.write(exchange_name, rates)
            successfull.push(adapter_name)
          rescue StandardError => e
            failed.push(adapter_name)
            CurrencyRate.logger.error(e)
            next
          end
        end
      end
      [successfull, failed]
    end

  end
end
