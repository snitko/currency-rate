module CurrencyRate
  class Configuration
    attr_accessor :forge_api_key
    attr_accessor :file_storage

    def initialize
      @forge_api_key = nil
      @file_storage = { path: "" }
    end
  end
end
