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
        adapters.each do |provider|
          adapter_name = "#{provider}Adapter"
          begin
            adapter = CurrencyRate::const_get(adapter_name).instance
            rates = adapter.fetch_rates
            unless rates
              CurrencyRate.logger.warn("Synchronizer#sync!: rates for #{provider} not found")
              failed.push(provider)
              next
            end
            exchange_name = provider.downcase
            @storage.write(exchange_name, rates)
            successfull.push(provider)
          rescue StandardError => e
            failed.push(provider)
            CurrencyRate.logger.error(e)
            next
          end
        end
      end
      [successfull, failed]
    end

  end
end
