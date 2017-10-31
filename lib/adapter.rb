module CurrencyRate
  class Adapter
    include Singleton

    FETCH_URL = nil
    API_KEY_PARAM = nil

    def name
      self.class.name.gsub /^.*::/, ""
    end

    def fetch_rates
      begin
        normalize exchange_data
      rescue StandardError => e
        CurrencyRate.logger.error("Error in #{self.name}#fetch_rates")
        CurrencyRate.logger.error(e)
        nil
      end
    end

    def normalize(data)
      if data.nil?
        CurrencyRate.logger.warn("#{self.name}#normalize: data is nil")
        return nil
      end
      true
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
      rescue StandardError => e
        CurrencyRate.logger.error("Error in #{self.name}#exchange_data")
        CurrencyRate.logger.error(e)
        nil
      end
    end

    def request(url)
      fetch_url = url
      if self.class::API_KEY_PARAM
        api_key = CurrencyRate.configuration.api_keys[self.name]
        fetch_url << "&#{self.class::API_KEY_PARAM}=#{api_key}" if api_key
      end
      http_client = HTTP.timeout(connect: 4, read: 4)
      JSON.parse(http_client.get(fetch_url).to_s)
    end

  end
end
