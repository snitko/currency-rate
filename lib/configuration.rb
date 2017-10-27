module CurrencyRate
  class Configuration
    attr_accessor :api_keys
    attr_accessor :file_storage
    attr_accessor :logger

    def initialize
      @api_keys     = { }
      @file_storage = { path: "" }
      @logger       = {
        device: $stdout,
        level:  :info,
        formatter: nil,
       }
    end
  end
end
