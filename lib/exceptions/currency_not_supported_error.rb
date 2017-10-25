module CurrencyRate
  class CurrencyNotSupportedError < StandardError
    attr_reader :currency

    def initialize(currency = "")
      @currency = currency
      super("Currency #{currency} not supported")
    end
  end
end
