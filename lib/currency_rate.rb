require 'singleton'
require 'bigdecimal'
require 'satoshi-unit'
require 'open-uri'
require 'json'

require "adapter"
require "btc_adapter"
require "fiat_adapter"

Dir["#{File.expand_path File.dirname(__FILE__)}/**/*.rb"].each { |f| require f }

module CurrencyRate

  def self.get(adapter_name, from, to, anchor_currency: nil)

    a = adapter_class(adapter_name)

    # Setting default values for anchor currency depending on
    # which adapter type is un use.
    anchor_currency = if a.kind_of?(BtcAdapter)
      'BTC' if anchor_currency.nil?
    else
      'USD' if anchor_currency.nil?
    end

    # None of the currencies is anchor currency?
    # No problem, convert the amount given into the anchor currency first.
    if [to, from].include?(anchor_currency)
      a.rate_for(from, to)
    else
      rate_from = get(adapter_name, anchor_currency, from)
      rate_to   = get(adapter_name, anchor_currency, to  )
      rate_to.to_f/rate_from.to_f
    end
  end

  def self.convert(adapter_name, amount:, from:, to:, anchor_currency: nil)
    result = amount*get(adapter_name, from, to, anchor_currency: nil)
    to == 'BTC' ? result : result.round(2)
  end

    private

    def self.adapter_class(s)
      return s unless s.kind_of?(String) # if we pass class, no need to convert
      adapter = "#{s}_adapter".classify(CurrencyRate).instance
    end

end
