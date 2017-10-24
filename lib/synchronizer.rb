module CurrencyRate
  class Synchronizer
    attr_accessor :storage

    def initialize(storage: nil)
      @storage = storage || FileStorage.new
    end

    def method_missing(m, *args, &block)
      self.send(:adapters, m[0..-10]) if m.to_s.end_with? "_adapters"
    end

    def sync!
      [fiat_adapters, crypto_adapters].each do |adapters|
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

    def adapters(type)
      Dir[File.join CurrencyRate.root, "lib/adapters/#{type}"].map do |file|
        File.basename(file, ".rb").camelize
      end
    end
  end
end
