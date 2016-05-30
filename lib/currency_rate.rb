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

  def self.get(adapter_name, currency)
    adapter_class(adapter_name).rate_for(currency)
  end

  def self.convert(adapter_name, amount:, from:, to:, anchor_currency: nil)
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
    unless [to, from].include?(anchor_currency)
      amount = convert(adapter_name, amount: amount, from: from, to: anchor_currency)
      from   = anchor_currency
    end

    rate            = get(a, (from == anchor_currency) ? to : from)
    result          = from == anchor_currency ? amount.to_f*rate : amount.to_f/rate
    to == 'BTC' ? result : result.round(2)
  end

    private

    def self.adapter_class(s)
      return s unless s.kind_of?(String) # if we pass class, no need to convert
      "#{s}_adapter".classify(CurrencyRate).instance
    end

end
