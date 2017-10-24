module CurrencyRate
  class Configuration
    attr_accessor :forge_api_key

    def initialize
      forge_api_key = nil
    end
  end
end
