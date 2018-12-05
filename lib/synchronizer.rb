module CurrencyRate
  class Synchronizer
    attr_accessor :storage

    def initialize(storage: nil)
      @storage = storage || FileStorage.new
    end

    def sync_fiat!
      debugger
      _sync CurrencyRate.configuration.fiat_adapters
    end

    def sync_crypto!
      _sync CurrencyRate.configuration.crypto_adapters
    end

    def sync!
      fiat = sync_fiat!
      crypto = sync_crypto!
      [fiat[0] | crypto[0], fiat[1] | crypto[1]]
    end

    private

    def _sync(adapters)
      successfull = []
      failed = []
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
      [successfull, failed]
    end

  end
end
