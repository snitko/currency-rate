module CurrencyRate
  class Adapter
    include Singleton

    class FetchingFailed          < Exception; end
    class CurrencyNotSupported    < Exception; end

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
      rescue OpenURI::HTTPError => e
        raise FetchingFailed
      end
    end

    def rate_for(from,to)
      @storage.fetch(self.class.to_s) do
        self.fetch_rates!
      end
      nil # this should be changed in descendant classes
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
