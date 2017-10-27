module CurrencyRate
  class Adapter
    include Singleton

    FETCH_URL = nil
    API_KEY_PARAM = nil

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

      begin
        if self.class::FETCH_URL.kind_of?(Hash)
          self.class::FETCH_URL.reduce({}) do |result, (name, url)|
            result[name] = request url
            result
          end
        else
          request self.class::FETCH_URL
        end
      rescue
        nil
      end
    end

    def request(url)
      fetch_url = url
      if self.class::API_KEY_PARAM
        api_key = CurrencyRate.configuration.api_keys[self.class.name]
        fetch_url << "&#{self.class::API_KEY_PARAM}=#{self.api_key}" if api_key
      end
      http_client = HTTP.timeout(connect: 1, read: 1)
      JSON.parse(http_client.get(fetch_url).to_s)
    end

  end
end
