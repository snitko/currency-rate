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
end
