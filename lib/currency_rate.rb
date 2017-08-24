require 'singleton'
require 'bigdecimal'
require 'satoshi-unit'
require 'open-uri'
require 'json'

require "adapter"
require "crypto_adapter"
require "fiat_adapter"

Dir["#{File.expand_path File.dirname(__FILE__)}/**/*.rb"].each { |f| require f }

module CurrencyRate

  def self.get(adapter_name, from, to, anchor_currency: nil, try_storage_on_fetching_failed: false)

    a = adapter_instance(adapter_name)
    a.try_storage_on_fetching_failed = try_storage_on_fetching_failed

    # Setting default values for anchor currency depending on
    # which adapter type is un use.
    anchor_currency ||= if a.kind_of?(CryptoAdapter)
      a.class::SUPPORTED_CRYPTO_CURRENCIES.include?("BTC") ? "BTC" : a.class::SUPPORTED_CRYPTO_CURRENCIES.first
    else
      a.class::SUPPORTED_CURRENCIES.include?("USD") ? "USD" : a.class::SUPPORTED_CURRENCIES.first
    end if anchor_currency.nil?

    # None of the currencies is anchor currency?
    # No problem, convert the amount given into the anchor currency first.
    if [to, from].include?(anchor_currency)
      a.rate_for(from, to)
    else
      rate_from = get(adapter_name, anchor_currency, from, try_storage_on_fetching_failed: try_storage_on_fetching_failed)
      rate_to   = get(adapter_name, anchor_currency, to  , try_storage_on_fetching_failed: try_storage_on_fetching_failed)
      BigDecimal.new(rate_to.to_s)/BigDecimal.new(rate_from.to_s)
    end
  end

  def self.convert(adapter_name, amount:, from:, to:, anchor_currency: nil, try_storage_on_fetching_failed: false)
    a = adapter_instance(adapter_name)
    result = BigDecimal.new(amount.to_s)*BigDecimal.new(get(a, from, to, anchor_currency: anchor_currency, try_storage_on_fetching_failed: try_storage_on_fetching_failed).to_s)
    result.round(a.kind_of?(CryptoAdapter) && a.class::SUPPORTED_CRYPTO_CURRENCIES.include?(to) ? a.class::DECIMAL_PRECISION : 2)
  end

  def self.default_currencies_for(adapter_name)
    adapter_class(adapter_name)::DEFAULT_CURRENCIES
  end

  private

    def self.adapter_instance(s)
      return s unless s.kind_of?(String) # if we pass class, no need to convert
      adapter_class(s).instance
    end

    def self.adapter_class(s)
      classify_string("#{s}_adapter", CurrencyRate)
    end

    def self.classify_string(s, prefix="")
      s = if s !~ /[[:upper:]]/ # contains uppercase characters? Must be a class name already!
        s.split('_').collect(&:capitalize).join
      else
        s.sub("_adapter", "Adapter")
      end
      Kernel.const_get(prefix.to_s + "::" + s)
    end

end
