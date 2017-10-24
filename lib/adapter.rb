module CurrencyRate
  class Adapter
    include Singleton

    FETCH_URL = nil

    def fetch_rates
      begin
        normalize exchange_data
      rescue
        nil
      end
    end

    def normalize(data)
      return nil if data.nil?
    end

    def exchange_data
      raise "FETCH_URL is not defined!" unless self.class::FETCH_URL
      http_client = HTTP.timeout(connect: 1, read: 1)
      begin
        if self.class::FETCH_URL.kind_of?(Hash)
          self.class::FETCH_URL.reduce({}) do |result, (name, url)|
            result[name] = JSON.parse(http_client.get(url).to_s)
            result
          end
        else
          JSON.parse(http_client.get(self.class::FETCH_URL).to_s)
        end
      rescue
        nil
      end
    end

  end
end
