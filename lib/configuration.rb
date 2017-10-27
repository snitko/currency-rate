module CurrencyRate
  class Configuration
    attr_accessor :api_keys
    attr_accessor :file_storage

    def initialize
      @api_keys     = { }
      @file_storage = { path: "" }
    end
  end
end
