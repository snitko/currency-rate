module CurrencyRate
  class Adapter
    include Singleton

    class FetchingFailed       < Exception; end
    class CurrencyNotSupported < Exception; end

    attr_accessor :try_storage_on_fetching_failed
    attr_reader   :storage

    def initialize
      @storage = Storage.new
    end

    def fetch_rates!
      raise "FETCH_URL is not defined!" unless self.class::FETCH_URL
      begin
        if self.class::FETCH_URL.kind_of?(Hash)
          @rates = {}
          self.class::FETCH_URL.each do |name, url|
            uri = URI.parse(url)
            @rates[name] = JSON.parse(uri.read(read_timeout: 4))
          end
        else
          uri = URI.parse(self.class::FETCH_URL)
          @rates = JSON.parse(uri.read(read_timeout: 4))
        end
        @rates_updated_at = Time.now
        @rates
      rescue Exception => e
        raise FetchingFailed
      end
    end

    def rate_for(from,to)
      begin
        @rates = self.storage.fetch(self.class.to_s) { self.fetch_rates! }
      rescue FetchingFailed => e
        if @try_storage_on_fetching_failed
          @rates = self.storage.data[self.class.to_s][:content]
        else
          raise e
        end
      end

      unless supports_currency_pair?(from,to)
        raise CurrencyNotSupported, "Unsupported currencies (one or both) are: #{from} -> #{to}"
      end

      # This method is further reloaded in Adapter classes, that's why
      # here it doesn't really return anything useful!

    end

    def supports_currency_pair?(c1,c2)
      supported_currency_pairs.include?("#{c1}/#{c2}".upcase) || supported_currency_pairs.include?("#{c2}/#{c1}".upcase)
    end

    # This method is supposed to be implemented for each individual adapter because the format of
    # the contents of the @rate variable is specific to each adapter. It would parse @rates and
    # extract currency pairs. Returns an array of supported currency pairs: ["USD/BTC", "EUR/BTC"]
    #
    # If you're implementing this method please note that you don't need to return a reversed pair
    # that is ["USD/BTC", "BTC/USD"] would be excessive and just ["USD/BTC"] would work,
    # because it is assumed that the adapter supports a reverse pair (see #rate_for implementation above).
    #
    # It would also be wise to use caching when implementing, that is:
    #
    #   return @supported_currency_pairs if @supported_currency_pairs
    #
    # Which would make this method parse @rates only once.
    def supported_currency_pairs
      raise "Please implement #supported_currency_pairs in your Adapter"
    end

    def cache_supported_currency_pairs
      return @supported_currency_pairs if @supported_currency_pairs
      @supported_currency_pairs = []
      yield
      @supported_currency_pairs
    end

    # Must be implemented inside every descendant class
    # because storage format may be completely different
    def get_rate_value_from_source(rates_hash, *keys)
      raise "Please implement this method in your Adapter"
    end

    # We dont want to have false positive rate, because nil.to_f is 0.0
    # This method checks that rate value is not nil
    def rate_to_f(rate)
      rate ? rate.to_f : raise(CurrencyNotSupported)
    end


    private

      def _invert_rate(rate)
        r = (BigDecimal.new('1')/BigDecimal.new(rate.to_s))
        r = r.round(decimal_precision) if decimal_precision
        r
      end

      def decimal_precision
        nil
      end

  end
end
