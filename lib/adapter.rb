
module CurrencyRate
  class Adapter
    include Singleton

    SUPPORTED_CURRENCIES = []
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
          self.class::FETCH_URL.each_with_object({}) do |(name, url), result|
            result[name] = request url
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
        if api_key.nil?
          CurrencyRate.logger.error("API key for #{self.name} not defined")
          return nil
        end
        param_symbol = fetch_url.split("/").last.include?("?") ? "&" : "?"
        fetch_url << "#{param_symbol}#{self.class::API_KEY_PARAM}=#{api_key}" if api_key
      end
      http_client = HTTP.timeout(connect: CurrencyRate.configuration.connect_timeout, read: CurrencyRate.configuration.read_timeout)
      JSON.parse(http_client.get(fetch_url).to_s)
    end

  end
end
